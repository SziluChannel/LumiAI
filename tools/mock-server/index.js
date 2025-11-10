const express = require('express');
const app = express();
app.use(express.json());

app.post('/analyze', (req, res) => {
  // egyszerű stub válasz, helyettesíti a Gemini/CloudFunction választ
  res.json({
    description: "Stub: A fotón egy tárgy látható.",
    confidence: 0.95,
    suggestions: ["Tapogasd körbe a tárgyat", "Közelebb menj hozzá"]
  });
});

const port = process.env.PORT || 3001;
app.listen(port, () => console.log(`Mock server listening on ${port}`));