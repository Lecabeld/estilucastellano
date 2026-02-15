# ==============================
# SCRIPT ULTRA PRO: Ventana Git Profesional VS Code
# ==============================

# Ruta de tu proyecto
\D:\uebs\estilucastellano = "D:\uebs\estilucastellano"
Write-Host "🟢 Navegando a tu proyecto..." -ForegroundColor Green
Set-Location \D:\uebs\estilucastellano

# Configuración global Git
Write-Host "🛠 Configurando Git global..." -ForegroundColor Cyan
if (-not (git config --global user.name)) {
    git config --global user.name "TuNombre"
    git config --global user.email "tuemail@example.com"
    Write-Host "✅ Usuario Git configurado"
} else {
    Write-Host "⚡ Usuario Git ya configurado"
}

# Colores y visibilidad
git config --global color.ui auto
Write-Host "🎨 Colores Git activados"

# Alias profesionales
Write-Host "🧩 Creando alias Git ultra PRO..."
git config --global alias.s "status"
git config --global alias.c "commit -m"
git config --global alias.p "push"
git config --global alias.pl "pull"
git config --global alias.l "log --oneline --graph --all --decorate"
git config --global alias.a "add ."
Write-Host "✅ Alias listos: s, c, p, pl, l, a"

# Flujo diario rápido
function git-flow {
    param([string]\ = "Actualización rápida")
    Write-Host "
🔹 Ejecutando flujo Git profesional..." -ForegroundColor Yellow
    git fetch origin
    git pull origin main
    git status
    git add .
    git commit -m \
    git push origin main
    Write-Host "✅ Flujo completado!" -ForegroundColor Green
}
Set-Alias gf git-flow
Write-Host "💡 Alias de flujo diario creado: gf 'Mensaje commit'"

# Historial y limpieza
Write-Host "📜 Mostrando últimas 5 confirmaciones..."
git log -5 --oneline --graph --decorate

# Banner inicial
Write-Host "
=========================================" -ForegroundColor Magenta
Write-Host "🚀 Ventana Git Profesional lista para \D:\uebs\estilucastellano" -ForegroundColor Magenta
Write-Host "📝 Alias útiles: s, c, p, pl, l, a, gf" -ForegroundColor Magenta
Write-Host "=========================================
" -ForegroundColor Magenta

# Mensaje de uso
Write-Host "🔹 Para usar el flujo diario: gf 'Mensaje de commit'" -ForegroundColor Cyan
Write-Host "🔹 Comandos rápidos: git s | git c 'mensaje' | git p | git pl | git l | git a" -ForegroundColor Cyan
