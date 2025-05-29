################ FORK MAIN - GITGUB ACTIONS2 #################

Ниже представлены инструкции по настройке подключения к GitHub используя SSH.
```
###################################################################### CUSTOM ACTIONS ########################################################################
#Кастомный action
В GitHub Marketplace есть отдельный раздел, посвященный Actions. Некоторые из них созданы известными компаниями, но бóльшая часть публикуется разработчиками. Но допустим, не удалось найти готовое решение для решения задачи.
В таком случае можно воспользоваться инструкцией и содать кастомный action. Код action может написан на языке JavaScript или быть собран в виде Docker-образа.

Общий принцип создания action — нужен отдельный репозиторий, который будет содержать файл action.yml и все прочие файлы, необходимые для работы action.

name: Название action
author: Автор action
description: Описание action

inputs:
  # входные данные
outputs:
  # выходные данные

runs:
  # директивы запуска
Кроме того, action можно создать в отдельной директории внутри .github/actions. Эта директория должна содержать файл action.yml и все прочие файлы, необходимые для работы action. 
В этом случае обращение к этому action из workflow-файла будет иметь вид ./path/to/dir. Также необходимо скопировать файлы репозитрия внутрь временного сервера, где будет работать workflow.

|-- hello-world (repository)
|   |__ .github
|       └── workflows
|           └── my-first-workflow.yml
|       └── actions
|           |__ hello-world-action
|               └── action.yml 
jobs:
  example:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: ./.github/actions/hello-world-action


1. Action как Docker-образ
Наш кастомный action будет выполнять простой bash-скрипт. Этот скрипт будет обращаться к API сервиса JSON Placeholder и получать имя пользователя по идентификатору. Пользователей всего 10, идентификаторы — числа от 1 до 10.

API для примера используется вот это: https://jsonplaceholder.typicode.com/users  (Для прода буду использовать https://up.sytes.ru/users) 
[
  {
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": {
      "street": "Kulas Light",
      "suite": "Apt. 556",
      "city": "Gwenborough",
      "zipcode": "92998-3874",
      "geo": {
        "lat": "-37.3159",
        "lng": "81.1496"
      }
    },
    "phone": "1-770-736-8031 x56442",
    "website": "hildegard.org",
    "company": {
      "name": "Romaguera-Crona",
      "catchPhrase": "Multi-layered client-server neural-net",
      "bs": "harness real-time e-markets"
    }
  },
  {
    "id": 2,
    "name": "Ervin Howell",
    "username": "Antonette",
    "email": "Shanna@melissa.tv",
    "address": {
      "street": "Victor Plains",
      "suite": "Suite 879",
      "city": "Wisokyburgh",
      "zipcode": "90566-7771",
      "geo": {
        "lat": "-43.9509",
        "lng": "-34.4618"
      }
    },
    "phone": "010-692-6593 x09125",
    "website": "anastasia.net",
    "company": {
      "name": "Deckow-Crist",
      "catchPhrase": "Proactive didactic contingency",
      "bs": "synergize scalable supply-chains"
    }
  },
  {
    "id": 3,
    "name": "Clementine Bauch",
    "username": "Samantha",
    "email": "Nathan@yesenia.net",
    "address": {
      "street": "Douglas Extension",
      "suite": "Suite 847",
      "city": "McKenziehaven",
      "zipcode": "59590-4157",
      "geo": {
        "lat": "-68.6102",
        "lng": "-47.0653"
      }
    },
    "phone": "1-463-123-4447",
    "website": "ramiro.info",
    "company": {
      "name": "Romaguera-Jacobson",
      "catchPhrase": "Face to face bifurcated interface",
      "bs": "e-enable strategic applications"
    }
  },
  {
    "id": 4,
    "name": "Patricia Lebsack",
    "username": "Karianne",
    "email": "Julianne.OConner@kory.org",
    "address": {
      "street": "Hoeger Mall",
      "suite": "Apt. 692",
      "city": "South Elvis",
      "zipcode": "53919-4257",
      "geo": {
        "lat": "29.4572",
        "lng": "-164.2990"
      }
    },
    "phone": "493-170-9623 x156",
    "website": "kale.biz",
    "company": {
      "name": "Robel-Corkery",
      "catchPhrase": "Multi-tiered zero tolerance productivity",
      "bs": "transition cutting-edge web services"
    }
  },
  {
    "id": 5,
    "name": "Chelsey Dietrich",
    "username": "Kamren",
    "email": "Lucio_Hettinger@annie.ca",
    "address": {
      "street": "Skiles Walks",
      "suite": "Suite 351",
      "city": "Roscoeview",
      "zipcode": "33263",
      "geo": {
        "lat": "-31.8129",
        "lng": "62.5342"
      }
    },
    "phone": "(254)954-1289",
    "website": "demarco.info",
    "company": {
      "name": "Keebler LLC",
      "catchPhrase": "User-centric fault-tolerant solution",
      "bs": "revolutionize end-to-end systems"
    }
  },
  {
    "id": 6,
    "name": "Mrs. Dennis Schulist",
    "username": "Leopoldo_Corkery",
    "email": "Karley_Dach@jasper.info",
    "address": {
      "street": "Norberto Crossing",
      "suite": "Apt. 950",
      "city": "South Christy",
      "zipcode": "23505-1337",
      "geo": {
        "lat": "-71.4197",
        "lng": "71.7478"
      }
    },
    "phone": "1-477-935-8478 x6430",
    "website": "ola.org",
    "company": {
      "name": "Considine-Lockman",
      "catchPhrase": "Synchronised bottom-line interface",
      "bs": "e-enable innovative applications"
    }
  },
  {
    "id": 7,
    "name": "Kurtis Weissnat",
    "username": "Elwyn.Skiles",
    "email": "Telly.Hoeger@billy.biz",
    "address": {
      "street": "Rex Trail",
      "suite": "Suite 280",
      "city": "Howemouth",
      "zipcode": "58804-1099",
      "geo": {
        "lat": "24.8918",
        "lng": "21.8984"
      }
    },
    "phone": "210.067.6132",
    "website": "elvis.io",
    "company": {
      "name": "Johns Group",
      "catchPhrase": "Configurable multimedia task-force",
      "bs": "generate enterprise e-tailers"
    }
  },
  {
    "id": 8,
    "name": "Nicholas Runolfsdottir V",
    "username": "Maxime_Nienow",
    "email": "Sherwood@rosamond.me",
    "address": {
      "street": "Ellsworth Summit",
      "suite": "Suite 729",
      "city": "Aliyaview",
      "zipcode": "45169",
      "geo": {
        "lat": "-14.3990",
        "lng": "-120.7677"
      }
    },
    "phone": "586.493.6943 x140",
    "website": "jacynthe.com",
    "company": {
      "name": "Abernathy Group",
      "catchPhrase": "Implemented secondary concept",
      "bs": "e-enable extensible e-tailers"
    }
  },
  {
    "id": 9,
    "name": "Glenna Reichert",
    "username": "Delphine",
    "email": "Chaim_McDermott@dana.io",
    "address": {
      "street": "Dayna Park",
      "suite": "Suite 449",
      "city": "Bartholomebury",
      "zipcode": "76495-3109",
      "geo": {
        "lat": "24.6463",
        "lng": "-168.8889"
      }
    },
    "phone": "(775)976-6794 x41206",
    "website": "conrad.com",
    "company": {
      "name": "Yost and Sons",
      "catchPhrase": "Switchable contextually-based project",
      "bs": "aggregate real-time technologies"
    }
  },
  {
    "id": 10,
    "name": "Clementina DuBuque",
    "username": "Moriah.Stanton",
    "email": "Rey.Padberg@karina.biz",
    "address": {
      "street": "Kattie Turnpike",
      "suite": "Suite 198",
      "city": "Lebsackbury",
      "zipcode": "31428-2261",
      "geo": {
        "lat": "-38.2386",
        "lng": "57.2232"
      }
    },
    "phone": "024-648-3804",
    "website": "ambrose.net",
    "company": {
      "name": "Hoeger LLC",
      "catchPhrase": "Centralized empowering task-force",
      "bs": "target end-to-end models"
    }
  }
]

Указанное апи при указании id пользователя возвращает его описание 
curl https://jsonplaceholder.typicode.com/users/5
{
  "id": 5,
  "name": "Chelsey Dietrich",
  "username": "Kamren",
  "email": "Lucio_Hettinger@annie.ca",
  "address": {
    "street": "Skiles Walks",
    "suite": "Suite 351",
    "city": "Roscoeview",
    "zipcode": "33263",
    "geo": {
      "lat": "-31.8129",
      "lng": "62.5342"
    }
  },
  "phone": "(254)954-1289",
  "website": "demarco.info",
  "company": {
    "name": "Keebler LLC",
    "catchPhrase": "User-centric fault-tolerant solution",
    "bs": "revolutionize end-to-end systems"
  }
}

Как всегда, создаем директорию проекта, размещаем в ней файлы Dockerfile, entrypoint.sh и action.yml:

# Base Docker image 
FROM alpine:latest

# installes required packages for our script
RUN apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  jq

# copy bash script to filesystem alpine OS
COPY entrypoint.sh /entrypoint.sh

# change permission to execute our script
RUN chmod +x /entrypoint.sh

# execute bash script when container start
ENTRYPOINT ["/entrypoint.sh"]
#!/bin/bash
set -e

api_url="https://jsonplaceholder.typicode.com/users/${INPUT_USER_ID}"
echo $api_url

user_name=$(curl "${api_url}" | jq ".name")
echo $user_name

echo "::set-output name=user_name::$user_name"
name: Custom Github Docker Action
description: Call API and get user name

inputs:
  user_id:
    description: User ID, from 1 to 10
    required: true
    default: 1
outputs:
  user_name:
    description: Getted user name

runs:
  using: docker
  image: Dockerfile
  args:
    - ${{ inputs.user_id }}

Чтобы проверить наш новый action — создаем workflow-файл, который использует этот action в работе:

name: Test custom docker action

on: [push]

jobs:
  get_user_name_job:
    runs-on: ubuntu-latest
    # задаем значение output для этого задания
    outputs:
      user_name: ${{ steps.get_user_name_step.outputs.user_name }}
    steps:
      - name: Get user name
        id: get_user_name_step
        uses: tokmakov/custom-docker-action@master
        with:
          user_id: 5
      - name: Echo user name
        # получаем доступ к output предыдущего шага
        run: echo ${{ steps.get_user_name_step.outputs.user_name }}

  use_user_name_job:
    runs-on: ubuntu-latest
    needs: get_user_name_job
    steps:
      - name: Echo user name
        # получаем доступ к output предыдущего задания
        run: echo ${{needs.get_user_name_job.outputs.user_name}}

Создаем репозиторий на GitHub, выкладываем файлы проекта и смотрим результат работы нового action:


get_user_name_job
succeeded last week in 11s

