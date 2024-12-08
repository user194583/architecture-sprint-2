# pymongo-api

## Как запустить

Переходим в директорию для выполнения запуска

```
cd sharding-repl-cache
```

Запускаем шардирование,репликацию с кэшированием mongodb и приложение

```shell
docker compose up -d
```

Делаем скрипты выполняемыми

```shell
chmod +x *.sh
```

Настраиваем и заполняем данными

```shell
./init-repl-cache.sh
```

Проверяем количество документов

```shell
./check-repl-cache.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8081

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8081

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8081/docs

## Для остановки и удаления контейнеров, данных

```shell
docker compose down -v
```
