import Card from "../components/Card";

export default function TermsConditions() {
  return (
    <main className="min-h-screen flex flex-col justify-center items-center bg-background text-white px-4">
      <section className="w-full max-w-2xl text-center py-20">
        <h1 className="text-4xl font-bold mb-6">Syarat & Ketentuan</h1>
        <Card className="text-left text-gray-200">
          <ol className="list-decimal ml-6 space-y-2">
            <li>
              Platform ini hanya untuk kolaborasi UMKM dan nano influencer.
            </li>
            <li>
              Data pengguna dijaga kerahasiaannya dan tidak dibagikan ke pihak
              ketiga tanpa izin.
            </li>
            <li>
              Setiap booking harus melalui sistem untuk keamanan dan
              transparansi.
            </li>
            <li>Pembayaran dilakukan sesuai instruksi resmi dari platform.</li>
            <li>
              Platform berhak menolak atau membatalkan booking yang tidak sesuai
              ketentuan.
            </li>
          </ol>
        </Card>
      </section>
    </main>
  );
}
