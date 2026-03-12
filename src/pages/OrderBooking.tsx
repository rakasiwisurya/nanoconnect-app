import Button from "../components/Button";
import Input from "../components/Input";
import Textarea from "../components/Textarea";

export default function OrderBooking() {
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
            required
          />
          <Input
            type="text"
            placeholder="Budget (Rp)"
            label="Budget (Rp)"
            required
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
