import { Link } from "react-router-dom";

export default function Homepage() {
  return (
    <main className="min-h-screen flex flex-col justify-center items-center bg-background text-white px-4">
      <div className="w-full max-w-3xl text-center py-24">
        <h1 className="text-5xl md:text-6xl font-bold mb-6 leading-tight">
          NanoConnect
        </h1>
        <h2 className="text-2xl md:text-3xl font-semibold mb-8">
          "Tinder for UMKM & Nano Influencers"
        </h2>
        <p className="text-lg md:text-xl mb-10 text-gray-300">
          Platform cerdas untuk mempertemukan UMKM dengan nano influencer lokal
          berdasarkan budget, niche, lokasi, dan target audiens.
        </p>
        <Link
          to="/influencers"
          className="inline-block px-8 py-4 rounded-lg bg-accent text-white font-bold text-lg shadow-lg hover:bg-primary transition cursor-pointer border-2 border-white shadow-white/20"
        >
          Temukan Influencer
          <i className="fa-solid fa-arrow-right ml-3"></i>
        </Link>
      </div>
    </main>
  );
}
