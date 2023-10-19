#!/usr/bin/env bash

which bash

# PRITUNL_PROFILE_SERVER="quality-assurance, sales-marketing, research-development"

# PRITUNL_PROFILE_SERVER="quality-assurance"
# PRITUNL_PROFILE_FILE="${PRITUNL_PROFILE_FILE:-}"

PRITUNL_PROFILE_SERVER="${PRITUNL_PROFILE_SERVER:-}"

IFS=', ' read -r -a profile_server <<< "$PRITUNL_PROFILE_SERVER"

if ! [[ "${#profile_server[@]}" -eq 0 ]]; then
  for server in "${profile_server[@]}"; do
      echo "$server"
  done

else
  echo "No Profile Server!"
fi
