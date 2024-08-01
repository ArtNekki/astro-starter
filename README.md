# Astro Starter

[Русский](README.md) | [English](README.en.md)

## Описание

Проект использует **Tailwind CSS** для работы со стилями, **React JS** для ui и **Doppler** для управления переменными окружения.
Проект может запускаться как локально, так и через Docker. Реализован деплой как на продакшн сервер, так и на тестовый сервер.

## Навигация

1. [Подготовка проекта к запуску](#подготовка-проекта-к-запуску)

- [Локально](#1-локально)
- [GitHub настройки](#2-github-настройки)
- [Doppler настройки](#3-doppler-настройки)

2. [Запуск проекта](#запуск-проекта)

- [Локально](#локально-1)
- [В Docker](#в-docker)

3. [Управление переменными окружения через Doppler](#управление-переменными-окружения-через-doppler)

- [Установка](#установка)
- [Подключение к проекту](#подключение-к-проекту)
- [Получение секрета](#получение-секрета)

4. [Процесс работы с ветками в Git](#процесс-работы-с-ветками-в-git)
5. [Работа с тегами](#работа-с-тегами)
6. [Дополнительные команды для работы с Git](#дополнительные-команды-для-работы-с-git)

- [Удаление веток](#удаление-веток)
- [Обновление информации о ветках](#обновление-информации-о-ветках)

7. [Добавление домена](#добавление-домена)

## Подготовка проекта к запуску

### 1. Локально

- Склонировать проект на свой компьютер:
  - `https://github.com/ArtNekki/astro-starter.git`
- Перейти в проект и установить зависимости:
  - `npm ci`
- В проекте активировать ветку `develop`:
  - `git checkout develop`

### 2. GitHub настройки

- Перейти в проект на `github.com`
- Перейти в `Settings` -> `Branches` и создать для веток `main` и `develop` protection rules:

  - `Require a pull request before merging` (вложенные настройки не нужны)
  - `Require status checks to pass before merging`:
    - `Require branches to be up to date before merging`:
      - `build-and-test` (до первого pull request может не быть)
      - `security-scan` (до первого pull request может не быть)
      - `docker-build` (до первого pull request может не быть)

- Перейти в `Settings` -> `Secrets and Variables` -> `Actions`:

  - В `Repository secrets` указать секреты:
    - `DOCKER_USERNAME`
    - `DOCKER_PASSWORD`
  - В `Repository variables` указать переменные:
    - `PROJECT_NAME`

- Перейти в `Settings` -> `Environments`:
  - Создать два окружения `production` и `staging`
  - Для каждого из этих окружений создать variable `SSH_PORT`
- Перейти в `Settings` -> `Actions` -> `Workflow permissions`:
  - Установить `Read and write permissions`
  - Установить `Allow GitHub Actions to create and approve pull requests`

### 3. Doppler настройки

- Зарегистрироваться на [doppler.com](https://www.doppler.com/)
- Создать workspace
- Создать проект
- В проекте добавить переменные окружения для необходимых environments:

  - `SSH_HOST`
  - `SSH_KEY`
  - `SSH_PASSPHRASE`
  - `SSH_USER`
  - `STRAPI_URL` (название может изменяться в зависимости от бэкенда)

- Перейти в `Integrations` и синхронизировать environments с проектом на GitHub и соответствующими environments в нем

### 4. Подготовка завершена!

## Запуск проекта

### Локально

- `make run`

### В Docker

- `./docker.sh dev|stage|prod` (по умолчанию `dev`, можно не указывать)

## Управление переменными окружения через Doppler

### Установка

1. **Установка gnupg для проверки подписи бинарных файлов:**

- `brew install gnupg`

2. **Установка Doppler CLI:**

- `brew install dopplerhq/cli/doppler`

### Подключение к проекту

1. **Авторизация в Doppler:**

- `doppler login`

2. **Выбор конфига:**

- `doppler setup`

3. **Запуск команды, например, `npm run dev`:**

- `doppler run --config dev|stage|prod npm run dev`

### Получение секрета

- `doppler secrets get 'SOME_SECRET' --plain`

## Процесс работы с ветками в Git

1. **Создание feature-ветки от ветки `develop`**

- Например, `git checkout -b feature/new-feature`
- В этой ветке реализуется необходимый функционал

2. **Отправка данных в GitHub после завершения работы**

- `git commit -m "feat(new-feature): Create new feature"`
- `git push origin -u feature/new-feature`

3. **Создание pull-request в ветку `develop`**

- После подтверждения pull-request происходит деплой на ТЕСТОВЫЙ сервер

4. **Переход в локальную ветку `develop` для дальнейшей разработки**

- `git checkout develop`
- Получение данных из удаленной ветки `develop`: `git pull`

5. **Создание новой feature-ветки для реализации новой задачи**

6. **Создание pull-request из ветки `develop` в ветку `main` для релиза**

7. **Переход в локальную ветку `main` и получение данных**

- `git pull`

8. **Создание тега для релиза**

- Например, `git tag -a v1.0.0 -m "Release version 1.0.0"`

9. **Пуш тега и деплой на PRODUCTION сервер**

- `git push origin v1.0.0`

10. **Обновление ветки `develop` после создания релиза**

- Переход в ветку `develop`: `git checkout develop`
- Проверка неполученных данных: `git pull`
- Объединение с веткой `main`: `git merge origin/main`

11. **Продолжение разработки**

## Работа с тегами

1. **Создание легковесного тега:**

- `git tag v1.0.0`

2. **Создание аннотированного тега (рекомендуется для релизов):**

- `git tag -a v1.0.0 -m "Release version 1.0.0"`
  - Флаг `-a` создает аннотированный тег, а `-m` позволяет добавить сообщение.

3. **Создание тега для определенного коммита:**

- `git tag -a v1.0.0 9fceb02 -m "Release version 1.0.0"`

4. **Отправка тега в удаленный репозиторий:**

- `git push origin v1.0.0`

5. **Просмотр существующих тегов:**

- `git tag`

6. **Просмотр информации о конкретном теге:**

- `git show v1.0.0`

7. **Удаление локального тега:**

- `git tag -d v1.0.0`

8. **Удаление удаленного тега:**

- `git push origin :refs/tags/v1.0.0`

9. **Удаление локального и удаленного тега:**

- `git push origin --delete v1.0.0`

## Дополнительные команды для работы с Git

### Удаление веток

- **Удалить удаленную ветку с именем "feature-branch":**

  - `git push origin --delete feature-branch`

- **Удалить соответствующую локальную ветку:**
  - `git branch -d <имя_ветки>`

### Обновление информации о ветках

- **Обновить информацию о удаленных ветках и удалить ссылки на несуществующие ветки:**
  - `git fetch --all --prune`

### Тестирование проекта

- Запуск тестов `npm run test`
- Запуск lint `npm run lint`

### Добавление домена

- Перейти в корень проекта удаленного сервера
- Создать директорию `nginx`
- Настроить Nginx Proxy Manager, следуя инструкциям на сайте:
  - [Nginx Proxy Manager Guide](https://nginxproxymanager.com/guide/)
