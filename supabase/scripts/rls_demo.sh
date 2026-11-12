#!/usr/bin/env bash
# 학습용: 같은 요청을 출입증(토큰) 없이 / me로 / other로 보내 RLS 결과를 비교한다.
# 실행: ./supabase/scripts/rls_demo.sh   (supabase start, db reset 뒤)
set -euo pipefail

eval "$(supabase status -o env 2>/dev/null | grep -E '^(API_URL|PUBLISHABLE_KEY)=')"
API="$API_URL"
KEY="$PUBLISHABLE_KEY"

# 1. 로그인해서 출입증(토큰) 받기
token() {
  curl -s "$API/auth/v1/token?grant_type=password" \
    -H "apikey: $KEY" -H 'Content-Type: application/json' \
    -d "{\"email\":\"$1\",\"password\":\"password123\"}" |
    python3 -c 'import sys, json; print(json.load(sys.stdin)["access_token"])'
}
ME=$(token me@test.local)
OTHER=$(token other@test.local)

list() { # 출입증(없으면 빈 값)
  local auth=()
  [ -n "$1" ] && auth=(-H "Authorization: Bearer $1")
  curl -s "$API/rest/v1/job_postings?select=company" -H "apikey: $KEY" ${auth[@]+"${auth[@]}"}
  echo
}

echo "== 2. 출입증 없이 공고 목록 요청"; list ''
echo "== 3. me 출입증으로 같은 요청"; list "$ME"
echo "== 4. other 출입증으로 같은 요청"; list "$OTHER"

echo "== 5. me가 다른 사람 공고 수정 시도"
curl -s -X PATCH "$API/rest/v1/job_postings?company=eq.다른사람회사" \
  -H "apikey: $KEY" -H "Authorization: Bearer $ME" -H 'Content-Type: application/json' \
  -H 'Prefer: return=representation' -d '{"memo":"해킹"}'
echo

echo "== 6. me가 다른 사람 명의로 공고 등록 시도"
curl -s -X POST "$API/rest/v1/job_postings" \
  -H "apikey: $KEY" -H "Authorization: Bearer $ME" -H 'Content-Type: application/json' \
  -d '{"company":"끼워넣기","position":"x","user_id":"22222222-2222-2222-2222-222222222222"}'
echo

echo "== 7. me 출입증 가운데 부분을 풀어 보기"
echo "$ME" | cut -d. -f2 | python3 -c '
import sys, base64, json
s = sys.stdin.read().strip(); s += "=" * (-len(s) % 4)
d = json.loads(base64.urlsafe_b64decode(s))
print({k: d[k] for k in ("sub", "email", "role")})'
