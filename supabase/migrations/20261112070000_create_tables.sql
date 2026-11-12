-- 지원 단계·채널·고용형태는 값이 정해져 있어서 enum으로 막는다.
create type public.application_stage as enum (
  'interested',
  'applied',
  'viewed',
  'doc_passed',
  'assignment',
  'interview_1',
  'interview_2',
  'final_passed',
  'rejected',
  'on_hold'
);

create type public.job_channel as enum ('jobkorea', 'wanted', 'saramin', 'other');

create type public.employment_type as enum ('full_time', 'contract', 'intern', 'freelance', 'other');

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now()
);

-- 혼자 쓰는 서비스라 공고 1개 = 지원 1건. 공고와 지원을 한 테이블에 둔다.
create table public.job_postings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  company text not null check (length(btrim(company)) > 0),
  position text not null check (length(btrim(position)) > 0),
  url text,
  channel public.job_channel not null default 'other',
  deadline date,
  location text,
  employment_type public.employment_type,
  memo text,
  stage public.application_stage not null default 'interested',
  stage_changed_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  -- 이력 테이블이 (공고, 주인) 쌍으로 참조해서 남의 공고에 이력이 붙지 못하게 한다.
  unique (id, user_id)
);

create index job_postings_user_stage_idx on public.job_postings (user_id, stage);
create index job_postings_user_deadline_idx on public.job_postings (user_id, deadline);

create table public.application_events (
  id bigint generated always as identity primary key,
  posting_id uuid not null,
  user_id uuid not null,
  from_stage public.application_stage,
  to_stage public.application_stage not null,
  changed_at timestamptz not null default now(),
  foreign key (posting_id, user_id) references public.job_postings (id, user_id) on delete cascade
);

create index application_events_user_changed_idx on public.application_events (user_id, changed_at);
create index application_events_posting_changed_idx on public.application_events (posting_id, changed_at);

create table public.skills (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  name text not null check (length(btrim(name)) > 0),
  created_at timestamptz not null default now()
);

-- "Flutter"와 "flutter"를 같은 기술로 본다.
create unique index skills_user_name_key on public.skills (user_id, lower(btrim(name)));

-- 가입하면 profiles 행을 자동으로 만든다. 클라이언트는 profiles에 insert하지 않는다.
create function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id) values (new.id);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
