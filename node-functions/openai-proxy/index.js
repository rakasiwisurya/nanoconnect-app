// node-functions/openai-proxy/index.js

const OpenAI = require("openai");

if (!process.env.GROQ_API_KEY) {
  throw new Error("GROQ_API_KEY not set");
}

const openai = new OpenAI({
  apiKey: process.env.GROQ_API_KEY,
  baseURL: "https://api.groq.com/openai/v1",
});

module.exports = async (req, res) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    res.writeHead(200);
    return res.end();
  }

  if (req.method !== "POST") {
    res.writeHead(405, { "Content-Type": "application/json" });
    return res.end(JSON.stringify({ error: "Method not allowed" }));
  }

  let body = "";

  req.on("data", (chunk) => {
    body += chunk.toString();
  });

  req.on("end", async () => {
    try {
      const { prompt, influencers } = JSON.parse(body);

      if (!prompt || !Array.isArray(influencers)) {
        throw new Error("Prompt and influencers array required");
      }

      // batasi influencer supaya token hemat
      const influencerList = influencers
        .slice(0, 10)
        .map((inf, idx) => {
          const name = inf.user?.name || inf.username || "Unknown";
          const niche = inf.niche || "-";
          const location = inf.user?.location || "-";
          const price = inf.price_per_post || "-";
          const bio = inf.bio || "-";

          return `${idx + 1}. ${name}
Niche: ${niche}
Location: ${location}
Rate: Rp${price}
Bio: ${bio}`;
        })
        .join("\n\n");

      const systemPrompt = `
Kamu adalah AI yang membantu UMKM memilih influencer marketing.

Berdasarkan daftar influencer berikut:

${influencerList}

Tugas:
- Analisa kebutuhan user
- Pilih maksimal 5 influencer paling cocok
- Jelaskan alasan pemilihannya

Jawaban HARUS dalam format seperti ini:

Nama: "Nama Influencer",
Alasan: "Alasan cocok"
`;

      const response = await openai.chat.completions.create({
        model: "llama-3.1-8b-instant",
        messages: [
          {
            role: "system",
            content: systemPrompt,
          },
          {
            role: "user",
            content: prompt,
          },
        ],
        temperature: 0.7,
        max_tokens: 500,
      });

      const result = response.choices[0].message.content;

      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ result }));
    } catch (error) {
      console.error("AI Error:", error);

      res.writeHead(500, { "Content-Type": "application/json" });
      res.end(
        JSON.stringify({
          error: error.message || "Internal server error",
        }),
      );
    }
  });
};
