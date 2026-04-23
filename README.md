# Daily Activity Log for Dokku

A stateful Node.js application to log and view daily activities with Markdown support, persistent in PostgreSQL.

## Architecture
- **Runtime:** Node.js v22 (LTS)
- **Database:** PostgreSQL (managed by `dokku-postgres`)
- **Persistence:** Decoupled via `DATABASE_URL` environment variable.
- **Exposure:** Cloudflare Tunnel -> Dokku (Port 8082) -> Container (Port 5000).
- **Public Domain:** https://web3.luizcarloskazuyukifukaya.org

## Local Development
1. Install dependencies:
   ```bash
   npm install
   ```
2. Set up a local PostgreSQL instance and provide the connection string in a `.env` file:
   ```env
   DATABASE_URL=postgres://user:password@localhost:5432/dbname
   ```
3. Run the app:
   ```bash
   npm start
   ```

## Deployment to Dokku
1. Make the deployment script executable:
   ```bash
   chmod +x deploy-to-dokku.sh
   ```
2. Run the script:
   ```bash
   ./deploy-to-dokku.sh
   ```

## Health Checks
The app provides a health check endpoint at `/health`. Dokku uses this to verify the deployment.
