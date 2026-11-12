-- 실행: supabase test db
-- 사용자 A·B를 만들고, 서로의 데이터에 접근하지 못하는지와 단계 이력 트리거를 확인한다.
begin;
select plan(25);

insert into auth.users (id, email) values
  ('aaaaaaaa-0000-0000-0000-000000000001', 'a@test.local'),
  ('bbbbbbbb-0000-0000-0000-000000000002', 'b@test.local');

create function pg_temp.login_as(uid uuid) returns void language sql as $$
  select set_config('role', 'authenticated', true),
         set_config('request.jwt.claims', json_build_object('sub', uid, 'role', 'authenticated')::text, true);
$$;

-- 가입 트리거
select is(
  (select count(*)::int from public.profiles
   where id in ('aaaaaaaa-0000-0000-0000-000000000001', 'bbbbbbbb-0000-0000-0000-000000000002')),
  2,
  '가입하면 profiles 행이 자동으로 생긴다'
);

-- B의 데이터
select pg_temp.login_as('bbbbbbbb-0000-0000-0000-000000000002');
insert into public.job_postings (id, company, position)
  values ('bbbbbbbb-1111-0000-0000-000000000000', 'B회사', 'B포지션');
insert into public.skills (name) values ('Kotlin');

-- A의 데이터
select pg_temp.login_as('aaaaaaaa-0000-0000-0000-000000000001');
select lives_ok(
  $$ insert into public.job_postings (id, company, position, channel, stage_changed_at)
     values ('aaaaaaaa-1111-0000-0000-000000000000', 'A회사', 'Flutter 개발자', 'wanted', '2026-10-20 10:00+09') $$,
  'A는 자기 공고를 등록할 수 있다'
);
select is(
  (select user_id from public.job_postings where id = 'aaaaaaaa-1111-0000-0000-000000000000'),
  'aaaaaaaa-0000-0000-0000-000000000001'::uuid,
  'user_id를 안 넣어도 로그인한 사람으로 채워진다'
);

-- 읽기 차단
select is((select count(*)::int from public.job_postings), 1, 'A에게는 자기 공고 1개만 보인다');
select is_empty($$ select 1 from public.job_postings where company = 'B회사' $$, 'A는 B의 공고를 읽을 수 없다');
select is_empty($$ select 1 from public.application_events where user_id = 'bbbbbbbb-0000-0000-0000-000000000002' $$, 'A는 B의 단계 이력을 읽을 수 없다');
select is_empty($$ select 1 from public.skills where name = 'Kotlin' $$, 'A는 B의 기술 목록을 읽을 수 없다');
select is((select count(*)::int from public.profiles), 1, 'A에게는 자기 profile만 보인다');

-- 쓰기 차단
select is_empty(
  $$ update public.job_postings set memo = '해킹' where id = 'bbbbbbbb-1111-0000-0000-000000000000' returning id $$,
  'A는 B의 공고를 고칠 수 없다(0행)'
);
select is_empty(
  $$ delete from public.job_postings where id = 'bbbbbbbb-1111-0000-0000-000000000000' returning id $$,
  'A는 B의 공고를 지울 수 없다(0행)'
);
select throws_ok(
  $$ insert into public.job_postings (company, position, user_id)
     values ('끼워넣기', 'x', 'bbbbbbbb-0000-0000-0000-000000000002') $$,
  '42501', null,
  'A는 B 명의로 공고를 만들 수 없다'
);
select throws_ok(
  $$ update public.job_postings set user_id = 'bbbbbbbb-0000-0000-0000-000000000002'
     where id = 'aaaaaaaa-1111-0000-0000-000000000000' $$,
  '42501', null,
  'A는 자기 공고를 B에게 넘길 수 없다'
);
select throws_ok(
  $$ insert into public.skills (name, user_id) values ('Swift', 'bbbbbbbb-0000-0000-0000-000000000002') $$,
  '42501', null,
  'A는 B 명의로 기술을 만들 수 없다'
);
select throws_ok(
  $$ insert into public.application_events (posting_id, user_id, to_stage)
     values ('aaaaaaaa-1111-0000-0000-000000000000', 'aaaaaaaa-0000-0000-0000-000000000001', 'final_passed') $$,
  '42501', null,
  '이력은 클라이언트가 직접 쓸 수 없다(자기 공고라도)'
);
select is_empty(
  $$ update public.profiles set display_name = 'x' where id = 'bbbbbbbb-0000-0000-0000-000000000002' returning id $$,
  'A는 B의 profile을 고칠 수 없다(0행)'
);

-- 단계 이력 트리거
select results_eq(
  $$ select from_stage::text, to_stage::text from public.application_events
     where posting_id = 'aaaaaaaa-1111-0000-0000-000000000000' $$,
  $$ values (null::text, 'interested'::text) $$,
  '등록하면 첫 이력(없음 → 관심)이 생긴다'
);

update public.job_postings set stage = 'applied', stage_changed_at = '2026-10-25 10:00+09'
  where id = 'aaaaaaaa-1111-0000-0000-000000000000';
update public.job_postings set memo = '단계는 그대로' where id = 'aaaaaaaa-1111-0000-0000-000000000000';
update public.job_postings set stage = 'applied' where id = 'aaaaaaaa-1111-0000-0000-000000000000';

select results_eq(
  $$ select from_stage::text, to_stage::text from public.application_events
     where posting_id = 'aaaaaaaa-1111-0000-0000-000000000000' order by id $$,
  $$ values (null::text, 'interested'::text), ('interested', 'applied') $$,
  '단계가 바뀔 때만 이력이 쌓인다(메모 수정·같은 단계 재저장은 제외)'
);

select lives_ok(
  $$ update public.job_postings set stage = 'viewed', stage_changed_at = '2026-11-01 10:00+09'
     where id = 'aaaaaaaa-1111-0000-0000-000000000000' $$,
  '바뀐 날짜를 직접 넣을 수 있다(예전 지원 뒤늦게 기록)'
);
select is(
  (select changed_at from public.application_events
   where posting_id = 'aaaaaaaa-1111-0000-0000-000000000000' and to_stage = 'viewed'),
  '2026-11-01 10:00+09'::timestamptz,
  '직접 넣은 날짜가 이력에 그대로 남는다'
);
select throws_ok(
  $$ update public.job_postings set stage = 'doc_passed', stage_changed_at = now() + interval '1 day'
     where id = 'aaaaaaaa-1111-0000-0000-000000000000' $$,
  '22023', null,
  '미래 날짜는 거부한다'
);
select throws_ok(
  $$ update public.job_postings set stage = 'doc_passed', stage_changed_at = '2026-10-01 10:00+09'
     where id = 'aaaaaaaa-1111-0000-0000-000000000000' $$,
  '22023', null,
  '이전 단계보다 빠른 날짜는 거부한다(이력 순서가 꼬이지 않게)'
);

-- 기술 중복
insert into public.skills (name) values ('Flutter');
select throws_ok(
  $$ insert into public.skills (name) values (' flutter ') $$,
  '23505', null,
  '대소문자·앞뒤 공백만 다른 기술은 중복으로 막는다'
);

-- 공고를 지우면 이력도 지워진다
delete from public.job_postings where id = 'aaaaaaaa-1111-0000-0000-000000000000';
select is_empty(
  $$ select 1 from public.application_events where posting_id = 'aaaaaaaa-1111-0000-0000-000000000000' $$,
  '공고를 지우면 이력도 같이 지워진다'
);

-- 로그인하지 않은 요청
select set_config('role', 'anon', true), set_config('request.jwt.claims', '{"role":"anon"}', true);
select is_empty($$ select 1 from public.job_postings $$, '로그인하지 않으면 공고가 하나도 안 보인다');
select throws_ok(
  $$ insert into public.job_postings (company, position) values ('익명', 'x') $$,
  null, null,
  '로그인하지 않으면 공고를 만들 수 없다'
);

select * from finish();
rollback;
