#!/bin/bash
set -e

# Используем правильную переменную для входа (без INPUT_ префикса)
api_url="https://jsonplaceholder.typicode.com/users/$1"
echo "API URL: $api_url"

user_name=$(curl -s "${api_url}" | jq -r ".name")
echo "User name: $user_name"

# Новый формат вывода (старый ::set-output deprecated)
echo "user_name=$user_name" >> $GITHUB_OUTPUT
