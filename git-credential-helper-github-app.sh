#!/usr/bin/env bash
set -euo pipefail

APP_ID_FILE="$(pwd)/app_id"
INSTALLATION_ID_FILE="$(pwd)/installation_id"
KEY_FILE="$(pwd)/github-app.private-key.pem"

APP_ID="$(<"$APP_ID_FILE")"
INSTALLATION_ID="$(<"$INSTALLATION_ID_FILE")"

b64() { openssl base64 -e -A | tr '+/' '-_' | tr -d '='; }

now=$(date +%s)
iat=$((now - 60))
exp=$((now + 540))

header='{"alg":"RS256","typ":"JWT"}'
payload=$(jq -nc \
  --arg iat "$iat" \
  --arg exp "$exp" \
  --arg iss "$APP_ID" \
  '{iat: ($iat|tonumber), exp: ($exp|tonumber), iss: ($iss|tonumber)}')

jwt="$(echo -n "$header" | b64).$(echo -n "$payload" | b64)"
sig=$(echo -n "$jwt" | openssl dgst -sha256 -sign "$KEY_FILE" | b64)
jwt="$jwt.$sig"

github_api_response=$(curl \
  --request POST \
  --silent \
  --url "https://api.github.com/app/installations/$INSTALLATION_ID/access_tokens" \
  --header "Accept: application/vnd.github+json" \
  --header "Authorization: Bearer $jwt" \
  --header "X-GitHub-Api-Version: 2022-11-28")
token=$(echo $github_api_response | jq -r .token)

# Output in git-credential format
echo "username=x-access-token"
echo "password=$token"
