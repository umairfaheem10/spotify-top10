import axios from "axios";

const clientId = "80baa8f9df1d4de7ab2c996872a20eba"; // replace with your Spotify Client ID
const clientSecret = "7132882eb6e1413489fce00787570780"; // replace with your Spotify Client Secret

let accessToken = null;
let tokenExpiry = 0;

export async function getSpotifyToken() {
  const now = Date.now();

  if (accessToken && now < tokenExpiry) {
    return accessToken; // reuse token if still valid
  }

  const tokenUrl = "https://accounts.spotify.com/api/token";
  const authHeader = Buffer.from(`${clientId}:${clientSecret}`).toString("base64");

  const response = await axios.post(
    tokenUrl,
    new URLSearchParams({ grant_type: "client_credentials" }),
    { headers: { Authorization: `Basic ${authHeader}`, "Content-Type": "application/x-www-form-urlencoded" } }
  );

  accessToken = response.data.access_token;
  tokenExpiry = now + response.data.expires_in * 1000; // cache for 1 hour
  return accessToken;
}
