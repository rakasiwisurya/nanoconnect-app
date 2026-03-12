import Card from "../components/Card";
import { Link } from "react-router-dom";
import { useEffect, useState } from "react";
import { supabase } from "../services/supabase";

export default function InfluencerListing() {
  const [influencers, setInfluencers] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchInfluencers = async () => {
      setLoading(true);
      setError("");
      // Fetch influencers with user profile (join)
      const { data, error } = await supabase
        .from("influencers")
        .select(
          `
          id, username, bio, niche, sub_niche, price_per_post, min_price, max_price,
          instagram_url, tiktok_url, youtube_url, portfolio_url, rating, total_orders,
          avalaibility_status, user_id,
          user:user_id (name, avatar_url, location)
        `,
        )
        .order("created_at", { ascending: false });
      if (error) setError(error.message);
      else setInfluencers(data || []);
      setLoading(false);
    };
    fetchInfluencers();
  }, []);

  return (
    <main className="min-h-screen bg-background text-white px-4 py-12">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-4xl font-bold mb-8 text-center">
          Daftar Nano Influencer
        </h1>
        {loading && (
          <div className="text-accent text-center py-8">
            Memuat data influencer...
          </div>
        )}
        {error && <div className="text-red-400 text-center py-8">{error}</div>}
        {/* Debug: tampilkan data mentah jika kosong */}
        {!loading && influencers.length === 0 && (
          <div className="text-yellow-400 text-center py-8">
            Tidak ada data influencer ditemukan.
            <br />
            <pre className="text-xs text-white bg-gray-800 p-2 rounded mt-2 overflow-x-auto max-w-full">
              {JSON.stringify(influencers, null, 2)}
            </pre>
            {error && <div className="text-red-400">{error}</div>}
          </div>
        )}
        <div className="grid md:grid-cols-3 gap-8">
          {influencers.map((inf) => (
            <Card key={inf.id} className="flex flex-col items-center p-6">
              <img
                src={inf.user?.avatar_url || "/default-avatar.png"}
                alt={inf.user?.name || inf.username}
                className="w-24 h-24 rounded-full mb-4 border-4 border-accent"
              />
              <h2 className="text-xl font-semibold mb-1">
                {inf.user?.name || inf.username}
              </h2>
              <div className="text-accent font-medium mb-2">{inf.niche}</div>
              <div className="mb-2 flex items-center">
                <i className="fa-solid fa-location-dot mr-2"></i>
                {inf.user?.location || "-"}
              </div>
              <div className="mb-2 flex items-center">
                <i className="fa-solid fa-money-bill-wave mr-2"></i>
                Rp {Number(inf.price_per_post).toLocaleString("id-ID")}
              </div>
              {inf.portfolio_url && (
                <a
                  href={inf.portfolio_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="mt-2 text-accent hover:underline flex items-center"
                >
                  <i className="fa-brands fa-instagram mr-2"></i> Portfolio
                </a>
              )}
              <Link
                to={`/influencer/${inf.id}`}
                className="mt-4 w-full justify-center px-8 py-3 rounded-lg font-bold transition flex items-center focus:outline-none focus:ring-2 focus:ring-accent bg-accent text-white hover:bg-primary cursor-pointer border-2 border-white shadow-lg shadow-white/20"
              >
                Detail <i className="fa-solid fa-arrow-right ml-2"></i>
              </Link>
            </Card>
          ))}
        </div>
      </div>
    </main>
  );
}
