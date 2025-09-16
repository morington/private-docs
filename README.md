# Введение

Готовый шаблон репозитория для создания **приватной документации на VPS** без боли и лишней настройки.

Можете ознакомиться с примером документации MkDocs на теме `material`
https://morington.github.io/private-docs/

Каталог тем: https://github.com/mkdocs/catalog

---

## Что внутри

- Автодеплой на VPS через GitHub Actions (SSH + Docker)
- MkDocs + Material — современная и удобная документация
- Защита Basic Auth через Nginx
- Поддержка Markdown-расширений, подсветки кода, Mermaid и MathJax
- Светлая/тёмная темы и кнопка копирования кода

---

# 🚀 Быстрый старт

## Для начала

Форкните или скачайте архив для вашей будущей документации. Этот репозиторий просто шаблон.

Создайте свой репозиторий, клонируйте на локальную машину и пройдите следующие шаги.

## 1. Подготовка сервера (VPS)

Установить Docker и Docker Compose:  
https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

Создать пользователя для деплоя:

```bash
sudo adduser --disabled-password --gecos "" deploy
sudo usermod -aG docker deploy
echo "deploy ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/deploy
```

Перейти под пользователя deploy и сгенерировать SSH-ключ прямо на сервере:

```bash
sudo -iu deploy
ssh-keygen -t ed25519 -C "deploy@docs"
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

Скопировать содержимое `~/.ssh/id_ed25519` (приватный ключ) и добавить в GitHub →
Settings → Secrets → Actions как `SSH_PRIVATE_KEY`.

---

## 2. Настройка репозитория

Склонировать или форкнуть этот репозиторий.  
Документация должна лежать в папке `docs/`.

Добавить секреты в GitHub → Settings → Secrets → Actions:

| Name              | Value              |
|-------------------|--------------------|
| `DEPLOY_HOST`     | IP сервера         |
| `DEPLOY_USER`     | deploy             |
| `SSH_PRIVATE_KEY` | содержимое `~/.ssh/id_ed25519` |
| `SITE_URL`        | VPS_IP            |

---

## 3. Деплой

Добавить необходимую документацию, прописать в `mkdocs.yml` содержание страницы в блоке `nav`.

В `mkdocs.yml` в самом начале файла можете сменить `site_name: My Docs` на необходимое.

Далее необходимо файл `workflow.yml` для CI/DI переместить в `.github/workflows/workflow.yml`, чтобы Github Action понимал что ему необходимо делать.

После запушить в ветку `main`, CI/DI настроен на деплой после пуша в `main`:

```bash
git add .
git commit -m "docs: init"
git push origin main
```

GitHub Actions автоматически соберёт и задеплоит сайт на ваш VPS.