import { useState, useEffect, type SubmitEvent } from "react";
import { supabase } from "../services/supabase";
import Card from "../components/Card";
import Button from "../components/Button";
import Textarea from "../components/Textarea";

export default function AIRecommendations() {
  const [input, setInput] = useState("");
  const [result, setResult] = useState("");
  const [loading, setLoading] = useState(false);
  const [influencers, setInfluencers] = useState<any[]>([]);

  useEffect(() => {
    supabase
      .from("influencers")
      .select(
        `
        id, username, bio, niche, sub_niche, price_per_post, min_price, max_price,
        instagram_url, tiktok_url, youtube_url, portfolio_url, rating, total_orders,
        avalaibility_status, user_id,
        user:user_id (name, avatar_url, location)
      `,
      )
      .then(({ data }) => setInfluencers(data || []));
  }, []);

  const handleSubmit = async (e: SubmitEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setResult("");
    try {
      const API_URL = import.meta.env.DEV
        ? "http://localhost:3001/api/openai-proxy"
        : "/api/openai-proxy";

      const res = await fetch(API_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          prompt: input,
          influencers,
        }),
      });
      const data = await res.json();
      setResult(data.result || "");
    } catch (err: any) {
      setResult("Gagal mendapatkan rekomendasi dari AI.");
    }
    setLoading(false);
  };

  return (
    <main className="min-h-screen flex flex-col justify-center items-center bg-background text-white px-4">
      <section className="w-full max-w-2xl text-center py-20">
        <h1 className="text-4xl font-bold mb-6">Rekomendasi AI</h1>
        <p className="text-lg md:text-xl mb-8 text-gray-300">
          Sistem AI kami akan merekomendasikan influencer terbaik untuk campaign
          Anda berdasarkan budget, niche, lokasi, dan target audiens.
        </p>
        <Card className="mb-8">
          <form
            onSubmit={handleSubmit}
            className="flex flex-col gap-4 items-center"
          >
            <Textarea
              rows={3}
              value={input}
              onChange={(e) => setInput(e.target.value)}
              placeholder="Masukkan deskripsi campaign, budget, lokasi, target audiens"
              required
            />
            <Button type="submit" disabled={loading}>
              {loading ? "Memproses..." : "Dapatkan Rekomendasi AI"}
              <i className="fa-solid fa-robot ml-2"></i>
            </Button>
          </form>
        </Card>
        <Card className="min-h-30">
          {loading && (
            <div className="text-accent">Sedang memproses rekomendasi...</div>
          )}
          {!loading && result && (
            <div className="text-left text-gray-200 whitespace-pre-line">
              {result}
            </div>
          )}
        </Card>
      </section>
    </main>
  );
}
