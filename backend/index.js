import express from "express";
import axios from "axios";
import { getSpotifyToken } from "./spotifyAuth.js";

const app = express();
const PORT = process.env.PORT || 3000;

app.get("/api/artist/:name", async (req, res) => {
  try {
    const name = req.params.name;
    const token = await getSpotifyToken();

    const response = await axios.get(
      `https://api.spotify.com/v1/search?q=${encodeURIComponent(name)}&type=artist&limit=1`,
      { headers: { Authorization: `Bearer ${token}` } }
    );

    const artist = response.data.artists.items[0];
    if (!artist) return res.status(404).json({ error: "Artist not found" });

    res.json({
      name: artist.name,
      followers: artist.followers.total,
      genres: artist.genres,
      image: artist.images[0]?.url || null,
      spotifyUrl: artist.external_urls.spotify,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
