import Card from "../components/Card";
import { useParams, Link } from "react-router-dom";
import { useEffect, useState } from "react";
import { supabase } from "../services/supabase";

export default function InfluencerDetail() {
  const { id } = useParams();
  const [inf, setInf] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchInfluencer = async () => {
      setLoading(true);
      setError("");
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
        .eq("id", id)
        .single();
      if (error) setError(error.message);
      else setInf(data);
      setLoading(false);
    };
    if (id) fetchInfluencer();
  }, [id]);

  if (loading) {
    return (
      <main className="min-h-screen flex flex-col justify-center items-center bg-background text-white px-4">
        <div className="text-center py-20">Memuat detail influencer...</div>
      </main>
    );
  }

  if (error || !inf) {
    return (
      <main className="min-h-screen flex flex-col justify-center items-center bg-background text-white px-4">
        <div className="text-center py-20">
          <h1 className="text-3xl font-bold mb-4">
            Influencer tidak ditemukan
          </h1>
          <div className="text-red-400 mb-2">{error}</div>
          <Link to="/influencers" className="text-accent hover:underline">
            Kembali ke daftar
          </Link>
        </div>
      </main>
    );
  }

  return (
    <main className="min-h-screen bg-background text-white px-4 py-12 flex flex-col items-center">
      <Card className="max-w-xl w-full flex flex-col items-center p-8">
        <img
          src={inf.user?.avatar_url || "/default-avatar.jpg"}
          alt={inf.user?.name || inf.username}
          className="w-28 h-28 rounded-full mb-4 border-4 border-accent"
        />
        <h1 className="text-3xl font-bold mb-2">
          {inf.user?.name || inf.username}
        </h1>
        <div className="text-accent font-medium mb-2">{inf.niche}</div>
        <div className="mb-2 flex items-center">
          <i className="fa-solid fa-location-dot mr-2"></i>
          {inf.user?.location || "-"}
        </div>
        <div className="mb-2 flex items-center">
          <i className="fa-solid fa-money-bill-wave mr-2"></i>
          Rp {Number(inf.price_per_post).toLocaleString("id-ID")}
        </div>
        <p className="mb-4 text-gray-200 text-center">{inf.bio}</p>
        {inf.portfolio_url && (
          <a
            href={inf.portfolio_url}
            target="_blank"
            rel="noopener noreferrer"
            className="mb-4 text-accent hover:underline flex items-center"
          >
            <i className="fa-brands fa-instagram mr-2"></i> Portfolio
          </a>
        )}
        <Link
          to={`/order/${inf.id}`}
          className="w-full justify-center mt-2 px-8 py-3 rounded-lg font-bold transition flex items-center focus:outline-none focus:ring-2 focus:ring-accent bg-accent text-white hover:bg-primary cursor-pointer border-2 border-white shadow-lg shadow-white/20"
        >
          Booking <i className="fa-solid fa-calendar-check ml-2"></i>
        </Link>
        <Link to="/influencers" className="mt-4 text-accent hover:underline">
          Kembali ke daftar
        </Link>
      </Card>
    </main>
  );
}
