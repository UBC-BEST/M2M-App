# M2M Frontend

## 🚀 Getting Started

To run this application, **you must have the backend running** and complete the following setup steps:

---

### 📦 Step 1: Install Dependencies

Navigate to the frontend directory and install all dependencies:

```bash
cd frontend
flutter pub get
```

---

### ⚙️ Step 2: Create a `.env` File

Inside the `frontend` folder, copy `.env.example` to `.env` and update the values for your client environment:

```env
FLUTTER_APP_BASE_URL=
FLUTTER_APP_EXP_IP=your_computer_ip_or_localhost
FLUTTER_APP_EXP_PORT=6969
FLUTTER_APP_BLE_SERVICE_UUID=6e400001-b5a3-f393-e0a9-e50e24dcca9e
FLUTTER_APP_BLE_CHARACTERISTIC_UUID=6e400002-b5a3-f393-e0a9-e50e24dcca9e
FLUTTER_APP_ALLOW_GAME_LAUNCH_WITHOUT_SENSOR=false
```

`FLUTTER_APP_BASE_URL` is optional. If you leave it empty, the app will build the backend URL from `FLUTTER_APP_EXP_IP` and `FLUTTER_APP_EXP_PORT`.

#### 🧩 BLE Configuration

- `FLUTTER_APP_BLE_SERVICE_UUID`: The BLE service UUID advertised by the ESP32. The app uses this to find and verify the correct device during scanning and after connection.
- `FLUTTER_APP_BLE_CHARACTERISTIC_UUID`: The BLE characteristic UUID used for READ + NOTIFY to receive the 2-byte FSR ADC values.
- `FLUTTER_APP_ALLOW_GAME_LAUNCH_WITHOUT_SENSOR`: Set to `true` for local development to launch Unity games without BLE sensor connection and calibration preset checks.

#### 🔍 How to find your IP address:

| Platform    | Command                  |
| ----------- | ------------------------ |
| **Mac**     | `ipconfig getifaddr en0` |
| **Windows** | `ipconfig`               |

> ⚠️ **Note:** Use your **local IP address** (not `localhost`) when testing on mobile devices.
> IPs may change if your computer reconnects to Wi-Fi, unless your router assigns a static IP.

If you’re testing in a **web browser (Chrome)**, you can simply use:

```env
FLUTTER_APP_EXP_IP=localhost
```

---

### 🧠 Step 3: Backend Setup

Make sure to follow [@thebitspud](https://github.com/thebitspud)'s **README** to set up and run the backend correctly.

Both frontend and backend must run in sync.

---

### 📬 Questions?

For help running the frontend of the app, contact [@jnhan](https://github.com/jn-han) on discord.
