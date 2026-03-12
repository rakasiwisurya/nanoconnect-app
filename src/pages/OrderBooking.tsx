import { Link, useParams } from "react-router-dom";
import Button from "../components/Button";
import Input from "../components/Input";
import Textarea from "../components/Textarea";
import { useEffect, useState } from "react";
import { supabase } from "../services/supabase";

export default function OrderBooking() {
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
          id, username, price_per_post, min_price, max_price,
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
        <div className="text-center py-20">
          Memuat detail booking influencer...
        </div>
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
    <main className="min-h-screen flex flex-col justify-center items-center bg-background text-white px-4">
      <section className="w-full max-w-lg text-center py-20">
        <h1 className="text-4xl font-bold mb-6">Booking Influencer</h1>
        <form className="bg-secondary rounded-xl shadow-lg p-8 flex flex-col gap-6">
          <Input
            type="text"
            placeholder="Nama UMKM"
            label="Nama UMKM"
            required
          />
          <Input type="email" placeholder="Email" label="Email" required />
          <Input
            type="text"
            placeholder="Nama Influencer"
            label="Nama Influencer"
            value={inf.user?.name || inf.username}
            readOnly
          />
          <Input
            type="text"
            placeholder="Budget (Rp)"
            label="Budget (Rp)"
            value={
              inf.price_per_post
                ? `Rp ${Number(inf.price_per_post).toLocaleString("id-ID")}`
                : "-"
            }
            readOnly
          />
          <Textarea
            placeholder="Deskripsi Campaign"
            label="Deskripsi Campaign"
            rows={4}
            required
          />
          <Button type="submit">
            Booking Sekarang <i className="fa-solid fa-paper-plane ml-2"></i>
          </Button>
        </form>
      </section>
    </main>
  );
}
