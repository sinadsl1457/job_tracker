-- 모든 테이블: 로그인한 본인 행만. (select auth.uid())는 행마다가 아니라 쿼리당 한 번 계산된다.

alter table public.profiles enable row level security;
alter table public.job_postings enable row level security;
alter table public.application_events enable row level security;
alter table public.skills enable row level security;

-- profiles: 행 생성은 가입 트리거, 삭제는 계정 삭제(cascade)만.
create policy "profiles_select_own" on public.profiles
  for select to authenticated
  using (id = (select auth.uid()));

create policy "profiles_update_own" on public.profiles
  for update to authenticated
  using (id = (select auth.uid()))
  with check (id = (select auth.uid()));

-- job_postings
create policy "job_postings_select_own" on public.job_postings
  for select to authenticated
  using (user_id = (select auth.uid()));

create policy "job_postings_insert_own" on public.job_postings
  for insert to authenticated
  with check (user_id = (select auth.uid()));

create policy "job_postings_update_own" on public.job_postings
  for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy "job_postings_delete_own" on public.job_postings
  for delete to authenticated
  using (user_id = (select auth.uid()));

-- application_events: 읽기만. 쓰기는 트리거만 한다(이력 조작 방지).
create policy "application_events_select_own" on public.application_events
  for select to authenticated
  using (user_id = (select auth.uid()));

-- skills
create policy "skills_select_own" on public.skills
  for select to authenticated
  using (user_id = (select auth.uid()));

create policy "skills_insert_own" on public.skills
  for insert to authenticated
  with check (user_id = (select auth.uid()));

create policy "skills_update_own" on public.skills
  for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy "skills_delete_own" on public.skills
  for delete to authenticated
  using (user_id = (select auth.uid()));
