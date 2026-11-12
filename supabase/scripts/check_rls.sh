#!/usr/bin/env bash
# 앱·웹과 같은 경로(REST API + 로그인 토큰)로 RLS를 확인한다.
# 준비: supabase start && supabase db reset (시드 계정 생성)
set -euo pipefail

eval "$(supabase status -o env 2>/dev/null | grep -E '^(API_URL|ANON_KEY)=')"
API="$API_URL"
KEY="$ANON_KEY"
fail=0

login() {
  curl -s "$API/auth/v1/token?grant_type=password" \
    -H "apikey: $KEY" -H 'Content-Type: application/json' \
    -d "{\"email\":\"$1\",\"password\":\"password123\"}" |
    python3 -c 'import sys, json; print(json.load(sys.stdin)["access_token"])'
}

check() { # 설명, 기대값, 실제값
  if [ "$2" = "$3" ]; then echo "통과  $1"; else echo "실패  $1 (기대 $2, 실제 $3)"; fail=1; fi
}

ME=$(login me@test.local)
OTHER_ID=22222222-2222-2222-2222-222222222222

count() { # 토큰(빈 값이면 익명), 경로
  local auth=()
  [ -n "$1" ] && auth=(-H "Authorization: Bearer $1")
  curl -s "$API/rest/v1/$2" -H "apikey: $KEY" ${auth[@]+"${auth[@]}"} |
    python3 -c 'import sys, json; print(len(json.load(sys.stdin)))'
}

check "내 공고만 보인다(4개)" 4 "$(count "$ME" 'job_postings?select=id')"
check "다른 사람 공고는 0개" 0 "$(count "$ME" "job_postings?select=id&user_id=eq.$OTHER_ID")"
check "다른 사람 이력은 0개" 0 "$(count "$ME" "application_events?select=id&user_id=eq.$OTHER_ID")"
check "로그인 안 하면 0개" 0 "$(count '' 'job_postings?select=id')"

status=$(curl -s -o /dev/null -w '%{http_code}' -X POST "$API/rest/v1/job_postings" \
  -H "apikey: $KEY" -H "Authorization: Bearer $ME" -H 'Content-Type: application/json' \
  -d "{\"company\":\"끼워넣기\",\"position\":\"x\",\"user_id\":\"$OTHER_ID\"}")
check "다른 사람 명의로 등록하면 거부(403)" 403 "$status"

patched=$(curl -s -X PATCH "$API/rest/v1/job_postings?user_id=eq.$OTHER_ID" \
  -H "apikey: $KEY" -H "Authorization: Bearer $ME" -H 'Content-Type: application/json' \
  -H 'Prefer: return=representation' -d '{"memo":"해킹"}' |
  python3 -c 'import sys, json; print(len(json.load(sys.stdin)))')
check "다른 사람 공고 수정은 0행" 0 "$patched"

exit $fail
