# Delivez — Customer App

The Delivez customer app: order food, groceries, medicines and local-shop items, book lab tests, track orders, pay online (Razorpay), rate orders and get help. React + Vite + Tailwind, 8 languages.
It talks to the API in [delivez-partners-backend](https://github.com/delivezindia/delivez-partners-backend).

| Part | Path |
|---|---|
| Customer app | `apps/local-web` — http://localhost:5175 locally, built to `apps/local-web/dist` |
| Translations (8 languages) | `packages/i18n` |
| Design tokens | `packages/ui/src/tokens.css` |
| Server scripts | `deploy/customer` |

## Server setup (once)
Needs **Node.js 20+**, **pnpm 9** (`npm i -g pnpm@9`), **git** and **nginx**.
```bash
cd /var/www && git clone https://github.com/delivezindia/delivez-customer-app.git && cd delivez-customer-app
cp .env.example .env                       # set VITE_API_URL (+ VITE_GOOGLE_MAPS_API_KEY)
chmod +x deploy/customer/update.sh deploy/customer/hooks/*
git config core.hooksPath deploy/customer/hooks   # every future git pull rebuilds automatically
./deploy/customer/update.sh                       # first build
```
Then nginx: copy `deploy/customer/nginx.conf` to `/etc/nginx/sites-available/`, set the domain and path, enable it, reload nginx, and add HTTPS with `sudo certbot --nginx -d local.delivez.com`.

On the backend, `CORS_ORIGINS` must include this app's address. Online payment needs the Razorpay keys in the backend's `.env`.

## Updating
```bash
cd /var/www/delivez-customer-app && git pull
```
The hook installs and rebuilds; nginx serves the new version right away. (After editing `.env`, run `./deploy/customer/update.sh` once.)

## Local development
1. Node 20+, pnpm 9, and the backend running on http://localhost:4000.
2. `cp .env.example .env` and set `VITE_API_URL=` (empty) · `pnpm install` · `pnpm dev` → http://localhost:5175
3. Sign in with any phone number; locally the login code is shown on screen.
