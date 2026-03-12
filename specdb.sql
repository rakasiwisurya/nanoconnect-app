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

-- =========================
-- USERS TABLE POLICIES
-- =========================

CREATE POLICY "users_select_own_profile"
ON users
FOR SELECT
USING (auth.uid() = id);

CREATE POLICY "users_update_own_profile"
ON users
FOR UPDATE
USING (auth.uid() = id);

CREATE POLICY "users_insert_own_profile"
ON users
FOR INSERT
WITH CHECK (auth.uid() = id);


-- =========================
-- INFLUENCERS TABLE POLICIES
-- =========================

-- anyone can view influencers
CREATE POLICY "influencers_public_select"
ON influencers
FOR SELECT
USING (true);

-- influencer can insert their profile
CREATE POLICY "influencers_insert_own"
ON influencers
FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- influencer can update their own profile
CREATE POLICY "influencers_update_own"
ON influencers
FOR UPDATE
USING (auth.uid() = user_id);


-- =========================
-- ORDERS TABLE POLICIES
-- =========================

-- SME can create order
CREATE POLICY "orders_insert_by_sme"
ON orders
FOR INSERT
WITH CHECK (auth.uid() = sme_id);

-- SME can view their orders
CREATE POLICY "orders_select_by_sme"
ON orders
FOR SELECT
USING (auth.uid() = sme_id);

-- influencer can view orders assigned to them
CREATE POLICY "orders_select_by_influencer"
ON orders
FOR SELECT
USING (
  auth.uid() IN (
    SELECT user_id
    FROM influencers
    WHERE influencers.id = orders.influencer_id
  )
);

-- SME can update their own order
CREATE POLICY "orders_update_by_sme"
ON orders
FOR UPDATE
USING (auth.uid() = sme_id);

-- influencer can update order status
CREATE POLICY "orders_update_by_influencer"
ON orders
FOR UPDATE
USING (
  auth.uid() IN (
    SELECT user_id
    FROM influencers
    WHERE influencers.id = orders.influencer_id
  )
);


-- =========================
-- REVIEWS TABLE POLICIES
-- =========================

-- public reviews visible
CREATE POLICY "reviews_public_select"
ON reviews
FOR SELECT
USING (is_public = true);

-- users can create review only if order completed
CREATE POLICY "reviews_insert_after_completed"
ON reviews
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM orders
    WHERE orders.id = reviews.order_id
    AND orders.order_status = 'completed'
    AND (
      orders.sme_id = auth.uid()
      OR
      auth.uid() IN (
        SELECT user_id
        FROM influencers
        WHERE influencers.id = orders.influencer_id
      )
    )
  )
);

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
-- USERS
INSERT INTO users (id, name, email, password, phone, avatar_url, location, user_type)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'Alya Influencer', 'alya@mail.com', '$2b$12$KIXQjZrQxYkV9hXQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8u', '081234567890', 'https://randomuser.me/api/portraits/women/1.jpg', 'Jakarta', 'influencer'), -- password hash for "password123"
  ('22222222-2222-2222-2222-222222222222', 'Bima Fit', 'bima@mail.com', '$2b$12$KIXQjZrQxYkV9hXQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8u', '081234567891', 'https://randomuser.me/api/portraits/men/2.jpg', 'Bandung', 'influencer'), -- password hash for "password123"
  ('33333333-3333-3333-3333-333333333333', 'Citra Beauty', 'citra@mail.com', '$2b$12$KIXQjZrQxYkV9hXQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8u', '081234567892', 'https://randomuser.me/api/portraits/women/3.jpg', 'Surabaya', 'influencer'), -- password hash for "password123"
  ('44444444-4444-4444-4444-444444444444', 'Dedi Tech', 'dedi@mail.com', '$2b$12$KIXQjZrQxYkV9hXQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8u', '081234567893', 'https://randomuser.me/api/portraits/men/4.jpg', 'Yogyakarta', 'influencer'), -- password hash for "password123"
  ('55555555-5555-5555-5555-555555555555', 'Eka Foodie', 'eka@mail.com', '$2b$12$KIXQjZrQxYkV9hXQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8u', '081234567894', 'https://randomuser.me/api/portraits/women/5.jpg', 'Medan', 'influencer'), -- password hash for "password123"
  ('66666666-6666-6666-6666-666666666666', 'UMKM Sukses', 'umkm@mail.com', '$2b$12$KIXQjZrQxYkV9hXQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8u', '081234567895', NULL, 'Semarang', 'sme');

-- INFLUENCERS
INSERT INTO influencers (id, user_id, username, bio, followers_count, engagement_rate, niche, sub_niche, price_per_post, min_price, max_price, instagram_url, tiktok_url, youtube_url, portfolio_url, rating, total_orders, avalaibility_status)
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'alya.influencer', 'Travel & lifestyle content creator. Suka explore hidden gems Indonesia.', 12000, 4.5, 'Lifestyle', 'Travel', 500000, 400000, 700000, 'https://instagram.com/alya.influencer', NULL, NULL, 'https://alya-portfolio.com', 4.8, 15, 'available'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '22222222-2222-2222-2222-222222222222', 'bima.fit', 'Fitness coach, motivator, dan healthy living advocate.', 18000, 5.2, 'Fitness', 'Motivation', 400000, 350000, 600000, 'https://instagram.com/bima.fit', 'https://tiktok.com/@bima.fit', NULL, NULL, 4.6, 20, 'available'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', '33333333-3333-3333-3333-333333333333', 'citra.beauty', 'Beauty enthusiast, skincare reviewer, and makeup artist.', 25000, 6.1, 'Beauty', 'Skincare', 600000, 500000, 800000, 'https://instagram.com/citra.beauty', NULL, 'https://youtube.com/citrabeauty', NULL, 4.9, 30, 'busy'),
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', '44444444-4444-4444-4444-444444444444', 'dedi.tech', 'Gadget reviewer, tech news, dan tips teknologi.', 10000, 3.8, 'Tech', 'Gadget', 700000, 600000, 900000, 'https://instagram.com/dedi.tech', NULL, 'https://youtube.com/deditech', NULL, 4.7, 10, 'available'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '55555555-5555-5555-5555-555555555555', 'eka.foodie', 'Food & recipe creator. Suka review kuliner lokal.', 15000, 4.2, 'Food', 'Recipe', 350000, 300000, 500000, 'https://instagram.com/eka.foodie', 'https://tiktok.com/@eka.foodie', NULL, NULL, 4.5, 18, 'available');

-- ORDERS
INSERT INTO orders (id, influencer_id, sme_id, title, description, campign_type, order_status, total_price)
VALUES
('10101010-1010-1010-1010-101010101010','aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','66666666-6666-6666-6666-666666666666','Promo Paket Liburan','Promosi paket liburan 3 hari 2 malam; 1 post + 3 story','post', 'pending', 3000000.00),
('20202020-2020-2020-2020-202020202020','bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','66666666-6666-6666-6666-666666666666','Peluncuran Produk Fitness','1 video review + 2 post untuk peluncuran produk baru','video','accepted', 4500000.00),
('30303030-3030-3030-3030-303030303030','cccccccc-cccc-cccc-cccc-cccccccccccc','66666666-6666-6666-6666-666666666666','Kolaborasi Skincare','Campaign edukasi skincare; 2 post + 4 story','package','inprogress', 7000000.00),
('40404040-4040-4040-4040-404040404040','dddddddd-dddd-dddd-dddd-dddddddddddd','66666666-6666-6666-6666-666666666666','Review Gadget Baru','1 post + 1 video unboxing','post','completed', 2100000.00),
('50505050-5050-5050-5050-505050505050','eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee','66666666-6666-6666-6666-666666666666','Konten Kuliner Musiman','3 story + 1 post untuk menu musiman','story','cancelled', 900000.00);

-- REVIEWS
INSERT INTO reviews (id, order_id, rating, comment, review_type, is_public)
VALUES
('f1f1f1f1-f1f1-f1f1-f1f1-f1f1f1f1f1f1','10101010-1010-1010-1010-101010101010',5,'Konten sesuai brief, engagement bagus.','sme_to_influencer',TRUE),
('f2f2f2f2-f2f2-f2f2-f2f2-f2f2f2f2f2f2','20202020-2020-2020-2020-202020202020',4,'Video berkualitas, ada beberapa revisi kecil.','sme_to_influencer',TRUE),
('f3f3f3f3-f3f3-f3f3-f3f3-f3f3f3f3f3f3','30303030-3030-3030-3030-303030303030',5,'Kolaborasi lancar dan tepat waktu.','sme_to_influencer',TRUE),
('f4f4f4f4-f4f4-f4f4-f4f4-f4f4f4f4f4f4','40404040-4040-4040-4040-404040404040',5,'Unboxing sangat informatif, audiens tertarik.','sme_to_influencer',TRUE),
('f5f5f5f5-f5f5-f5f5-f5f5-f5f5f5f5f5f5','50505050-5050-5050-5050-505050505050',2,'Pembatalan mendadak; komunikasi perlu diperbaiki.','sme_to_influencer',FALSE);

-- INSERT INTO users (id, name, email, password, user_type)
-- VALUES
--   ('11111111-1111-1111-1111-111111111111', 'Alya Influencer', 'alya@mail.com', '$2b$12$KIXQjZrQxYkV9hXQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8u', 'influencer'), -- password hash for "password123"
--   ('22222222-2222-2222-2222-222222222222', 'Bima Fit', 'bima@mail.com', '$2b$12$KIXQjZrQxYkV9hXQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8u', 'influencer'), -- password hash for "password123"
--   ('33333333-3333-3333-3333-333333333333', 'Citra Beauty', 'citra@mail.com', '$2b$12$KIXQjZrQxYkV9hXQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8u', 'influencer'), -- password hash for "password123"
--   ('44444444-4444-4444-4444-444444444444', 'Dedi Tech', 'dedi@mail.com', '$2b$12$KIXQjZrQxYkV9hXQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8u', 'influencer'), -- password hash for "password123"
--   ('55555555-5555-5555-5555-555555555555', 'Eka Foodie', 'eka@mail.com', '$2b$12$KIXQjZrQxYkV9hXQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8uFZkQ7hZQ8u', 'influencer'); -- password hash for "password123"

-- INSERT INTO influencers (id, user_id, username, bio, niche, price_per_post)
-- VALUES
--   ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'alya.influencer', 'Lifestyle & travel content', 'Lifestyle', 500000),
--   ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '22222222-2222-2222-2222-222222222222', 'bima.fit', 'Fitness coach and health tips', 'Fitness', 400000),
--   ('cccccccc-cccc-cccc-cccc-cccccccccccc', '33333333-3333-3333-3333-333333333333', 'citra.beauty', 'Beauty reviews and tips', 'Beauty', 600000),
--   ('dddddddd-dddd-dddd-dddd-dddddddddddd', '44444444-4444-4444-4444-444444444444', 'dedi.tech', 'Gadget reviewer and tech news', 'Tech', 700000),
--   ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '55555555-5555-5555-5555-555555555555', 'eka.foodie', 'Food & recipe creator', 'Food', 350000);

-- -- 5 Orders (each references an influencer and a sme_id from users above)
-- INSERT INTO orders (id, influencer_id, sme_id, title, description, campign_type, order_status, total_price)
-- VALUES
-- ('10101010-1010-1010-1010-101010101010','aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','22222222-2222-2222-2222-222222222222','Promo Paket Liburan','Promosi paket liburan 3 hari 2 malam; 1 post + 3 story','post', 'pending', 3000000.00),
-- ('20202020-2020-2020-2020-202020202020','bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','33333333-3333-3333-3333-333333333333','Peluncuran Produk Fitness','1 video review + 2 post untuk peluncuran produk baru','video','accepted', 4500000.00),
-- ('30303030-3030-3030-3030-303030303030','cccccccc-cccc-cccc-cccc-cccccccccccc','11111111-1111-1111-1111-111111111111','Kolaborasi Skincare','Campaign edukasi skincare; 2 post + 4 story','package','inprogress', 7000000.00),
-- ('40404040-4040-4040-4040-404040404040','dddddddd-dddd-dddd-dddd-dddddddddddd','55555555-5555-5555-5555-555555555555','Review Gadget Baru','1 post + 1 video unboxing','post','completed', 2100000.00),
-- ('50505050-5050-5050-5050-505050505050','eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee','44444444-4444-4444-4444-444444444444','Konten Kuliner Musiman','3 story + 1 post untuk menu musiman','story','cancelled', 900000.00);

-- -- 5 Reviews (each references an order)
-- INSERT INTO reviews (id, order_id, rating, comment, review_type, is_public)
-- VALUES
-- ('f1f1f1f1-f1f1-f1f1-f1f1-f1f1f1f1f1f1','10101010-1010-1010-1010-101010101010',5,'Konten sesuai brief, engagement bagus.','sme_to_influencer',TRUE),
-- ('f2f2f2f2-f2f2-f2f2-f2f2-f2f2f2f2f2f2','20202020-2020-2020-2020-202020202020',4,'Video berkualitas, ada beberapa revisi kecil.','sme_to_influencer',TRUE),
-- ('f3f3f3f3-f3f3-f3f3-f3f3-f3f3f3f3f3f3','30303030-3030-3030-3030-303030303030',5,'Kolaborasi lancar dan tepat waktu.','sme_to_influencer',TRUE),
-- ('f4f4f4f4-f4f4-f4f4-f4f4-f4f4f4f4f4f4','40404040-4040-4040-4040-404040404040',5,'Unboxing sangat informatif, audiens tertarik.','sme_to_influencer',TRUE),
-- ('f5f5f5f5-f5f5-f5f5-f5f5-f5f5f5f5f5f5','50505050-5050-5050-5050-505050505050',2,'Pembatalan mendadak; komunikasi perlu diperbaiki.','sme_to_influencer',FALSE);
