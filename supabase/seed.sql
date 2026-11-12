-- 로컬 전용 시드. supabase db reset 때 실행된다.
-- 로그인: me@test.local / other@test.local, 비밀번호 password123

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, recovery_token, email_change, email_change_token_new,
  email_change_token_current, phone_change, phone_change_token, reauthentication_token
)
select
  '00000000-0000-0000-0000-000000000000', u.id, 'authenticated', 'authenticated', u.email,
  extensions.crypt('password123', extensions.gen_salt('bf')), now(),
  '{"provider":"email","providers":["email"]}', '{}', now(), now(),
  '', '', '', '', '', '', '', ''
from (values
  ('11111111-1111-1111-1111-111111111111'::uuid, 'me@test.local'),
  ('22222222-2222-2222-2222-222222222222'::uuid, 'other@test.local')
) as u (id, email);

insert into auth.identities (id, user_id, provider_id, provider, identity_data, last_sign_in_at, created_at, updated_at)
select gen_random_uuid(), id, id::text, 'email',
       json_build_object('sub', id::text, 'email', email, 'email_verified', true),
       now(), now(), now()
from auth.users
where id in ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222');

update public.profiles set display_name = '나' where id = '11111111-1111-1111-1111-111111111111';
update public.profiles set display_name = '다른 사람' where id = '22222222-2222-2222-2222-222222222222';

-- 시드는 postgres 권한으로 돌아서 user_id를 직접 넣는다.
insert into public.job_postings (user_id, company, position, channel, deadline, location, employment_type, memo, stage_changed_at)
values
  ('11111111-1111-1111-1111-111111111111', '토끼마켓', 'Flutter 개발자', 'wanted', current_date + 1, '서울 강남구', 'full_time', '마감 내일', now() - interval '20 days'),
  ('11111111-1111-1111-1111-111111111111', '거북페이', '모바일 앱 개발자', 'jobkorea', current_date + 7, '서울 성동구', 'full_time', null, now() - interval '18 days'),
  ('11111111-1111-1111-1111-111111111111', '고래헬스', 'Flutter 엔지니어', 'saramin', current_date + 14, '판교', 'contract', null, now() - interval '19 days'),
  ('11111111-1111-1111-1111-111111111111', '참새랩', '앱 개발 인턴', 'other', null, '원격', 'intern', '지인 추천', now() - interval '3 days'),
  ('22222222-2222-2222-2222-222222222222', '다른사람회사', '백엔드 개발자', 'wanted', current_date + 3, '부산', 'full_time', '나에게 보이면 안 됨', now());

-- 단계 변경을 날짜와 함께 거쳐서 이력을 만든다(통계 화면 확인용).
update public.job_postings set stage = 'applied', stage_changed_at = now() - interval '17 days' where company in ('거북페이', '고래헬스');
update public.job_postings set stage = 'viewed', stage_changed_at = now() - interval '12 days' where company in ('거북페이', '고래헬스');
update public.job_postings set stage = 'doc_passed', stage_changed_at = now() - interval '8 days' where company = '거북페이';
update public.job_postings set stage = 'interview_1', stage_changed_at = now() - interval '2 days' where company = '거북페이';
update public.job_postings set stage = 'rejected', stage_changed_at = now() - interval '5 days' where company = '고래헬스';
update public.job_postings set stage = 'applied', stage_changed_at = now() - interval '1 day' where company = '참새랩';
