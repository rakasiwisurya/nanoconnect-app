import { useState, type SubmitEvent } from "react";
import { Link } from "react-router-dom";
import Button from "../components/Button";
import { supabase } from "../services/supabase";

export default function AuthPages() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);

  const handleEmail = async (e: SubmitEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setMessage("");
    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });
    if (error) setMessage(error.message);
    else
      setMessage("Login berhasil! Cek email untuk verifikasi jika diperlukan.");
    setLoading(false);
  };

  return (
    <main className="min-h-screen flex flex-col justify-center items-center bg-background text-white px-4">
      <section className="w-full max-w-md text-center py-20">
        <h1 className="text-4xl font-bold mb-6">Masuk</h1>
        <div className="bg-secondary rounded-xl shadow-lg p-8 flex flex-col gap-6">
          <form onSubmit={handleEmail} className="flex flex-col gap-4">
            <input
              type="email"
              className="px-4 py-3 rounded bg-background border border-accent text-white focus:outline-none focus:ring-2 focus:ring-accent placeholder:text-gray-400"
              placeholder="Email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              style={{ cursor: "text" }}
            />
            <input
              type="password"
              className="px-4 py-3 rounded bg-background border border-accent text-white focus:outline-none focus:ring-2 focus:ring-accent placeholder:text-gray-400"
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              style={{ cursor: "text" }}
            />
            <Button type="submit" disabled={loading}>
              <i className="fa-solid fa-envelope mr-2"></i> Masuk dengan Email
            </Button>
          </form>
          <div className="mt-4">
            Belum punya akun?{" "}
            <Link
              to="/register"
              className="text-accent underline hover:text-primary"
            >
              Daftar di sini
            </Link>
          </div>
          {message && <div className="mt-4 text-accent">{message}</div>}
        </div>
      </section>
    </main>
  );
}
