#!/bin/bash
set -e

# Используем правильную переменную для входа (без INPUT_ префикса)
api_url="https://up.sytes.ru/api5.php?id=$1"
echo "API URL: $api_url"

user_name=$(curl -u 'user_data_json:jjlskdfhr489jskk@klsdjf' -s -X GET "${api_url}" | jq -r ".username")
echo "User name: $user_name"

# Новый формат вывода (старый ::set-output deprecated)
echo "user_name=$user_name" >> $GITHUB_OUTPUT
