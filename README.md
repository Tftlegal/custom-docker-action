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
Наш кастомный action будет выполнять простой bash-скрипт. Этот скрипт будет обращаться к php REST API (как у сервиса JSON Placeholder) и получать имя пользователя(и нетолько) по идентификатору.
API который будет иосользоваться для получения информации о пользователях и сервисах: https://up.sytes.ru/api5.php

#Примеры зпросов которые будут осуществляться докер контейнером  и возвращать информацию о имени пользователя по его ID ( Для тестирования )
#Запросить username  пользователя c ID 122 
curl  -u 'user_data_json:jjlskdfhr489jskk@klsdjf' -s -X GET https://up.sytes.ru/api5.php?id=122 | jq -r ".username"
#Запросить заказ пользователя c ID 122
curl  -u 'user_data_json:jjlskdfhr489jskk@klsdjf' -s -X GET https://up.sytes.ru/api5.php?id=122 | jq -r ".orderid"
#Запросить Telegramid пользователя c ID 122
curl  -u 'user_data_json:jjlskdfhr489jskk@klsdjf' -s -X GET https://up.sytes.ru/api5.php?id=122 | jq -r ".Telegramid"
#Запросить Telegram пользователя c ID 122
curl  -u 'user_data_json:jjlskdfhr489jskk@klsdjf' -s -X GET https://up.sytes.ru/api5.php?id=122 | jq -r ".Telegram"

curl  -s -X GET http://api.sytes.ru:3605/api5.php?id=400 | jq -r ".username"

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

Вот реализация на функции PHP, которая имитирует поведение API JSONPlaceholder, возвращающего данные пользователя по его id. 
Функция будет вынесена в отдельный файл, а затем использована в основном скрипте.

1. Создадим файл api_functions.php с универсальной функцией php
Вот переработанная функция для api_functions.php, которая будет работать с уже подготовленными данными из $result без дополнительных запросов к БД:
cat    /var/www/laravel/public/db/api_functions.php

<?php
// api_functions.php

/**
 * Ищет пользователя по ID в предварительно загруженных данных
 * 
 * @param array $allUsersData Массив со всеми пользователями (из $result)
 * @param mixed $userId ID пользователя для поиска (строка или число)
 * @return array|null Данные пользователя или null если не найден
 */
function getUserFromPreloadedData($allUsersData, $userId) {
    // Приводим ID к строке для сравнения (если в данных ID как строки)
    $userId = (string)$userId;
    
    foreach ($allUsersData as $user) {
        if ((string)$user['id'] === $userId) {
            return $user;
        }
    }
    
    return null;
}

/**
 * Получает всех пользователей из предзагруженных данных
 * 
 * @param array $allUsersData Массив со всеми пользователями
 * @return array Массив пользователей
 */
function getAllUsersFromPreloadedData($allUsersData) {
    return $allUsersData;
}


2. Основной файл api5.php для обработки запросов
cat    /var/www/laravel/public/db/api5.php
   
Обновленный файл api5.php:
php
Copy
<?php
header('Content-Type: application/json');

require_once 'tblhosting.php';
require_once 'api_functions.php';

// Ваша существующая логика формирования $result
$result = [];

foreach ($dataArray1 as $item1) {
    $match = null;
    foreach ($dataArray2 as $item2) {
        if ($item2['relid'] === $item1['id']) {
            $match = $item2;
            break;
        }
    }
    $result[] = $match !== null ? $item1 + $match : $item1;
}

// Обработка запроса
if (isset($_GET['id']) && $_GET['id'] !== '') {
    $user = getUserFromPreloadedData($result, $_GET['id']);
    
    if ($user) {
        echo json_encode($user, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    } else {
        http_response_code(404);
        echo json_encode([
            'error' => 'User not found',
            'status' => 404,
            'requested_id' => $_GET['id']
        ], JSON_UNESCAPED_UNICODE);
    }
} else {
    // Если ID не указан - возвращаем всех пользователей
    echo json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
}
?>

Эта реализация следует REST-подходу и аналогична работе JSONPlaceholder, который вы упоминали в предыдущем вопросе.

Ключевые особенности:
Не ходит в БД - работает только с уже загруженными данными
Гибкое сравнение ID - приводит ID к строке для надежного сравнения
Сохранение исходного формата - возвращает данные в том же формате, что и оригинальный массив $result
Полная совместимость с вашим существующим кодом формирования $result

#Примеры запросов:

# Получить всех пользователей
curl -s "http://api.sytes.ru:3605/api5.php" | jq

# Получить конкретного пользователя (существующий)
curl -s "http://api.sytes.ru:3605/api5.php?id=122" | jq

# Получить несуществующего пользователя
curl -s "http://api.sytes.ru:3605/api5.php?id=999" | jq

#Оптимизация производительности:
Для очень больших массивов можно добавить предварительное индексирование:

// В api_functions.php
function createUsersIndex($allUsersData) {
    $index = [];
    foreach ($allUsersData as $user) {
        $index[(string)$user['id']] = $user;
    }
    return $index;
}

function getUserFromIndex($index, $userId) {
    $userId = (string)$userId;
    return $index[$userId] ?? null;
}

И использовать в api5.php:

$usersIndex = createUsersIndex($result);
// ...
$user = getUserFromIndex($usersIndex, $_GET['id']);
