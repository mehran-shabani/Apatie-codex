# راه‌اندازی زیرساخت توسعه

این پوشه فایل‌های موردنیاز برای بالا آوردن سرویس‌های پروژه در محیط داکر و همچنین دستورالعمل‌های مربوط به اجرای آن در GitHub Codespaces را در خود دارد.

## محتوای پوشه
- `Dockerfile`: تصویر پایه‌ی سرویس‌های پایتونی پروژه که وابستگی‌ها را نصب می‌کند.
- `docker-compose.yml`: تعریف سرویس‌های Postgres، Redis و کانتینرهای پروژه (وب، سلری و …).

## پیش‌نیازها
1. نصب Docker و Docker Compose (نسخه‌ی 2.20 به بالا پیشنهاد می‌شود).
2. ایجاد فایل‌های پیکربندی محیط:
   ```bash
   cp .env.example .env
   cp backend/.env.example backend/.env
   ```
   مقادیر پیش‌فرض برای شروع توسعه کافی هستند، اما می‌توانید در صورت نیاز آن‌ها را تغییر دهید.

## اجرای محلی با Docker Compose
1. ساخت ایمیج‌ها:
   ```bash
   docker compose -f infra/docker-compose.yml build backend
   ```
2. بالا آوردن سرویس‌ها (در پس‌زمینه):
   ```bash
   docker compose -f infra/docker-compose.yml up -d
   ```
3. اعمال مایگریشن‌ها:
   ```bash
   docker compose -f infra/docker-compose.yml run --rm backend python manage.py migrate
   ```
4. (اختیاری) ایجاد کاربر ادمین:
   ```bash
   docker compose -f infra/docker-compose.yml run --rm backend python manage.py createsuperuser
   ```
5. سرویس جنگو روی آدرس <http://localhost:8000> در دسترس است. پایگاه‌داده روی پورت 5432 و ردیس روی پورت 6379 منتشر می‌شوند.
6. برای خاموش کردن سرویس‌ها:
   ```bash
   docker compose -f infra/docker-compose.yml down
   ```

## نکات تکمیلی
- لاگ‌های هر سرویس را با دستور زیر مشاهده کنید:
  ```bash
  docker compose -f infra/docker-compose.yml logs -f backend
  ```
- در صورت تغییر وابستگی‌ها یا فایل `requirements.txt`، دستور build را دوباره اجرا کنید.
- برای اجرای تست‌ها داخل کانتینر:
  ```bash
  docker compose -f infra/docker-compose.yml run --rm backend pytest
  ```

## استفاده از GitHub Codespaces / Dev Containers
اگر از GitHub Codespaces یا VS Code Dev Containers استفاده می‌کنید، می‌توانید کانفیگ زیر را به عنوان فایل `.devcontainer/devcontainer.json` اضافه کنید تا همان سرویس‌های تعریف‌شده در این پوشه به صورت خودکار اجرا شوند:

```json
{
  "name": "Apatie Backend",
  "dockerComposeFile": "infra/docker-compose.yml",
  "service": "backend",
  "workspaceFolder": "/app",
  "postCreateCommand": "pip install --upgrade pip",
  "customizations": {
    "vscode": {
      "settings": {
        "python.defaultInterpreterPath": "/usr/local/bin/python"
      },
      "extensions": [
        "ms-python.python",
        "ms-python.vscode-pylance"
      ]
    }
  }
}
```

پس از افزودن فایل فوق و باز کردن پروژه در Codespaces، دستور `docker compose` درون محیط Codespace اجرا شده و تمام سرویس‌ها بالا می‌آیند. اگر نمی‌خواهید فایل پیکربندی اضافه کنید، می‌توانید داخل Codespace نیز همان دستورهای بخش «اجرای محلی» را اجرا کنید.
