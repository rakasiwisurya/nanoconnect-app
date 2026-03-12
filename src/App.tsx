import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import Homepage from "./pages/Homepage";
import About from "./pages/About";
import InfluencerListing from "./pages/InfluencerListing";
import InfluencerDetail from "./pages/InfluencerDetail";
import OrderBooking from "./pages/OrderBooking";
import AIRecommendations from "./pages/AIRecommendations";
import TermsConditions from "./pages/TermsConditions";
import AuthPages from "./pages/AuthPages";
import RegisterPage from "./pages/RegisterPage";

function App() {
  return (
    <Router>
      <nav className="w-full flex justify-center gap-8 py-6 bg-background text-white text-lg font-semibold shadow">
        <Link to="/">Beranda</Link>
        <Link to="/about">Tentang</Link>
        <Link to="/influencers">Influencer</Link>
        <Link to="/ai-recommendations">AI Rekomendasi</Link>
        <Link to="/terms">Syarat & Ketentuan</Link>
        <Link to="/auth">Masuk</Link>
      </nav>
      <Routes>
        <Route path="/" element={<Homepage />} />
        <Route path="/about" element={<About />} />
        <Route path="/influencers" element={<InfluencerListing />} />
        <Route path="/influencer/:id" element={<InfluencerDetail />} />
        <Route path="/order/:id" element={<OrderBooking />} />
        <Route path="/ai-recommendations" element={<AIRecommendations />} />
        <Route path="/terms" element={<TermsConditions />} />
        <Route path="/auth" element={<AuthPages />} />
        <Route path="/register" element={<RegisterPage />} />
      </Routes>
    </Router>
  );
}

export default App;
