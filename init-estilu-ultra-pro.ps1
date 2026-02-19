Write-Host "🚀 Inicializando Estilu Castellano Ultra PRO..."

# ==============================
# FUNCION SEGURA DE CREACION
# ==============================

function Ensure-Directory {
    param ($path)
    if (!(Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
        Write-Host "📁 Carpeta creada: $path"
    } else {
        Write-Host "✔ Carpeta existente: $path"
    }
}

function Ensure-File {
    param ($path, $content)
    if (!(Test-Path $path)) {
        Set-Content -Path $path -Value $content
        Write-Host "📄 Archivo creado: $path"
    } else {
        Write-Host "✔ Archivo existente: $path"
    }
}

# ==============================
# ESTRUCTURA BASE
# ==============================

Ensure-Directory "data"
Ensure-Directory "modules"
Ensure-Directory "modules/grammar"
Ensure-Directory "modules/grammar/domain"
Ensure-Directory "modules/grammar/application"
Ensure-Directory "modules/grammar/infrastructure"
Ensure-Directory "modules/grammar/content"
Ensure-Directory "modules/grammar/metrics"

# ==============================
# DATA JSON BASE
# ==============================

$metadata = @"
{
  "module": {
    "id": "grammar_module_v1",
    "slug": "gramatica",
    "version": "1.0.0",
    "accessLevels": ["public", "basic", "premium"]
  },
  "analytics": {
    "trackViews": true,
    "trackProgress": true,
    "trackCompletionRate": true,
    "trackTimeSpent": true,
    "trackDropOff": true
  }
}
"@

Ensure-File "data/grammar.metadata.json" $metadata

$principles = @"
{
  "principles": [
    { "id": "p1", "slug": "verbo", "order": 1, "levelAccess": "public" },
    { "id": "p2", "slug": "analogia", "order": 2, "levelAccess": "basic" }
  ]
}
"@

Ensure-File "data/grammar.principles.json" $principles

$lessons = @"
{
  "lessons": [
    {
      "id": "l1",
      "slug": "verbo-intro",
      "principleId": "p1",
      "accessLevel": "public",
      "estimatedTime": 10,
      "progressTracking": {
        "minimumScoreToUnlockNext": 0.7
      }
    }
  ]
}
"@

Ensure-File "data/grammar.lessons.json" $lessons

Ensure-File "data/grammar.index.json" '{ "index": [] }'

# ==============================
# DOMAIN LAYER
# ==============================

Ensure-File "modules/grammar/domain/principle.entity.js" @"
class Principle {
  constructor({ id, slug, order, levelAccess }) {
    this.id = id;
    this.slug = slug;
    this.order = order;
    this.levelAccess = levelAccess;
  }
}
module.exports = Principle;
"@

Ensure-File "modules/grammar/domain/lesson.entity.js" @"
class Lesson {
  constructor(data) {
    Object.assign(this, data);
  }
}
module.exports = Lesson;
"@

Ensure-File "modules/grammar/domain/progression.entity.js" @"
class Progression {
  constructor({ userId, lessonId, completed, score, timeSpent }) {
    this.userId = userId;
    this.lessonId = lessonId;
    this.completed = completed;
    this.score = score;
    this.timeSpent = timeSpent;
  }
}
module.exports = Progression;
"@

# ==============================
# APPLICATION LAYER
# ==============================

Ensure-File "modules/grammar/application/getPrinciples.usecase.js" @"
const data = require('../../../data/grammar.principles.json');

function getPrinciples() {
  return data.principles;
}

module.exports = getPrinciples;
"@

Ensure-File "modules/grammar/application/unlockLesson.usecase.js" @"
function canAccess(userLevel, lessonLevel) {
  const hierarchy = { public: 0, basic: 1, premium: 2 };
  return hierarchy[userLevel] >= hierarchy[lessonLevel];
}

module.exports = canAccess;
"@

# ==============================
# METRICS ULTRA PRO
# ==============================

Ensure-File "modules/grammar/metrics/analytics.service.js" @"
class AnalyticsService {

  static trackView(userId, lessonId) {
    console.log('View tracked:', userId, lessonId);
  }

  static trackProgress(userId, lessonId, score, timeSpent) {
    console.log('Progress tracked:', userId, lessonId, score, timeSpent);
  }

  static trackCompletionRate(completedLessons, totalLessons) {
    return completedLessons / totalLessons;
  }

  static detectDropOff(timeSpent, estimatedTime) {
    return timeSpent < estimatedTime * 0.3;
  }

}

module.exports = AnalyticsService;
"@

# ==============================
# EXPRESS BASE
# ==============================

Ensure-File "server.js" @"
const express = require('express');
const app = express();
const getPrinciples = require('./modules/grammar/application/getPrinciples.usecase');

app.use(express.json());

app.get('/api/grammar/principles', (req, res) => {
  res.json(getPrinciples());
});

app.listen(3000, () => {
  console.log('🚀 Estilu Engine corriendo en http://localhost:3000');
});
"@

# ==============================
# PACKAGE.JSON SI NO EXISTE
# ==============================

if (!(Test-Path "package.json")) {
    Write-Host "📦 Inicializando Node..."
    npm init -y | Out-Null
    npm install express jsonwebtoken cors | Out-Null
}

Write-Host "✅ Arquitectura Ultra PRO lista."
Write-Host "Ejecuta: node server.js"
