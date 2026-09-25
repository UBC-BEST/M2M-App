# M2M App — Muscle to Movement

Mobile rehabilitation and training application developed by [UBC BEST](https://github.com/UBC-BEST). The app connects to a custom **ESP32 + FSR (Force Sensitive Resistor)** sensor over Bluetooth Low Energy (BLE), streams live pressure data, and is designed to drive gamified exercises and progress tracking.

This document is the **project handoff guide** for the next development team. It explains what exists today, how the pieces fit together, and where to pick up work.

---

## Table of Contents

- [What This Project Does](#what-this-project-does)
- [Repository Structure](#repository-structure)
- [Tech Stack](#tech-stack)
- [Architecture Overview](#architecture-overview)
- [Quick Start](#quick-start)
- [Frontend (Flutter)](#frontend-flutter)
- [Backend (Node / Express)](#backend-node--express)
- [Hardware & BLE Integration](#hardware--ble-integration)
- [Authentication](#authentication)
- [Branching & Git Workflow](#branching--git-workflow)
- [Current Status & Known Gaps](#current-status--known-gaps)
- [Suggested Next Steps](#suggested-next-steps)
- [Additional Documentation](#additional-documentation)
- [Contacts](#contacts)

---

## What This Project Does

M2M is a patient-facing mobile app for muscle rehabilitation. The high-level vision:

1. **Sense** — An FSR on a wearable/controller measures grip or muscle force.
2. **Stream** — An ESP32 reads the sensor and sends ADC values over BLE to the phone.
3. **Visualize** — The app displays live pressure readings and historical stats.
4. **Gamify** — Unity-based mini-games (planned) use force input as a controller mechanism.
5. **Track** — User accounts, sessions, and progress are stored server-side.

The **`staging`** branch is the current integration branch and default on GitHub.

---

## Repository Structure

```
M2M-App/
├── backend/          # Node.js + Express REST API (TypeScript)
│   ├── src/
│   │   ├── app.ts              # Server entry point
│   │   ├── routes/
│   │   │   ├── auth/           # login, register, logout, refresh
│   │   │   └── account/        # get/modify account info
│   │   ├── utils/              # database, tokens, env, errors
│   │   └── types/              # MongoDB document & JWT types
│   └── tests/                  # Jest + Supertest integration tests
│
├── frontend/         # Flutter mobile app (Dart)
│   ├── lib/
│   │   ├── app/                # App shell, startup/bootstrap logic
│   │   ├── core/               # Config, BLE services, session storage
│   │   ├── features/           # Feature modules (auth, home, games, stats, settings)
│   │   ├── l10n/               # Localization (English)
│   │   └── main.dart           # Entry point
│   ├── android/ ios/ macos/ linux/ windows/ web/   # Platform runners
│   └── pubspec.yaml
│
└── README.md         # This file
```

Each sub-project also has its own README with detailed setup instructions:

- [`backend/README.md`](backend/README.md)
- [`frontend/README.md`](frontend/README.md)

---

## Tech Stack

| Layer | Technologies |
|-------|-------------|
| **Mobile app** | Flutter 3.5+, Dart, Material 3 |
| **Backend** | Node.js, Express, TypeScript, ESBuild |
| **Database** | MongoDB (Atlas or local) |
| **Auth** | JWT access tokens + HTTP-only refresh token cookies |
| **Password hashing** | Argon2 |
| **BLE** | `flutter_blue_plus`, ESP32 Nordic UART-style UUIDs |
| **Charts** | `fl_chart` |
| **Testing (backend)** | Jest, Supertest |
| **Games (planned)** | Unity via `flutter_unity_widget` (currently disabled) |

---

## Architecture Overview

```
┌─────────────────┐       BLE (FSR ADC)        ┌──────────────┐
│  ESP32 + FSR    │ ─────────────────────────► │ Flutter App  │
│  Sensor Device  │   2-byte notify values     │  (frontend)  │
└─────────────────┘                            └──────┬───────┘
                                                      │ HTTP REST
                                                      ▼
                                               ┌──────────────┐
                                               │ Express API  │
                                               │  (backend)   │
                                               └──────┬───────┘
                                                      │
                                                      ▼
                                               ┌──────────────┐
                                               │   MongoDB    │
                                               │ users, tokens│
                                               └──────────────┘
```

### App navigation (logged-in state)

The main shell uses a bottom `NavigationBar` with four tabs:

| Tab | Screen | Purpose |
|-----|--------|---------|
| **Home** | `HomePage` | Recommended exercises, daily warmup cards (UI mockups) |
| **Games** | `GamesPage` | Horizontal game list (placeholder — no Unity launch yet) |
| **Data** | `StatsPage` | Live FSR pressure bar + charts |
| **Settings** | `SettingsPage` | Account, appearance, notifications, BLE device pairing |

On first launch, users see an **onboarding flow**, then **login/signup**. Session state is determined at startup by `AppBootstrapper`.

---

## Quick Start

You need **both** the backend and frontend running to test the full app.

### 1. Clone the repo

```bash
git clone https://github.com/UBC-BEST/M2M-App.git
cd M2M-App
git checkout staging
```

### 2. Start the backend

See [`backend/README.md`](backend/README.md) for full details. Summary:

```bash
cd backend
yarn
# Create backend/.env (see backend README for template)
yarn dev
```

The server runs at `http://localhost:6969` by default (configure via `.env`).

### 3. Start the frontend

See [`frontend/README.md`](frontend/README.md) for full details. Summary:

```bash
cd frontend
flutter pub get
# Create frontend/.env (see below)
flutter run
```

**Frontend `.env` template** (create `frontend/.env`):

```env
FLUTTER_APP_BASE_URL=
FLUTTER_APP_EXP_IP=your_computer_ip_or_localhost
FLUTTER_APP_EXP_PORT=6969
FLUTTER_APP_BLE_SERVICE_UUID=6e400001-b5a3-f393-e0a9-e50e24dcca9e
FLUTTER_APP_BLE_CHARACTERISTIC_UUID=6e400002-b5a3-f393-e0a9-e50e24dcca9e
```

> **Mobile device testing:** Use your machine's **local network IP** (not `localhost`) so the phone can reach the backend. On Windows, run `ipconfig` to find it.

### 4. Verify

- Backend health: open `http://localhost:6969` — should return a connection success message.
- Backend tests (with server running): `cd backend && yarn test`
- App flow: register → login → navigate tabs → pair BLE device in Settings → view live FSR data on Data tab.

---

## Frontend (Flutter)

### Entry point & startup

- `lib/main.dart` — loads `.env`, bootstraps session state, launches `MyApp`.
- `lib/app/startup/app_bootstrapper.dart` — checks `SharedPreferences` for first-launch onboarding and stored access token.
- `lib/app/app.dart` — routes to onboarding, login, or main navigation shell.

### Feature module layout

Code is organized under `lib/features/` by domain:

```
features/
├── auth/           # Login, signup, AuthRepository (HTTP calls)
├── onboarding/     # First-launch intro slides + training selection
├── navigation/     # Bottom nav shell (IndexedStack)
├── home/           # Dashboard cards
├── games/          # Game list UI
├── stats/          # Charts + live FSR pressure display
├── settings/       # Account, BLE pairing, appearance, notifications
└── unity/          # Unity game launcher (fully commented out)
```

Shared infrastructure lives in `lib/core/`:

| File | Role |
|------|------|
| `config/app_config.dart` | Reads server URL and BLE UUIDs from `.env` |
| `services/bluetooth_sensor_service.dart` | Singleton BLE manager — scan, connect, stream FSR values |
| `services/bluetooth_device_manager.dart` | Persists selected BLE device to local storage |
| `services/session_manager.dart` | Access token + Face ID credential storage |
| `constants/storage_keys.dart` | SharedPreferences / secure storage key names |

### Key dependencies (`pubspec.yaml`)

- `flutter_blue_plus` — BLE scanning and GATT notifications
- `flutter_dotenv` — environment configuration
- `http` — REST calls to backend
- `flutter_secure_storage` + `shared_preferences` — token and settings persistence
- `local_auth` — Face ID / biometric login
- `fl_chart` — stats charts
- `permission_handler` — Android/iOS Bluetooth permissions

---

## Backend (Node / Express)

### API routes

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| `GET` | `/` | No | Health check |
| `POST` | `/auth/register` | No | Create account; returns access token + sets refresh cookie |
| `POST` | `/auth/login` | No | Login; returns access token + sets refresh cookie |
| `POST` | `/auth/logout` | Cookie | Revoke refresh token |
| `POST` | `/auth/refresh` | Cookie | Issue new access token from refresh cookie |
| `GET` | `/account/get` | Bearer | Fetch user profile |
| `POST` | `/account/modify` | Bearer | Update display name and/or email |

Protected routes expect: `Authorization: Bearer <accessToken>`

### Database collections (MongoDB)

| Collection | Purpose |
|------------|---------|
| `users` | `email`, `pwHash` (Argon2), `displayName`, `createdAt`, `verified` |
| `refreshTokens` | Long-lived session tokens tied to `userId` |

### Backend environment variables

Create `backend/.env`:

```env
HOST="http://localhost"
PORT=6969
MONGODB_CONNECTION_URI="mongodb+srv://..."
NODE_ENV="development"
DB_NAME="m2m"
ACCESS_TOKEN_SECRET="<random 32-byte hex>"
REFRESH_TOKEN_SECRET="<different random 32-byte hex>"
```

Generate secrets:

```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### Scripts

| Command | Description |
|---------|-------------|
| `yarn start` | Build with ESBuild and run production bundle |
| `yarn dev` | Nodemon — rebuilds and restarts on file changes |
| `yarn test` | Run Jest test suite (server must be running) |

---

## Hardware & BLE Integration

The app communicates with an **ESP32** that advertises a known BLE service and streams FSR readings.

### Default UUIDs (Nordic UART-style)

| Setting | UUID |
|---------|------|
| Service | `6e400001-b5a3-f393-e0a9-e50e24dcca9e` |
| Characteristic (notify) | `6e400002-b5a3-f393-e0a9-e50e24dcca9e` |

Override these in `frontend/.env` if your firmware uses different UUIDs.

### Data format

The characteristic sends **2-byte little-endian** ADC values (0–4095). The app:

1. Parses raw bytes: `value[0] | (value[1] << 8)`
2. Applies exponential smoothing (`alpha = 0.85`)
3. Converts to percentage: `(value / 4095) * 100`
4. Tracks a session max value (resettable from the Data tab)

### BLE workflow in the app

1. **Settings → Bluetooth Devices** — scan for devices advertising the configured service UUID.
2. Select a device — ID and name are saved locally via `BluetoothDeviceManager`.
3. **Data tab** — auto-connects to the saved device on open and displays live pressure.

Implementation: `lib/core/services/bluetooth_sensor_service.dart`

---

## Authentication

```
Register/Login → Backend returns { accessToken } + httpOnly refreshToken cookie
              → Frontend stores accessToken in SharedPreferences
              → Subsequent API calls send Authorization: Bearer <token>
```

- Access tokens expire after **15 minutes** (configurable via `ACCESS_TOKEN_EXPIRY`).
- Refresh tokens last **90 days** and are stored as HTTP-only cookies on `/auth/` paths.
- The Flutter app currently stores and uses the **access token only**. Token refresh from the client is **not yet implemented** — users will need to re-login after access token expiry unless you add a refresh flow.
- **Face ID / biometric login** is stored locally (`flutter_secure_storage`) and is not synced to the backend (see TODO in `settings_page.dart`).

---

## Branching & Git Workflow

| Branch | Notes |
|--------|-------|
| `staging` | **Default branch** — active integration point |
| `main` | Exists but is not the primary development branch |
| Feature branches | Named by contributor or feature, e.g. `feature/ble-settings`, `feature/fsr-integration`, `josh-ux` |

Recent work on `staging` includes:

- FSR sensor BLE integration (`feature/fsr-integration`)
- BLE device selection in Settings (`feature/ble-settings`)
- Feature-first frontend restructure (`feature-first`)

When starting new work, branch from `staging` and open PRs back into `staging`.

---

## Current Status & Known Gaps

Use this section to understand what is **done** vs. **placeholder**.

### Working today

- [x] User registration and login (frontend ↔ backend)
- [x] JWT access token auth on protected backend routes
- [x] Onboarding flow on first launch
- [x] Bottom navigation shell with four tabs
- [x] BLE device scanning, pairing, and persistence
- [x] Live FSR pressure streaming and display on Data tab
- [x] Settings UI (account, appearance, notifications, Bluetooth)
- [x] Face ID prompt after first successful login (local only)
- [x] Backend test suite for auth and account routes
- [x] Localization scaffold (English)

### UI exists but not fully wired

- [ ] **Account settings** — name, email, password screens use placeholder data; not connected to `/account/get` or `/account/modify`
- [ ] **Home page** — hardcoded username (`Jane`); recommended cards are static UI
- [ ] **Stats charts** — bar and line charts use **sample data**; only the FSR pressure bar uses live BLE data
- [ ] **Games page** — displays game names but `onTap` handlers are not set; no game launch
- [ ] **Controller calibration** — `controller_settings.dart` is an empty scaffold

### Not started / disabled

- [ ] **Unity game integration** — `unity_game_launch.dart` is entirely commented out; `frontend/ios/UnityLibrary` is gitignored
- [ ] **Session/exercise data persistence** — no backend endpoints for storing workout sessions, reps, or FSR history
- [ ] **Token refresh on frontend** — backend `/auth/refresh` exists but Flutter does not call it
- [ ] **Password change endpoint** — no backend route; UI exists only
- [ ] **Email verification** — `verified` field exists on user documents but is unused
- [ ] **Push notifications** — settings UI only

---

## Suggested Next Steps

Priority areas for the next team, in recommended order:

1. **Wire account settings to the backend** — fetch real user data via `GET /account/get`; call `POST /account/modify` from name/email change screens; add a password change endpoint.
2. **Persist session data** — design MongoDB schemas for exercise sessions and FSR time-series; add API routes; replace sample chart data with real history.
3. **Implement token refresh in Flutter** — call `/auth/refresh` before access token expiry to avoid forced re-logins.
4. **Connect FSR input to games** — re-enable Unity integration or build native Flutter games that read from `BluetoothSensorService.instance`.
5. **Replace hardcoded UI placeholders** — home page username, account settings subtitles, game cards with real assets and navigation.
6. **Add password change & email verification flows** on the backend.
7. **Production deployment** — containerize backend, set up CI/CD, configure production MongoDB and secrets management.

---

## Additional Documentation

| Resource | Location |
|----------|----------|
| Backend setup, style guide, file structure | [`backend/README.md`](backend/README.md) |
| Frontend setup, `.env` config, IP discovery | [`frontend/README.md`](frontend/README.md) |
| GitHub repository | [github.com/UBC-BEST/M2M-App](https://github.com/UBC-BEST/M2M-App) |

---

## Contacts

| Area | Contact |
|------|---------|
| Backend | James (@intonomist on Discord) |
| Frontend | [@jnhan](https://github.com/jn-han) on Discord |

---

## License

No license file is present in the repository. Confirm with UBC BEST leadership before external distribution or commercial use.
