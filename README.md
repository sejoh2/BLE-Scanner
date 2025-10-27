# BLE - Connect

# 🛰️ Flutter BLE Smart Device Scanner

A clean, modern, and fully functional Flutter application that scans for nearby **Bluetooth Low Energy (BLE)** devices, displays them in a categorized list, and allows users to connect to and explore their Bluetooth services.

---

## 🚀 Getting Started

### 1️⃣ Requirements

Before running this app, ensure you have:

- Flutter SDK 3.0+

- Android Studio or Visual Studio Code

- An Android device with Bluetooth enabled

- Nearby BLE-enabled devices (e.g., Smartwatch, Earbuds, BLE Sensor)

> ⚠️ Note: BLE features require a physical device — emulators typically do not support Bluetooth.
> 

### 2️⃣ Clone the Repository

git clone https://github.com/sejoh2/BLE-Scanner.git
cd bleconnect


### 3️⃣ Install Dependencies
flutter pub get

### 4️⃣ Connect a Physical Device

- Connect your Android device to your computer using a USB cable.

- On your phone, go to: Settings → About phone → Tap “Build number” 7 times to enable Developer Mode.

- Go back to Settings → Developer options, then:

- Enable USB debugging.

- (Optional) Enable Wireless debugging if you prefer connecting via Wi-Fi.

- Verify connection:
 flutter devices

### 5️⃣ Run the Application
flutter run

- Your app will build and launch on the connected physical device.
- Make sure Bluetooth is turned ON, then start scanning for nearby BLE devices.

### 📱 App Overview

This project implements BLE scanning and device connection using the flutter_blue_plus
 package.
It displays all nearby BLE devices and allows users to connect, disconnect, and view their services and signal strength.

### 🧠 State Management — Why Provider?

- This project uses Provider for state management because it provides:

- A clean separation between UI and business logic

- Automatic UI updates when BLE scan results or connection state change

- Lightweight and scalable architecture for handling multiple BLE devices

#### Provider Usage

- BLEService — handles Bluetooth scanning, connection, and service discovery using flutter_blue_plus.

- BLEProvider — listens to BLEService, manages device list, and exposes scan/connect states to the UI.

- LandingPage and ConnectPage use context.watch<BLEProvider>() to update the UI reactively.
###💡 Tip: Run on a real Android phone for accurate Bluetooth scanning and connections.

### 🧩 Project Structure
lib/
-
── components/

      ── device_tile.dart 
        - Displays a BLE device with name, MAC address, and RSSI strength bars
   
      ── filter_tile.dart  
        - Filter chip UI for device categories (All, Audio, Smart Watches)
   
      ── my_button.dart 
        - Custom reusable button widget
   
      ── signal_strength_bar.dart
       - Visualizes signal strength (RSSI) using bar indicators

── services/

      ── ble_service.dart       
        - Core BLE logic: scanning, connecting, disconnecting, discovering services
        
      ── ble_provider.dart     
        - State management using Provider; exposes device list and connection state

── Pages/

     ── landing_page.dart         
       - Home screen: lists nearby devices, filter options, and scan controls
   
     ── connect_page.dart        
       - Connects to a selected BLE device, shows services and signal info

── main.dart                    
  - App entry point, initializes Provider, and defines routes
    

###🧩 Core Functionalities

- ✅ Continuous BLE Scanning — Scans for nearby BLE devices until user presses “Stop Scan”
- ✅ Device Filtering — Users can filter results by category: “All”, “Audio Devices”, “Smart Watches”
- ✅ Signal Strength Display — Shows real-time RSSI strength using signal bars
- ✅ Device Connection — Connect/disconnect from devices and explore services
= ✅ Responsive UI — Built with clean Material Design and dynamic updates

### 🧰 Key Code Files Explained
-🔹 device_tile.dart

- Displays a single Bluetooth device (icon, name, MAC address, and signal strength).

- Tapping navigates to ConnectPage.

#### 🔹 landing_page.dart

- Main screen showing all scanned BLE devices.

- Includes category filters and start/stop scan button.

- Integrates with BLEProvider for live updates.

#### 🔹 connect_page.dart

- Displays selected device details and connection status.

- Allows users to connect/disconnect and view available services.

- Uses a modern UI with progress indicators and error handling.

#### 🔹 ble_service.dart

- Wraps all Bluetooth operations:

- Start/stop scanning

- Manage connections

- Discover services

- Listen to Bluetooth adapter state

#### 🔹 ble_provider.dart

- Provides reactive state management via Provider.

- Tracks isScanning, isConnected, and the list of discovered devices.

### ⚙️ Challenges Faced

- BLE Device Names Not Displaying

- Many BLE peripherals don’t advertise a name field.

- The app gracefully falls back to showing the MAC address instead.

- Managing Bluetooth Permissions

- Android 12+ requires explicit permissions (BLUETOOTH_SCAN, BLUETOOTH_CONNECT, ACCESS_FINE_LOCATION).

- Tested and verified runtime permission requests.

- Limited Emulator Support

- BLE scanning cannot be tested on emulators — used nRF Connect app to verify BLE broadcasts.

### 🧠 Assumptions Made

- BLE is tested only on Android (iOS permissions differ).

- Scanning stops only when manually triggered.

- Unknown devices are still displayed with their MAC address and RSSI.

- Device filtering is based on name keywords (e.g., “watch”, “buds”).


### 🌟 Bonus Features Implemented

- ✅ Continuous scanning

- ✅ Signal strength visualization (RSSI bars)

- ✅ Device category filters

- ✅ Clean separation of logic and UI using Provider

- ✅ Modern, minimal UI with responsive updates

- ✅ Custom error handling with SnackBars


### 🧾 How to Test the App

- Install the app on a physical Android device.

- Turn on Bluetooth and allow location permissions.

- Press “Start Scan” — nearby BLE devices will appear.

- Tap any device to open the Connect Page.

- Press “Connect” to establish a BLE connection.

- View its services and signal strength.

- Press “Disconnect” to close the session.
