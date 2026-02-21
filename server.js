const express = require('express');
const path = require('path');

const app = express();
const getPrinciples = require('./modules/grammar/application/getPrinciples.usecase');

app.use(express.json());

// Servir archivos estáticos desde /public
app.use(express.static(path.join(__dirname, 'public')));

app.get('/api/grammar/principles', (req, res) => {
  res.json(getPrinciples());
});

app.listen(3000, () => {
  console.log('🚀 Estilu Engine corriendo en http://localhost:3000');
});