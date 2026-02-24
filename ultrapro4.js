const fs = require('fs')
const path = require('path')
const glob = require('glob')
const crypto = require('crypto')

const root = process.cwd()
const ASSETS_DIR = path.join(root, 'assets')
const args = process.argv.slice(2)

if (!fs.existsSync(ASSETS_DIR)) {
  console.log('❌ No existe carpeta /assets')
  process.exit(1)
}

// ---------------------------
// SMART FILE LOADER
// ---------------------------
function getFiles(pattern) {
  return glob
    .sync(pattern, {
      cwd: ASSETS_DIR,
      absolute: true,
      ignore: ['**/node_modules/**'],
    })
    .filter((file) => fs.statSync(file).isFile())
}

// ---------------------------
// 📊 SIZE ENGINE
// ---------------------------
function getFolderSizes() {
  const files = getFiles('**/*.*')
  let folders = {}

  files.forEach((file) => {
    const relative = path.relative(ASSETS_DIR, file)
    const folder = relative.split(path.sep)[0] || 'root'
    const size = fs.statSync(file).size

    if (!folders[folder]) folders[folder] = 0
    folders[folder] += size
  })

  let formatted = {}
  for (let key in folders) {
    formatted[key] = {
      bytes: folders[key],
      kb: (folders[key] / 1024).toFixed(2),
      mb: (folders[key] / (1024 * 1024)).toFixed(2),
    }
  }

  return formatted
}

// ---------------------------
// 🔐 IMAGE HASH ENGINE
// ---------------------------
function getImageHashes() {
  const images = getFiles('**/*.{jpg,jpeg,png,webp,svg}')
  return images.map((img) => {
    const buffer = fs.readFileSync(img)
    const hash = crypto.createHash('sha256').update(buffer).digest('hex')
    return {
      file: path.relative(root, img),
      hash,
    }
  })
}

// ---------------------------
// 🧠 SCORE ENGINE
// ---------------------------
function calculateScore() {
  const images = getFiles('**/*.{jpg,jpeg,png,webp,svg}')
  const cssFiles = getFiles('**/*.css')
  const jsFiles = getFiles('**/*.js')

  let score = 100

  if (images.length > 50) score -= 10
  if (cssFiles.length > 10) score -= 5
  if (jsFiles.length > 15) score -= 5

  return score
}

// ---------------------------
// 📈 JSON EXPORT
// ---------------------------
function exportJSON(data) {
  fs.writeFileSync('ultrapro-report.json', JSON.stringify(data, null, 2))
}

// ---------------------------
// 📊 HTML REPORT
// ---------------------------
function exportHTML(data) {
  const html = `
  <!DOCTYPE html>
  <html>
  <head>
  <title>ULTRA PRO 5.0</title>
  <style>
  body{font-family:Arial;background:#0f172a;color:#fff;padding:40px}
  .card{background:#1e293b;padding:20px;margin-bottom:20px;border-radius:12px}
  h1{color:#38bdf8}
  </style>
  </head>
  <body>
  <h1>ULTRA PRO 5.0 Dashboard</h1>

  <div class="card">
  <h2>Project Score</h2>
  <p>${data.score}/100</p>
  </div>

  <div class="card">
  <h2>Folder Sizes</h2>
  <pre>${JSON.stringify(data.sizes, null, 2)}</pre>
  </div>

  <div class="card">
  <h2>Total Images Hashed</h2>
  <p>${data.hashes.length}</p>
  </div>

  </body>
  </html>
  `
  fs.writeFileSync('ultrapro-report.html', html)
}

// ---------------------------
// ⚡ CLI ENGINE
// ---------------------------
const data = {
  sizes: getFolderSizes(),
  hashes: [],
  score: calculateScore(),
}

if (args.includes('--images')) {
  data.hashes = getImageHashes()
  console.log('🔐 Hashes generados:', data.hashes.length)
}

if (args.includes('--score')) {
  console.log('📊 Score:', data.score)
}

if (args.includes('--full')) {
  data.hashes = getImageHashes()
  exportJSON(data)
  exportHTML(data)
  console.log('🚀 ULTRA PRO 5.0 Report generado (HTML + JSON)')
}
