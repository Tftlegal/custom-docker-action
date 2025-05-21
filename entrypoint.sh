#!/bin/bash
set -e

api_url="https://jsonplaceholder.typicode.com/users/${INPUT_USER_ID}"
echo $api_url

user_name=$(curl "${api_url}" | jq ".name")
echo $user_name

echo "::set-output name=user_name::$user_name"
