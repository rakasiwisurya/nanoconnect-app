import { useState, type SubmitEvent } from "react";
import { useNavigate } from "react-router-dom";
import Button from "../components/Button";
import { supabase } from "../services/supabase";

export default function RegisterPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [name, setName] = useState("");
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleRegister = async (e: SubmitEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setMessage("");
    // Supabase sign up
    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: { name },
      },
    });
    if (error) setMessage(error.message);
    else {
      setMessage("Registrasi berhasil! Silakan cek email untuk verifikasi.");
      setTimeout(() => navigate("/auth"), 2000);
    }
    setLoading(false);
  };

  return (
    <main className="min-h-screen flex flex-col justify-center items-center bg-background text-white px-4">
      <section className="w-full max-w-md text-center py-20">
        <h1 className="text-4xl font-bold mb-6">Daftar Akun</h1>
        <div className="bg-secondary rounded-xl shadow-lg p-8 flex flex-col gap-6">
          <form onSubmit={handleRegister} className="flex flex-col gap-4">
            <input
              type="text"
              className="px-4 py-3 rounded bg-background border border-accent text-white focus:outline-none focus:ring-2 focus:ring-accent placeholder:text-gray-400"
              placeholder="Nama Lengkap"
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
              style={{ cursor: "text" }}
            />
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
              <i className="fa-solid fa-user-plus mr-2"></i> Daftar
            </Button>
          </form>
          {message && <div className="mt-4 text-accent">{message}</div>}
        </div>
      </section>
    </main>
  );
}
