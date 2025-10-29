// scraper.js
const axios = require('axios');
const cheerio = require('cheerio');

async function getTop10Artists() {
  const url = 'https://kworb.net/spotify/listeners.html';
  const { data } = await axios.get(url);
  const $ = cheerio.load(data);

  const results = [];

  $('table').first().find('tr').each((i, row) => {
    if (i === 0) return; // skip header
    if (i > 10) return false; // only top 10

    const cols = $(row).find('td');
    const rank = parseInt($(cols[0]).text().trim(), 10);
    const artist = $(cols[1]).text().trim();
    const listeners = parseInt($(cols[2]).text().trim().replace(/,/g, ''), 10);

    results.push({ rank, artist, listeners });
  });

  return results;
}

module.exports = { getTop10Artists };
