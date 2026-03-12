CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(150) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  avatar_url TEXT,
  location VARCHAR(255),
  is_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('sme', 'influencer', 'admin')),
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now()
);

CREATE TABLE influencers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  username VARCHAR(50) NOT NULL UNIQUE,
  bio TEXT,
  followers_count INTEGER DEFAULT 0,
  engagement_rate DECIMAL(5,2) DEFAULT 0.00, -- percent (e.g., 4.25 = 4.5%)
  niche VARCHAR(100) NOT NULL,
  sub_niche VARCHAR(100),
  price_per_post DECIMAL(10,2) NOT NULL,
  min_price DECIMAL(10,2),
  max_price DECIMAL(10,2),
  instagram_url VARCHAR(255),
  tiktok_url VARCHAR(255),
  youtube_url VARCHAR(255),
  portfolio_url TEXT,
  rating DECIMAL(3,2) DEFAULT 0.00,
  total_orders INTEGER DEFAULT 0,
  avalaibility_status VARCHAR(20) NOT NULL DEFAULT 'available' CHECK (avalaibility_status IN ('available', 'busy', 'unavailable')),
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now()
);

-- Orders
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  influencer_id UUID NOT NULL REFERENCES influencers(id) ON DELETE CASCADE,
  sme_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  campign_type VARCHAR(50) NOT NULL, -- 'post', 'story', 'video', 'package'.
  order_status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (order_status IN ('pending', 'accepted', 'inprogress', 'completed', 'cancelled')),
  total_price DECIMAL(12,2) NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now()
);

-- Reviews
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  review_type VARCHAR(20) NOT NULL CHECK (review_type IN ('sme_to_influencer', 'influencer_to_sme')),
  is_public BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now()
);

CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_user_type ON users(user_type);
CREATE INDEX idx_influencer_niche ON influencers(niche);
CREATE INDEX idx_influencer_rating ON influencers(rating);
CREATE INDEX idx_order_status ON orders(order_status);
CREATE INDEX idx_order_influencer ON orders(influencer_id);
CREATE INDEX idx_order_sme ON orders(sme_id);
CREATE INDEX idx_review_order ON reviews(order_id);
CREATE INDEX idx_review_rating ON reviews(rating);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE influencers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_influencers_updated_at BEFORE UPDATE ON influencers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 5 Users
INSERT INTO users (id, name, email, password, phone, avatar_url, location, is_verified, is_active, user_type)
VALUES
('11111111-1111-1111-1111-111111111111','Alya Putri','alya.putri@example.com','$2b$10$hash1','+628111000000','https://example.com/avatars/alya.jpg','Jakarta, ID',TRUE,TRUE,'influencer'),
('22222222-2222-2222-2222-222222222222','Bima Santoso','bima.santoso@example.com','$2b$10$hash2','+628111000001','https://example.com/avatars/bima.jpg','Bandung, ID',TRUE,TRUE,'influencer'),
('33333333-3333-3333-3333-333333333333','Citra Dewi','citra.dewi@example.com','$2b$10$hash3','+628111000002','https://example.com/avatars/citra.jpg','Surabaya, ID',FALSE,TRUE,'influencer'),
('44444444-4444-4444-4444-444444444444','Dedi Ramadhan','dedi.ramadhan@example.com','$2b$10$hash4','+628111000003','https://example.com/avatars/dedi.jpg','Yogyakarta, ID',TRUE,TRUE,'influencer'),
('55555555-5555-5555-5555-555555555555','Eka Nur','eka.nur@example.com','$2b$10$hash5','+628111000004','https://example.com/avatars/eka.jpg','Medan, ID',FALSE,TRUE,'influencer');

-- 5 Influencers (referencing the users above)
INSERT INTO influencers (id, user_id, username, bio, followers_count, engagement_rate, niche, sub_niche, price_per_post, min_price, max_price, instagram_url, tiktok_url, youtube_url, portfolio_url, rating, total_orders, avalaibility_status)
VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','11111111-1111-1111-1111-111111111111','alya.influencer','Lifestyle & travel content creator',125000,4.75,'lifestyle','travel',1500000.00,1000000.00,2000000.00,'https://instagram.com/alya','https://tiktok.com/@alya',NULL,'https://portfolio.example.com/alya',4.85,42,'available'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','22222222-2222-2222-2222-222222222222','bima.fit','Fitness coach and healthy living',98000,5.20,'fitness','home-workouts',1200000.00,800000.00,1500000.00,'https://instagram.com/bima','https://tiktok.com/@bima','https://youtube.com/bimafit','https://portfolio.example.com/bima',4.92,58,'busy'),
('cccccccc-cccc-cccc-cccc-cccccccccccc','33333333-3333-3333-3333-333333333333','citra.beauty','Beauty reviews and tutorials',210000,3.60,'beauty','skincare',2000000.00,1500000.00,3000000.00,'https://instagram.com/citra','https://tiktok.com/@citra',NULL,'https://portfolio.example.com/citra',4.60,120,'available'),
('dddddddd-dddd-dddd-dddd-dddddddddddd','44444444-4444-4444-4444-444444444444','dedi.tech','Gadget reviewer and tech tips',54000,6.10,'technology','gadgets',900000.00,700000.00,1200000.00,'https://instagram.com/dedi','https://tiktok.com/@dedi','https://youtube.com/deditech','https://portfolio.example.com/dedi',4.95,30,'available'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee','55555555-5555-5555-5555-555555555555','eka.foodie','Food & recipe creator',175000,4.10,'food','recipes',1300000.00,1000000.00,1800000.00,'https://instagram.com/eka','https://tiktok.com/@eka',NULL,'https://portfolio.example.com/eka',4.70,76,'unavailable');

-- 5 Orders (each references an influencer and a sme_id from users above)
INSERT INTO orders (id, influencer_id, sme_id, title, description, campign_type, order_status, total_price)
VALUES
('10101010-1010-1010-1010-101010101010','aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','22222222-2222-2222-2222-222222222222','Promo Paket Liburan','Promosi paket liburan 3 hari 2 malam; 1 post + 3 story','post', 'pending', 3000000.00),
('20202020-2020-2020-2020-202020202020','bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','33333333-3333-3333-3333-333333333333','Peluncuran Produk Fitness','1 video review + 2 post untuk peluncuran produk baru','video','accepted', 4500000.00),
('30303030-3030-3030-3030-303030303030','cccccccc-cccc-cccc-cccc-cccccccccccc','11111111-1111-1111-1111-111111111111','Kolaborasi Skincare','Campaign edukasi skincare; 2 post + 4 story','package','inprogress', 7000000.00),
('40404040-4040-4040-4040-404040404040','dddddddd-dddd-dddd-dddd-dddddddddddd','55555555-5555-5555-5555-555555555555','Review Gadget Baru','1 post + 1 video unboxing','post','completed', 2100000.00),
('50505050-5050-5050-5050-505050505050','eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee','44444444-4444-4444-4444-444444444444','Konten Kuliner Musiman','3 story + 1 post untuk menu musiman','story','cancelled', 900000.00);

-- 5 Reviews (each references an order)
INSERT INTO reviews (id, order_id, rating, comment, review_type, is_public)
VALUES
('f1f1f1f1-f1f1-f1f1-f1f1-f1f1f1f1f1f1','10101010-1010-1010-1010-101010101010',5,'Konten sesuai brief, engagement bagus.','sme_to_influencer',TRUE),
('f2f2f2f2-f2f2-f2f2-f2f2-f2f2f2f2f2f2','20202020-2020-2020-2020-202020202020',4,'Video berkualitas, ada beberapa revisi kecil.','sme_to_influencer',TRUE),
('f3f3f3f3-f3f3-f3f3-f3f3-f3f3f3f3f3f3','30303030-3030-3030-3030-303030303030',5,'Kolaborasi lancar dan tepat waktu.','sme_to_influencer',TRUE),
('f4f4f4f4-f4f4-f4f4-f4f4-f4f4f4f4f4f4','40404040-4040-4040-4040-404040404040',5,'Unboxing sangat informatif, audiens tertarik.','sme_to_influencer',TRUE),
('f5f5f5f5-f5f5-f5f5-f5f5-f5f5f5f5f5f5','50505050-5050-5050-5050-505050505050',2,'Pembatalan mendadak; komunikasi perlu diperbaiki.','sme_to_influencer',FALSE);
