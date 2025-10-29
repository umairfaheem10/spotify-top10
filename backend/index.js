// index.js
const express = require('express');
const cors = require('cors');
const { getTop10Artists } = require('./scrapper');

const app = express();
app.use(cors());

app.get('/', (req, res) => {
  res.send('Spotify Top 10 API is running 🚀');
});

app.get('/api/top10', async (req, res) => {
  try {
    const data = await getTop10Artists();
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch data' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`✅ Server running on port ${PORT}`));
