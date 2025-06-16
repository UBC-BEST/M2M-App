# Muscle to Movement Flutter Application

## In order to run this application, you must be running the backend, and you must have set up the application with the following steps:

### 1. Ensure that you have all your dependencies by navigating into the frontend `/frontend` and running `flutter pub get`

### 2. Create a .env file that has _two variables_:

```
FLUTTER_APP_EXP_IP={Your Computers IP Address OR localhost}
FLUTTER_APP_EXP_PORT=6969
```

Depending on what type of application you are running, you will need to use your computers IP address (this could change everytime you disconnect and reconnect your wifi),
depending on if your modem can lock your IP address.

**If you are trying to run android or mobile, then retrieve your IP address with:**

Mac Terminal: `ipconfig getifaddr en0`
Windows Command Prompt: `ipconfig`

**If you are trying to run the regular chrome browser, you can just use the value `localhost` for your `FLUTTER_APP_EXP_IP`**

### 3. Ensure that you read @thebitspud's README file on the backend in order to get the backend setup
