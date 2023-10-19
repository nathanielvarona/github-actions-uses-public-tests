#!/bin/sh

# Get the directory of the currently executing script
SCRIPT_DIR=$(dirname "$(readlink -f "$1")")

# Print the full path of the script directory
echo "The full path of the script is: $SCRIPT_DIR"

# # Access the profile-server input as a JSON-encoded string
# profile_server_input="${{ inputs.profile-server }}"

# echo "###"
# echo "Passing Inputs..."
# echo "####"
# echo $profile_server_input
# echo "#####"

# # Check if the input is JSON-encoded, a single string, or a YAML array
# if [[ "$profile_server_input" == \[* ]]; then
#   # Input is already a Bash array (YAML format)
#   echo "Yaml List, in multi line"
#   server_names=("${profile_server_input[@]}")
# elif [[ "$profile_server_input" == *,* ]]; then
#   echo "Yaml List, in single line"
#   # Input is a comma-separated string, convert to a Bash array
#   IFS=',' read -ra server_names <<< "$profile_server_input"
# else
#   echo "Single entry, in string"
#   # Input is a single string, create a Bash array with one element
#   server_names=("$profile_server_input")
# fi

# echo "###"
# echo "Server Names in Array"
# echo "####"
# echo $server_names
# echo "#####"

# # Loop through the server names
# for server_name in "${server_names[@]}"
# do
#   # Use the server name in your script
#   echo "Connecting to server: $server_name"
#   # Add your Pritunl connection logic here
# done
