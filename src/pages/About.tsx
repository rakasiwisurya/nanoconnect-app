export default function About() {
  return (
    <main className="min-h-screen flex flex-col justify-center items-center bg-background text-white px-4">
      <section className="w-full max-w-2xl text-center py-20">
        <h1 className="text-4xl md:text-5xl font-bold mb-6">
          Tentang NanoConnect
        </h1>
        <p className="text-lg md:text-xl mb-8 text-gray-300">
          NanoConnect adalah platform yang menghubungkan UMKM dengan nano
          influencer lokal secara cerdas dan efisien. Kami membantu bisnis kecil
          menemukan influencer yang tepat berdasarkan budget, niche, lokasi, dan
          target audiens, sehingga kolaborasi menjadi lebih mudah dan terukur.
        </p>
        <div className="flex flex-col gap-4 text-left text-base md:text-lg text-gray-200">
          <div>
            <i className="fa-solid fa-bolt text-accent mr-2"></i>
            <b>Real-time Matching:</b> Proses pencocokan cepat dan akurat.
          </div>
          <div>
            <i className="fa-solid fa-users text-accent mr-2"></i>
            <b>Fokus UMKM & Nano Influencer:</b> Solusi khusus untuk kebutuhan
            lokal.
          </div>
          <div>
            <i className="fa-solid fa-shield-halved text-accent mr-2"></i>
            <b>Keamanan & Transparansi:</b> Proses booking dan kolaborasi yang
            aman.
          </div>
        </div>
      </section>
    </main>
  );
}
