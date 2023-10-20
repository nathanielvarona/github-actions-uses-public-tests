#!/usr/bin/env bash

# Examples:

# PRITUNL_PROFILE_SERVER=
# PRITUNL_PROFILE_SERVER="all-profile-server"

# PRITUNL_PROFILE_SERVER="pritunl-dev-1"
# PRITUNL_PROFILE_SERVER="pritunl-dev-2"
# PRITUNL_PROFILE_SERVER="pritunl-dev-1, pritunl-dev-2"
# PRITUNL_PROFILE_SERVER="pritunl-dev-1, pritunl-dev-2, pritunl-dev-3"
# PRITUNL_PROFILE_SERVER="pritunl-dev-3"

# # PRITUNL_PROFILE_SERVER="pritunl.profile.1 (pritunl-dev-1)"
# PRITUNL_PROFILE_SERVER="pritunl.profile.1 (pritunl-dev-2)"
# PRITUNL_PROFILE_SERVER="pritunl.profile.1 (pritunl-dev-1), pritunl.profile.1 (pritunl-dev-2)"
# PRITUNL_PROFILE_SERVER="pritunl.profile.1 (pritunl-dev-1), pritunl.profile.1 (pritunl-dev-2), pritunl.profile.1 (pritunl-dev-3)"

PRITUNL_PROFILE_FILE="${PRITUNL_PROFILE_FILE:-}"
PRITUNL_PROFILE_SERVER="${PRITUNL_PROFILE_SERVER:-}"

echo "deb https://repo.pritunl.com/stable/apt $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/pritunl.list
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A > /dev/null 2>&1
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc > /dev/null
sudo apt-get update -qq -y
sudo apt-get install -qq -y net-tools iptables openvpn resolvconf
sudo apt-get install -qq -y pritunl-client

sleep 2

# Hard way for testing
profile_base64="$PRITUNL_PROFILE_FILE"
profile_file="$RUNNER_TEMP/profile-file.tar"
echo "$profile_base64" | base64 -d > "$profile_file"
pritunl-client add "$profile_file"

sleep 3

fetch_profile_server() {
  local profile_list_json
  local profile_server_array
  local profile_server_object
  local profile_server_matching
  local profile_server_json

  # Fetch the profile list JSON
  profile_list_json=$(pritunl-client list -j | jq -c 'sort_by(.name)')

  if [[ -n "$PRITUNL_PROFILE_SERVER" ]]; then

    if [[ "$PRITUNL_PROFILE_SERVER" == "all-profile-server" ]]; then
      # If "all-profile-server" is set, return the entire profile list
      profile_server_json="$profile_list_json"
    else

      # Split the comma-separated profile server names into an array
      IFS=',' read -r -a profile_server_array <<< "$PRITUNL_PROFILE_SERVER"

      # Remove leading and trailing spaces from each element in the array
      for i in "${!profile_server_array[@]}"; do
        profile_server_array[$i]=$(echo "${profile_server_array[$i]}" | sed -e 's/^[[:space:]]*//; s/[[:space:]]*$//')
      done

      # Initialize an empty array to store matching profiles
      profile_server_matching=()

      for profile_server in "${profile_server_array[@]}"; do
        # Try to find the profile server JSON based on the current profile server name
        profile_server_object=$(echo "$profile_list_json" | jq -c --arg profile "$profile_server" '.[] | select(.name | contains($profile))')

        if [[ -n "$profile_server_object" ]]; then
          profile_server_matching+=("$profile_server_object")
        fi
      done

      if [[ ${#profile_server_matching[@]} -gt 0 ]]; then
        # If matching profiles were found, print them as a JSON array
        profile_server_json=$(
          echo "["
            for ((i=0; i<${#profile_server_matching[@]}; i++)); do
              echo "${profile_server_matching[i]}"
              if [ $i -lt $((${#profile_server_matching[@]}-1)) ]; then
                echo ","
              fi
            done
          echo "]"
        )
      else
        profile_server_json="[]"
      fi
    fi
  else
    # If environment variable is not set, return the first profile
    profile_server_json="[$(echo "$profile_list_json" | jq -c ".[0]")]"
  fi

  echo "$profile_server_json" | jq -c -M
}

echo $(fetch_profile_server | jq)
