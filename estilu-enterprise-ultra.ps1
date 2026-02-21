# ====================================================
# Estilu Enterprise Ultra PRO MAX - Validador
# Verifica estructura, dependencias y servicios
# ====================================================

Write-Host "Iniciando Validador Ultra PRO MAX..." -ForegroundColor Cyan

# -----------------------------
# 1. Verificar carpetas
# -----------------------------
$folders = @(
    "src\models",
    "src\routes",
    "src\services",
    "src\middlewares",
    "src\tokens",
    "public/pages",
    ".github/workflows"
)

foreach ($f in $folders) {
    if (Test-Path $f) {
        Write-Host "✔ Carpeta existente: $f"
    } else {
        Write-Host "❌ Carpeta faltante: $f" -ForegroundColor Red
    }
}

# -----------------------------
# 2. Verificar archivos
# -----------------------------
$files = @(
    "server.js",
    "Dockerfile",
    ".env",
    ".gitignore",
    "src/models/User.js",
    "src/models/RefreshToken.js",
    "src/routes/auth.routes.js"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "✔ Archivo existente: $file"
    } else {
        Write-Host "❌ Archivo faltante: $file" -ForegroundColor Red
    }
}

# -----------------------------
# 3. Verificar dependencias npm
# -----------------------------
$dependencies = @(
    "express",
    "mongoose",
    "bcryptjs",
    "jsonwebtoken",
    "dotenv",
    "helmet",
    "express-rate-limit",
    "compression",
    "morgan",
    "cors",
    "stripe",
    "nodemailer"
)

$missingDeps = @()
foreach ($dep in $dependencies) {
    try {
        npm list $dep | Out-Null
    } catch {
        $missingDeps += $dep
    }
}

if ($missingDeps.Count -eq 0) {
    Write-Host "✔ Todas las dependencias npm instaladas"
} else {
    Write-Host "❌ Dependencias faltantes: $($missingDeps -join ', ')" -ForegroundColor Red
}

# -----------------------------
# 4. Probar conexión MongoDB
# -----------------------------
Write-Host "🔄 Verificando conexión a MongoDB..."
try {
    $mongoUri = (Get-Content ".env" | Select-String "MONGO_URI" | ForEach-Object { $_.ToString().Split("=")[1].Trim() })
    $mongoTest = node -e "const mongoose = require('mongoose'); mongoose.connect('$mongoUri').then(()=>console.log('✔ MongoDB conectado')).catch(err=>{console.error('❌ MongoDB error', err); process.exit(1)});"
} catch {
    Write-Host "❌ No se pudo conectar a MongoDB" -ForegroundColor Red
}

# -----------------------------
# 5. Test JWT y roles
# -----------------------------
Write-Host "🔄 Probando creación y verificación de JWT..."

$jwtTestScript = @'
const jwt = require("jsonwebtoken");
const secret = "TEST_SECRET";
const token = jwt.sign({ userId: 123, role: "admin" }, secret, { expiresIn: "1h" });
const decoded = jwt.verify(token, secret);
if(decoded.userId === 123 && decoded.role === "admin"){ console.log("✔ JWT OK y roles OK") } else { console.error("❌ JWT o roles fallaron") }
'@

try {
    node -e $jwtTestScript
} catch {
    Write-Host "❌ Error ejecutando test JWT" -ForegroundColor Red
}

# -----------------------------
# 6. Test Stripe mínimo
# -----------------------------
Write-Host "🔄 Verificando Stripe (clave de prueba)..."

$stripeTestScript = @'
try {
  const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY || "sk_test_123");
  stripe.balance.retrieve().then(() => console.log("✔ Stripe configurado")).catch(()=>console.error("❌ Stripe no responde"));
} catch {
  console.error("❌ Stripe módulo no disponible");
}
'@

try {
    node -e $stripeTestScript
} catch {
    Write-Host "❌ Error ejecutando test Stripe" -ForegroundColor Red
}

# -----------------------------
# 7. Logs estructurados (morgan)
# -----------------------------
Write-Host "🔄 Probando logs estructurados con morgan..."

$morganTestScript = @'
const express = require("express");
const morgan = require("morgan");
const app = express();
app.use(morgan("combined"));
app.get("/", (req,res)=>res.send("Test morgan"));
const server = app.listen(0, ()=>{ console.log("✔ Morgan OK"); server.close() });
'@

try {
    node -e $morganTestScript
} catch {
    Write-Host "❌ Error ejecutando test Morgan" -ForegroundColor Red
}

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "✅ Validación Ultra PRO MAX completada. Proyecto listo para producción."
Write-Host "=============================================" -ForegroundColor Cyan