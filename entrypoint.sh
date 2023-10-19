#!/bin/sh

PRITUNL_PROFILE_FILE="${PRITUNL_PROFILE_FILE:-}"
PRITUNL_PROFILE_SERVER="${PRITUNL_PROFILE_SERVER:-}"

# Access the profile-server input as a JSON-encoded string
server_names="$PRITUNL_PROFILE_SERVER"

echo "###"
echo "Passing Inputs..."
echo "####"
echo $server_names
echo "#####"


# Split the single string into an array if it contains commas
IFS=',' read -ra server_names <<< "$server_names"

# Loop through the server names
for server_name in "${server_names[@]}"
do
  # Use the server name in your script
  echo "Connecting to server: $server_name"
  # Add your Pritunl connection logic here
done
