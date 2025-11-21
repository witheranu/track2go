# Track2Go – Real-Time Bus Tracking & Digital Ticketing App (Flutter)

Track2Go is an android mobile application built using Flutter that enables passengers to view nearby buses in real time, book tickets digitally via UPI, and access minimal QR-based digital tickets.
Conductors can share live bus location and view all tickets booked for their assigned bus.

---

## Features

#Passenger App

* View Nearby Buses

  * Displays real-time location of buses based on conductor updates.
* 🎟️ **Online Ticket Booking (UPI)**

  * Book tickets with secure UPI payments.
  * Generates a **unique ticket ID** (e.g., `DN16/1/001`).
  * Tickets **auto-expire in 3 hours**.
* 🗺️ **Passenger Map Screen**

  * Shows bus route, conductor’s live location, and ticket booking options.

### **Conductor App**

* ▶️ **Start Journey**

  * Begins live location sharing using the conductor’s device.
* 📍 **Live Bus Tracking**

  * Location is pushed continuously to Firestore.
* 🎟️ **View Booked Tickets**

  * Shows all active tickets for the assigned bus.

---

## 🛠️ **Tech Stack**

### **Frontend**

* **Flutter (Dart)**
* **Open Street Maps**

### **Backend**

* **Firebase Authentication**
* **Cloud Firestore**

  * Stores user data, bus details, ticket data, and live locations.
* **Firebase Cloud Functions** (optional / if added)

  * Ticket expiry scheduler
* **Firebase Storage** (if storing bus images)

### **Services**

* **UPI Payment Integration**

  * Implemented through a custom `UPIService` in `services/upi_service.dart`.
* **Ticket Service**

  * Ticket creation and expiry logic (`ticket_service.dart`).
* **Location Service**

  * Used by conductors to share live GPS coordinates.

---

## 📂 **Project Structure**

```
lib/
 ├── screens/
 │    ├── login/
 │    ├── profile/
 │    ├── passenger/
 │    │      ├── ticket_booking_screen.dart
 │    │      ├── passenger_map.dart
 │    ├── conductor/
 │           ├── conductor_ui.dart
 │           ├── tickets_booked_screen.dart
 │
 ├── services/
 │    ├── upi_service.dart
 │    ├── ticket_service.dart
 │    ├── location_service.dart
 │
 ├── models/
 │    ├── ticket_model.dart
 │    ├── bus_model.dart
 │
 ├── widgets/
 │
 └── main.dart
```

---

## ✔️ **Core Functionalities Implemented**

* Real-time Firestore listeners for bus location updates
* Role-based login: **passenger** / **conductor**
* Navigation architecture with persistent session
* Ticket booking stored in Firestore with:

  * Timestamp
  * Expiry (3 hours)
  * Unique ID generation
* Map rendering with source/destination/bus markers
* Background-safe location updates for conductors

---

## 📌 **What This Project Solves**

Many buses in cities like Kolkata lack real-time visibility or digital ticket support.
Track2Go aims to improve:

* **Predictability** — Passengers know exactly where buses are
* **Convenience** — No cash required for tickets
* **Transparency** — Each ticket is uniquely identifiable
* **Efficiency** — Conductors automate part of their workflow

---


---

## 🧪 **Future Enhancements**

* Offline ticket verification for conductors
* Background location for passengers to improve fallback tracking
* Complete route prediction
* Notifications for bus arrival

---

## 🤝 **Contributions**

This project is part of a long-term development roadmap.
Suggestions and pull requests are welcome!

---

