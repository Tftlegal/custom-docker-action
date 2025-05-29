################ FORK SERVICE - GITGUB ACTIONS3 #################
```
###################################################################### CUSTOM ACTIONS ########################################################################
#Кастомный action
В GitHub Marketplace есть отдельный раздел, посвященный Actions. Некоторые из них созданы известными компаниями,
но бóльшая часть публикуется разработчиками. Но допустим, не удалось найти готовое решение для решения задачи.
В таком случае можно воспользоваться инструкцией и содать кастомный action.
Код action может написан на языке JavaScript или быть собран в виде Docker-образа.

Общий принцип создания action — нужен отдельный репозиторий, 
который будет содержать файл action.yml и все прочие файлы, необходимые для работы action.

name: Название action
author: Автор action
description: Описание action

#Action как Docker-образ
Наш кастомный action будет выполнять простой bash-скрипт. Этот скрипт будет обращаться к php REST API (как у сервиса JSON Placeholder) и получать имя пользователя по идентификатору.
API который будет иосользоваться для получения информации о пользователях и сервисах: https://up.sytes.ru/api5.php
#Пример зпроста который будет осуществляться докер контейнером  и возвращать информацию о имени пользователя по его ID ( Для тестирования ) 

curl -s "https://up.sytes.ru/api5.php?id=122" | jq -r ".username"

#Глобальный запрос через СF:

curl -u 'user_data_json:jjlskdfhr489jskk@klsdjf' -s -X GET https://up.sytes.ru/api5.php | jq '.[]'

#Локальный запрос информации обо всех пользователях:

curl -s -X GET http://api.sytes.ru:3605/api5.php | jq '.[]'

{
  "id": "122",
  "username": "lxcdebia",
  "server": "1",
  "dedicatedip": "",
  "orderid": "22",
  "regdate": "2023-11-20",
  "termination_date": "0000-00-00",
  "relid": "122",
  "Template": "debian-12-standard_12.2-1_amd64.tar.zst | Debian12",
  "Password": "i-6St7Yi7D9bC@",
  "Login": "lxcdebia",
  "Sshkey": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzwmkL+3+s+P3znLOx61yGThNn6oK2CWMGTXvSNM3Gd9oIbAWEh+hSOfdFFwTZO4T6KheiyUP3yT5nlyPCZwP6KfTYp7IjXxazlMJ6F0gzGbAsSDbSfWL1EXkw1oeA4FlzkOMGIauZDT9Vl1YFqsv85G/pqRX2ZbvsElf12HeM8KbDwcZo/aDn+g0p4ASK+gdMlnu6X1E1AcZlORYNYBlZTwfneEbFuzc1GuM3wb2Bc14+9PmlmeD5TcVLO7FyWan77leNW2WFSG5L2iOo6Knzc5cgGSLfLS2ik1NjzObIZ5v9XdZpLDSfuBroOtq59tTxow9SRglGOdGPOiZS/T/5 root@file",
  "Telegramid": "7357505348",
  "Telegram": null
}
{
  "id": "123",
  "username": "lxcdebi1",
  "server": "1",
  "dedicatedip": "",
  "orderid": "23",
  "regdate": "2023-11-20",
  "termination_date": "0000-00-00",
  "relid": "123",
  "Template": "debian-11-standard_11.7-1_amd64.tar.zst | Debian11",
  "Password": "b76s6@]BMSJw8j",
  "Login": "lxcdebi1",
  "Sshkey": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzwmkL+3+s+P3znLOx61yGThNn6oK2CWMGTXvSNM3Gd9oIbAWEh+hSOfdFFwTZO4T6KheiyUP3yT5nlyPCZwP6KfTYp7IjXxazlMJ6F0gzGbAsSDbSfWL1EXkw1oeA4FlzkOMGIauZDT9Vl1YFqsv85G/pqRX2ZbvsElf12HeM8KbDwcZo/aDn+g0p4ASK+gdMlnu6X1E1AcZlORYNYBlZTwfneEbFuzc1GuM3wb2Bc14+9PmlmeD5TcVLO7FyWan77leNW2WFSG5L2iOo6Knzc5cgGSLfLS2ik1NjzObIZ5v9XdZpLDSfuBroOtq59tTxow9SRglGOdGPOiZS/T/5 root@file",
  "Telegramid": "7357505348",
  "Telegram": null
}

Вот реализация на PHP, которая имитирует поведение API, возвращающего данные пользователя по его id. 
Функция будет вынесена в отдельный файл, а затем использована в основном скрипте.

1. Создадим файл api_functions.php с универсальной функцией php

<?php
// Функция для получения данных пользователя по ID из "мок-базы" (в реальности тут будет запрос к БД)
function getUserById($userId, $usersData) {
    foreach ($usersData as $user) {
        if ($user['id'] == $userId) {
            return $user;
        }
    }
    return null;
}

// Подключение к БД (пример для MySQLi)
function getUsersFromDatabase() {
    $dbHost = 'localhost';
    $dbUser = 'username';
    $dbPass = 'password';
    $dbName = 'database_name';

    $conn = new mysqli($dbHost, $dbUser, $dbPass, $dbName);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    $sql = "SELECT * FROM users"; // Замените на ваш запрос
    $result = $conn->query($sql);

    $users = [];
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $users[] = $row;
        }
    }

    $conn->close();
    return $users;
}
?>


2. Основной файл api5.php для обработки запросов
   
<?php
header('Content-Type: application/json');

// Подключаем функции
require_once 'api_functions.php';

// Получаем данные (в реальности - из БД)
$usersData = [
    [
        "id" => "122",
        "username" => "lxcdebia",
        "server" => "1",
        // ... остальные поля как в вашем примере
    ],
    [
        "id" => "123",
        "username" => "lxcdebi1",
        "server" => "1",
        // ... и т.д.
    ]
];

// ИЛИ, если данные берутся из БД:
// $usersData = getUsersFromDatabase();

// Проверяем, передан ли ID в запросе
if (isset($_GET['id'])) {
    $userId = $_GET['id'];
    $user = getUserById($userId, $usersData);
    
    if ($user) {
        echo json_encode($user, JSON_PRETTY_PRINT);
    } else {
        http_response_code(404);
        echo json_encode(["error" => "User not found"]);
    }
} else {
    // Если ID не указан, возвращаем всех пользователей
    echo json_encode($usersData, JSON_PRETTY_PRINT);
}
?>

Как это работает:
Без параметра ID:
Запрос GET /api5.php вернет всех пользователей в формате JSON.

С параметром ID:
Запрос GET /api5.php?id=122 вернет только данные пользователя с id=122.

Ошибка 404:
Если пользователь не найден, вернется HTTP-код 404 с сообщением об ошибке.

Пример запросов через curl:

# Получить всех пользователей
curl -s http://api.sytes.ru:3605/api5.php | jq

# Получить конкретного пользователя
curl -s "http://api.sytes.ru:3605/api5.php?id=122" | jq

Для реального использования с БД:
Замените getUsersFromDatabase() на ваш реальный запрос к БД.
Настройте подключение к вашей СУБД (MySQL, PostgreSQL и т.д.).
Добавьте обработку ошибок и, при необходимости, аутентификацию API.

Эта реализация следует REST-подходу и аналогична работе JSONPlaceholder, который вы упоминали в предыдущем вопросе.
