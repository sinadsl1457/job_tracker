-- 단계 이력은 DB가 남긴다. 앱·웹은 job_postings.stage만 바꾸면 된다.

-- 저장 직전: updated_at 갱신, 단계가 바뀌면 stage_changed_at 기록.
-- 클라이언트가 stage_changed_at을 직접 넣으면(예전 지원을 뒤늦게 등록) 그 날짜를 쓰되 미래는 막는다.
create function public.job_postings_before_write()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if tg_op = 'UPDATE' then
    new.updated_at := now();
    new.created_at := old.created_at;
    if new.stage is distinct from old.stage
       and new.stage_changed_at is not distinct from old.stage_changed_at then
      new.stage_changed_at := now();
    end if;
    if new.stage is distinct from old.stage and new.stage_changed_at < old.stage_changed_at then
      raise exception 'stage_changed_at은 이전 단계보다 빠를 수 없다' using errcode = '22023';
    end if;
  end if;

  if new.stage_changed_at > now() + interval '1 minute' then
    raise exception 'stage_changed_at은 미래일 수 없다' using errcode = '22023';
  end if;

  return new;
end;
$$;

create trigger job_postings_before_write
  before insert or update on public.job_postings
  for each row execute function public.job_postings_before_write();

-- 저장 직후: 이력 한 줄. application_events에는 클라이언트 insert 정책이 없어서
-- security definer(함수 주인 권한)로 넣는다.
create function public.job_postings_record_stage()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if tg_op = 'INSERT' or new.stage is distinct from old.stage then
    insert into public.application_events (posting_id, user_id, from_stage, to_stage, changed_at)
    values (
      new.id,
      new.user_id,
      case when tg_op = 'UPDATE' then old.stage end,
      new.stage,
      new.stage_changed_at
    );
  end if;
  return new;
end;
$$;

create trigger job_postings_record_stage
  after insert or update of stage on public.job_postings
  for each row execute function public.job_postings_record_stage();
