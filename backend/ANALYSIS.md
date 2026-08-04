# Flow App — Backend & Integration Gap Analysis

Date: 2026-08-04
Status: Current baseline for the phase-1–10 implementation roadmap.

---

## 1. Backend inventory

### Stack
FastAPI + SQLAlchemy 2.0 + PyMySQL + MySQL 9.x (source layout: `src/flow_app/`).
Config via `FLOW_*` env vars (`backend/src/flow_app/config.py`). DB schema + seed
lives in `backend/db/schema.sql` / `seed.sql` (applied via `python -m flow_app.utils.seed_db`).

### Authentication model
There are **no auth tokens or sessions**. Every request resolves the acting user to
`settings.current_user_id` (default `user_001`) unless the route overrides it.
Auth endpoints are nominally present but password/OTP are not enforced
(`/auth/otp/verify` accepts hardcoded `123456`). This is by design for now; keep
`user_001` impersonation, real auth is out of scope.

### Tables (`db/schema.sql`, mirrored by ORM in `models/__init__.py`)

| Table | Purpose | Key columns |
|-------|---------|-------------|
| `flow_users` | Users/profiles | id, name, email, phone, avatar_url, is_verified, location, rating, reviews_count, listings_count, sales_count, bio, member_duration, positive_percent |
| `flow_user_follows` | Follow graph | (follower_id, followee_id) PK |
| `flow_categories` | Categories | id, name, icon, count |
| `flow_listings` | Products | seller_id FK, title, description, price, currency, images JSON, category, subcategory, status, is_featured, view_count, favorite_count, item_condition, location |
| `flow_favorites` | Wishlist | (user_id, listing_id) PK |
| `flow_orders` | Orders | buyer_id, seller_id, listing_id FKs, listing_title/image snapshot, price, currency, status, shipping_address, payment_method, is_paid, quantity |
| `flow_conversations` | Chats | (user_a_id, user_b_id) unique, last_message, unread_count, is_online, product_title/image |
| `flow_messages` | Messages | conversation_id, sender_id, text, image_url, is_read |
| `flow_reviews` | Seller reviews | seller_id, reviewer_id, user_name, user_avatar, rating, text, has_photo, photo_url |
| `flow_notifications` | Notifications | user_id, title, body, type, is_read, data JSON |

### Routers & endpoints

**auth** (`routers/auth.py`)
- `GET  /auth/me`
- `POST /auth/login` (email + password, password not checked)
- `POST /auth/register`
- `POST /auth/logout`
- `POST /auth/otp/send` / `POST /auth/otp/verify` (hardcoded OTP `123456`)
- `POST /auth/reset-password`

**listings** (`routers/listings.py`)
- `GET    /listings?page&limit&category&sortBy` — active listings only, **no sellerId filter**
- `GET    /listings/search?q&page&limit`
- `GET    /listings/{id}`
- `POST   /listings` (create)
- `PUT    /listings/{id}` (update; can change status)
- `DELETE /listings/{id}`
- `POST   /listings/{id}/favorite` (toggle; returns `{favorited, favoriteCount}`)

**categories** (`routers/categories.py`)
- `GET /categories`

**profiles** (`routers/profiles.py`)
- `GET /profile`, `PUT /profile`
- `GET /sellers/{id}` (serialized via `serialize_seller`)
- `POST /sellers/{id}/follow`, `DELETE /sellers/{id}/follow`
- `GET /sellers/{id}/reviews?page&limit` — returns **plain list** (no pagination envelope)

**orders** (`routers/orders.py`)
- `GET  /orders?page&limit&status` — buyer = current user
- `GET  /orders/{id}`
- `POST /orders/{id}/cancel`
- `GET  /orders/{id}/track`
- ❌ **No order creation (`POST /orders`)**

**messages** (`routers/messages.py`)
- `GET  /conversations` — plain list
- `GET  /conversations/{id}/messages?limit&before`
- `POST /conversations/{id}/messages`
- `POST /conversations/{id}/read`
- `GET  /conversations/unread-count`
- ❌ **No conversation creation (`POST /conversations`)**

**notifications** (`routers/notifications.py`)
- `GET  /notifications?page&limit` — pagination envelope
- `POST /notifications/{id}/read`
- `POST /notifications/read-all`
- `GET  /notifications/unread-count`
- ❌ **No emit/trigger helper** — notifications must be created manually in seed

### Serializer contract
`api/serializers.py` produces camelCase keys matching the Dart freezed models:
- `user_payload` (core/services.py): id, name, email, phone, avatarUrl, isVerified, location, rating, reviewsCount, listingsCount, salesCount, followers, following, isFollowing, listingIds, wishlistIds
- `serialize_listing`: id, sellerId, title, description, price, currency, images, category, subcategory, status, createdAt, isFeatured, viewCount, favoriteCount, favoriteBy, condition, location
- `pagination()`: `{items, page, totalPages, totalItems, hasMore}`
- Order/conversation/message/notification/review/seller/category serializers mirror the Dart models exactly.

### Tests
Only 2 smoke tests in `backend/tests/test_main.py` (app metadata + health). No endpoint coverage.

### Image upload
**None.** Listing/avatar `images` are URL strings in JSON. There is no multipart endpoint
and no static file serving.

---

## 2. Frontend wiring status

- `lib/core/network/api_config.dart`: `useRemoteBackend = true` — the Flutter app calls
  this backend for all repositories.
- Remote repositories exist for auth, listing, profile, order, messaging, notification.
- Screens wired to remote data:
  Home, Explore, ProductDetails, SellerProfile (data), Profile, EditProfile, Orders,
  OrderDetails, TrackOrder, Messages, Conversation.

### Unwired / broken screens

| Screen | Problem |
|--------|---------|
| **NotificationsScreen** | 100% hardcoded `_NotificationData`. "MARK ALL READ" only shows a SnackBar. `notificationProvider` (`lib/features/notifications/`) exists but is never imported. |
| **CreateListingScreen** | UI only. No title/price/description/category state, DRAFTS button empty, "Continue" hardcodes `id: 'new'`. `listingProvider.createListing()` unused. |
| **MyListingsScreen** | Backed by `profileProvider.getMyListings()` which is a **stub returning `[]`**. `archiveListing`/`markAsSold`/`deleteListing` mutate local state only, never call the repo. |
| **SavedScreen** | `profileProvider.getWishlist()` is a **stub returning `[]`** — wishlist always empty despite `flow_favorites` seed rows. |
| Static/navigation-only | `search_results`, `image_gallery`, `product_reviews`, `invoice`, `delivery_timeline`, `offer_negotiation`, `upload_images`, `listing_preview`. |

### Provider stubs that block features
- `ProfileNotifier.getMyListings()` / `getWishlist()` — return `AsyncValue.data([])` after a delay.
- `ProfileNotifier.archiveListing` / `markAsSold` / `deleteListing` — in-memory only.
- `ListingNotifier.toggleFavorite` — calls repo, but `SavedScreen` removal uses `profileProvider.removeFromWishlist` (local only).

---

## 3. Gap analysis

### Backend-side gaps
| # | Gap | Impact | Fix |
|---|-----|--------|-----|
| G1 | No `sellerId` filter on `GET /listings`; no "my listings" endpoint | MyListingsScreen can't load owned listings | Add `sellerId` param + `GET /users/me/listings` |
| G2 | No wishlist endpoint | SavedScreen wishlist always empty | Add `GET /wishlist` resolving `flow_favorites` → full listings |
| G3 | No `POST /orders` | No buy/checkout flow | Add order creation (buy flow) |
| G4 | No `POST /conversations` | Can't start a chat from a product/seller | Add conversation creation (dedupe via `uq_conv_pair`) |
| G5 | No `POST /sellers/{id}/reviews` | Can't leave a review | Add review creation + seller rating recompute |
| G6 | No notification emit helper | Notifications only exist via seed | Add `create_notification()`; emit on order/message events |
| G7 | No image upload | CreateListing/avatar can't persist images | Multipart `POST /upload` + static serving |
| G8 | Login doesn't validate password; OTP hardcoded | Acceptable for mock, documented | Keep (out of scope) |
| G9 | Currency seed uses `NGN` for Mexican content | Cosmetic mismatch | Note only |

### Frontend-side gaps
| # | Gap | Fix |
|---|-----|-----|
| F1 | NotificationsScreen hardcoded | Rewire to `notificationProvider` |
| F2 | CreateListingScreen form not collectable | Add state, submit via `listingProvider.createListing()`, upload via `/upload` |
| F3 | getMyListings/getWishlist stubs | Implement via new endpoints |
| F4 | MyListings actions local-only | Wire to repo (PUT status / DELETE) |
| F5 | Buy flow missing | Add order creation in `orderProvider` + wire ProductDetails |
| F6 | Contact-seller navigation lacks real ids / no conversation start | Pass sellerId/orderId; start conversation via new endpoint |

---

## 4. Roadmap (phases)

Decisions: backend + frontend wiring in-scope; keep `user_001` impersonation; image
upload = multipart + static serving.

1. **Auth & Users** — keep impersonation; verify login/register consistency (no code change beyond hygiene).
2. **Categories** — complete; smoke-test only.
3. **Listings** — G1: `sellerId` filter + `/users/me/listings`; F2/F3/F4: wire CreateListing + MyListings.
4. **Wishlist** — G2: `/wishlist`; F3: wire SavedScreen.
5. **Orders** — G3: `POST /orders`; F5: buy flow.
6. **Messaging** — G4: `POST /conversations`; F6: contact-seller params.
7. **Notifications** — G6: emit helper; F1: rewire screen.
8. **Reviews** — G5: `POST /sellers/{id}/reviews`; wire ProductReviewsScreen.
9. **Image Upload** — G7: `/upload` + static serving; wire AppImagePicker flows.
10. **Tests & Polish** — backend pytest coverage; `flutter analyze`/`test` green.

---

## 5. Notes
- Response JSON keys must stay byte-for-byte aligned with the Dart freezed models
  (camelCase, ISO-8601 datetimes). Any new endpoint must reuse `api/serializers.py`.
- Reviews and conversations return plain lists (the Flutter repos parse arrays);
  listings/orders/notifications return the `pagination()` envelope. Keep this split.
- `favoriteBy` and `wishlistIds` must stay consistent when favorites are toggled.
