-- Flow App seed data
-- Ported from Mock*Repository classes (lib/features/*/data/repositories)

-- Users
INSERT INTO users (id, name, email, phone, avatar_url, is_verified, location, rating, reviews_count, listings_count, sales_count, bio, member_duration, positive_percent, created_at) VALUES
('user_001', 'Carlos Mendoza', 'carlos@example.com', '+52 55 1234 5678', '', TRUE, 'Ciudad de Mexico, Mexico', 4.9, 3, 12, 48, '', '', 0.00, NOW() - INTERVAL 2 YEAR),
('user_002', 'Maria Lopez',    'maria@example.com',    '+52 33 1111 2222', '', TRUE,  'Guadalajara, Mexico',      4.8, 3, 24, 95,  'Vendedor profesional de electrónicos. Envío a todo el país.', '2 years', 98.50, NOW() - INTERVAL 2 YEAR),
('user_003', 'Juan Perez',     'juan@example.com',     '+52 81 3333 4444', '', FALSE, 'Monterrey, Mexico',        4.2, 1, 15, 32,  'Ropa y calzado deportivo de marca.',                          '1 year',  92.00, NOW() - INTERVAL 1 YEAR),
('user_004', 'Ana Garcia',     'ana@example.com',      '+52 22 5555 6666', '', TRUE,  'Puebla, Mexico',           4.9, 2, 32, 128, 'Apple products specialist. Certified reseller.',               '3 years', 99.20, NOW() - INTERVAL 3 YEAR),
('user_005', 'Pedro Sanchez',  'pedro@example.com',    '+52 44 7777 8888', '', FALSE, 'Puebla, Mexico',           4.5, 0, 8,  21,  'Muebles y hogar.',                                             '8 months', 95.00, NOW() - INTERVAL 8 MONTH),
('user_006', 'Laura Torres',   'laura@example.com',    '+52 44 9999 0000', '', FALSE, 'Queretaro, Mexico',        4.6, 0, 5,  15,  'Deportes y aire libre.',                                       '1 year',  94.00, NOW() - INTERVAL 1 YEAR);

-- Follows (user_001 follows user_005, user_006; followers are user_002/003/004)
INSERT INTO user_follows (follower_id, followee_id) VALUES
('user_001', 'user_005'),
('user_001', 'user_006'),
('user_002', 'user_001'),
('user_003', 'user_001'),
('user_004', 'user_001');

-- Categories
INSERT INTO categories (id, name, icon, count) VALUES
('cat_01', 'Electronics', 'phone', 124),
('cat_02', 'Fashion',    'fashion', 89),
('cat_03', 'Home',       'home',   56),
('cat_04', 'Sports',     'sports', 34),
('cat_05', 'Vehicles',   'car',    21),
('cat_06', 'Toys',       'toys',   18);

-- Listings
INSERT INTO listings (id, seller_id, title, description, price, currency, images, category, subcategory, status, created_at, is_featured, view_count, favorite_count, item_condition, location) VALUES
('list_001', 'user_002', 'iPhone 15 Pro Max 256GB', 'Como nuevo, con caja y accesorios originales. Bateria al 98%.', 18500.00, 'NGN', JSON_ARRAY(), 'Electronics', '', 'active', NOW() - INTERVAL 3 HOUR, FALSE, 234, 18, 'Like new', 'Ciudad de Mexico'),
('list_002', 'user_003', 'Nike Air Max 90 Talla 10', 'Zapatos deportivos en excelente estado, usados solo dos veces.', 1800.00, 'NGN', JSON_ARRAY(), 'Fashion', '', 'active', NOW() - INTERVAL 1 DAY, FALSE, 89, 7, 'Used', 'Guadalajara'),
('list_003', 'user_004', 'MacBook Air M2 13"', '16GB RAM, 512GB SSD. Perfecto estado, con cargador original.', 21000.00, 'NGN', JSON_ARRAY(), 'Electronics', '', 'active', NOW() - INTERVAL 3 DAY, TRUE, 412, 45, 'Like new', 'Monterrey'),
('list_004', 'user_005', 'Sofa 3 Plazas Color Gris', 'Sofa moderno en tela premium, muy cómodo y sin manchas.', 5500.00, 'NGN', JSON_ARRAY(), 'Home', '', 'active', NOW() - INTERVAL 5 DAY, FALSE, 67, 4, 'Used', 'Puebla'),
('list_005', 'user_006', 'Bicicleta de Montaña Trek', '21 velocidades, suspension delantera. Ideal para senderismo.', 4200.00, 'NGN', JSON_ARRAY(), 'Sports', '', 'active', NOW() - INTERVAL 2 DAY, FALSE, 156, 12, 'Used', 'Queretaro'),
('list_010', 'user_001', 'PlayStation 5 + 2 Mandos', 'Consola en perfecto estado con dos mandos DualSense.', 8500.00, 'NGN', JSON_ARRAY(), 'Electronics', '', 'active', NOW() - INTERVAL 10 DAY, FALSE, 189, 14, 'Like new', 'Ciudad de Mexico');

-- Favorites (wishlist: user_001 -> list_020)
INSERT INTO favorites (user_id, listing_id) VALUES
('user_001', 'list_001'),
('user_001', 'list_003');

-- Orders
INSERT INTO orders (id, buyer_id, seller_id, listing_id, listing_title, listing_image, price, currency, status, created_at, shipping_address, payment_method, is_paid, quantity) VALUES
('ord_001', 'user_001', 'user_002', 'list_001', 'iPhone 15 Pro Max 256GB', '', 18500.00, 'NGN', 'shipped',   NOW() - INTERVAL 2 DAY,   'Av. Reforma 123, Ciudad de Mexico', '', TRUE,  1),
('ord_002', 'user_001', 'user_004', 'list_003', 'MacBook Air M2 13"',     '', 21000.00, 'NGN', 'delivered', NOW() - INTERVAL 7 DAY,   'Calle Independencia 456, Monterrey',  '', TRUE,  1),
('ord_003', 'user_001', 'user_003', 'list_002', 'Nike Air Max 90 Talla 10', '', 1800.00, 'NGN', 'pending',   NOW() - INTERVAL 6 HOUR,  'Blvd. Vallarta 789, Guadalajara',     '', FALSE, 1),
('ord_004', 'user_001', 'user_005', 'list_004', 'Sofa 3 Plazas Color Gris', '', 5500.00, 'NGN', 'confirmed', NOW() - INTERVAL 12 HOUR, 'Calle 5 de Mayo 101, Puebla',         '', TRUE,  1),
('ord_005', 'user_001', 'user_006', 'list_005', 'Bicicleta de Montaña Trek', '', 4200.00, 'NGN', 'cancelled', NOW() - INTERVAL 10 DAY,  'Av. Universidad 202, Queretaro',      '', FALSE, 1);

-- Conversations (user_001 is user_a)
INSERT INTO conversations (id, user_a_id, user_b_id, last_message, last_message_time, unread_count, is_online, product_title, product_image, created_at) VALUES
('conv_001', 'user_001', 'user_002', 'Si, esta disponible. Te lo puedo enviar manana.', NOW() - INTERVAL 15 MINUTE, 2, TRUE,  'iPhone 15 Pro Max 256GB', '', NOW() - INTERVAL 1 DAY),
('conv_002', 'user_001', 'user_003', 'Gracias por la compra!',                         NOW() - INTERVAL 2 HOUR,   0, FALSE, 'Nike Air Max 90 Talla 10', '', NOW() - INTERVAL 2 DAY),
('conv_003', 'user_001', 'user_004', 'Tiene algun descuento?',                         NOW() - INTERVAL 1 DAY,    1, TRUE,  'MacBook Air M2 13"',       '', NOW() - INTERVAL 1 DAY);

-- Messages
INSERT INTO messages (id, conversation_id, sender_id, text, image_url, timestamp, is_read) VALUES
('msg_001', 'conv_001', 'user_001', 'Hola, esta disponible el iPhone?', '', NOW() - INTERVAL 1 HOUR, TRUE),
('msg_002', 'conv_001', 'user_002', 'Si, esta disponible.', '', NOW() - INTERVAL 45 MINUTE, TRUE),
('msg_003', 'conv_001', 'user_001', 'Cual es el precio final?', '', NOW() - INTERVAL 30 MINUTE, TRUE),
('msg_004', 'conv_001', 'user_002', 'Si, esta disponible. Te lo puedo enviar manana.', '', NOW() - INTERVAL 15 MINUTE, FALSE),
('msg_005', 'conv_002', 'user_001', 'Recibi los zapatos, gracias!', '', NOW() - INTERVAL 3 HOUR, TRUE),
('msg_006', 'conv_002', 'user_003', 'Gracias por la compra!', '', NOW() - INTERVAL 2 HOUR, TRUE),
('msg_007', 'conv_003', 'user_001', 'Buenas tardes, me interesa el MacBook.', '', NOW() - INTERVAL 1 DAY + INTERVAL 1 HOUR, TRUE),
('msg_008', 'conv_003', 'user_004', 'Hola! Si esta disponible.', '', NOW() - INTERVAL 1 DAY, TRUE),
('msg_009', 'conv_003', 'user_001', 'Tiene algun descuento?', '', NOW() - INTERVAL 23 HOUR, FALSE);

-- Reviews
INSERT INTO reviews (id, seller_id, reviewer_id, user_name, user_avatar, rating, date, text, has_photo, photo_url) VALUES
('rev_001', 'user_002', 'user_001', 'Carlos Mendoza', '', 5, NOW() - INTERVAL 5 DAY,  'Excelente vendedor! El producto llego en perfecto estado y muy rapido.', FALSE, ''),
('rev_002', 'user_002', NULL,       'Laura Sanchez',  '', 5, NOW() - INTERVAL 15 DAY, 'Muy profesional. Recomendado 100%.', TRUE, ''),
('rev_003', 'user_002', NULL,       'Roberto Diaz',   '', 4, NOW() - INTERVAL 30 DAY, 'Buen producto, demoro un poco el envio pero todo bien.', FALSE, ''),
('rev_004', 'user_003', NULL,       'Pedro Ramirez',  '', 4, NOW() - INTERVAL 10 DAY, 'Buena calidad, tal como se veia en las fotos.', FALSE, ''),
('rev_005', 'user_004', NULL,       'Sofia Torres',   '', 5, NOW() - INTERVAL 3 DAY,  'MacBook en perfecto estado. Envio super rapido.', FALSE, ''),
('rev_006', 'user_004', NULL,       'Miguel Angel',   '', 5, NOW() - INTERVAL 8 DAY,  'Excelente vendedor, muy confiable.', FALSE, '');

-- Notifications (user_001)
INSERT INTO notifications (id, user_id, title, body, type, is_read, created_at, data) VALUES
('notif_001', 'user_001', 'Order Shipped', 'Your order #FLW-001 has been shipped.', 'order', FALSE, NOW() - INTERVAL 30 MINUTE, JSON_OBJECT('orderId', 'ord_001')),
('notif_002', 'user_001', 'New Message', 'Maria Lopez sent you a message.', 'message', FALSE, NOW() - INTERVAL 2 HOUR, JSON_OBJECT('conversationId', 'conv_001')),
('notif_003', 'user_001', 'Payment Received', 'Payment of $18,500 confirmed for order #FLW-001.', 'order', TRUE, NOW() - INTERVAL 6 HOUR, JSON_OBJECT('orderId', 'ord_001')),
('notif_004', 'user_001', 'Weekend Sale', 'Up to 40% off on electronics. Don''t miss out!', 'promotion', TRUE, NOW() - INTERVAL 1 DAY, NULL),
('notif_005', 'user_001', 'Account Verified', 'Your account has been successfully verified.', 'system', TRUE, NOW() - INTERVAL 2 DAY, NULL),
('notif_006', 'user_001', 'New Message', 'Ana Garcia sent you a message.', 'message', FALSE, NOW() - INTERVAL 5 HOUR, JSON_OBJECT('conversationId', 'conv_003'));
