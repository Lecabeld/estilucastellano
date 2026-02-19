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
