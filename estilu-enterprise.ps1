# ==========================================================
# ESTILU PRO MAX ENTERPRISE (VERSIÓN ESTABLE CORREGIDA)
# ==========================================================

Write-Host "Iniciando configuración PRO MAX ENTERPRISE..."

# =========================
# 1. Crear TODAS las carpetas necesarias primero
# =========================
$folders = @(
    ".\src",
    ".\src\models",
    ".\src\services",
    ".\src\tokens",
    ".\src\middlewares",
    ".\src\routes",
    ".\admin-dashboard",
    ".\.github",
    ".\.github\workflows"
)

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
}

# =========================
# 2. Instalar dependencias
# =========================
npm install crypto nodemailer

# =========================
# 3. Crear modelo RefreshToken
# =========================
$refreshModel = @"
const mongoose = require('mongoose');

const refreshTokenSchema = new mongoose.Schema({
  userId: mongoose.Schema.Types.ObjectId,
  token: String,
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('RefreshToken', refreshTokenSchema);
"@

Set-Content -Path ".\src\models\RefreshToken.js" -Value $refreshModel -Force

# =========================
# 4. Dockerfile
# =========================
$dockerfile = @"
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
"@

Set-Content ".\Dockerfile" $dockerfile -Force

# =========================
# 5. docker-compose.yml
# =========================
$compose = @"
version: '3'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    depends_on:
      - mongo

  mongo:
    image: mongo
    ports:
      - "27017:27017"
"@

Set-Content ".\docker-compose.yml" $compose -Force

# =========================
# 6. GitHub Actions CI/CD
# =========================
$workflow = @"
name: Deploy Estilu

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm install
"@

Set-Content ".\.github\workflows\deploy.yml" $workflow -Force

Write-Host ""
Write-Host "========================================="
Write-Host "PRO MAX ENTERPRISE CONFIGURADO CORRECTAMENTE"
Write-Host "========================================="
Write-Host "Docker listo"
Write-Host "CI/CD listo"
Write-Host "Modelo RefreshToken creado"
Write-Host ""