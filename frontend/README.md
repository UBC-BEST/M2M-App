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

Inside the `frontend` folder, create a `.env` file with the following content:

```env
FLUTTER_APP_EXP_IP=your_computer_ip_or_localhost
FLUTTER_APP_EXP_PORT=6969
```

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
