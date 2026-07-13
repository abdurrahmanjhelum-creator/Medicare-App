# Medicare App - Complete Workflow Documentation

## Overview
Yeh document Medicare Hospital Management app ka complete workflow explain karta hai. Yeh ek **100% REAL** app hai - koi dummy data nahi hai. Sab kuch real backend se connect hai.

---

## Backend Architecture (NestJS + MongoDB)

### 1. Doctor Management

**Endpoint:** `GET /api/doctors` (Public)
- Saare verified doctors ki list return karta hai
- Filters support karta hai: specialization, rating, fee, search
- Response structure:
```json
{
  "doctors": [
    {
      "id": "doctor_id",
      "userId": "user_id",
      "name": "Dr. Name",
      "email": "email@example.com",
      "profileImage": "image_url",
      "pmdcLicenceNumber": "12345-P",
      "specialization": "Cardiologist",
      "qualification": "MBBS, FCPS",
      "experience": "10 Years",
      "clinic": "Hospital Name",
      "clinicAddress": "Address",
      "fee": 2500,
      "bio": "Doctor bio",
      "availableDays": ["Mon", "Tue", "Wed"],
      "availableSlots": ["09:00-09:30 AM", "10:00-10:30 AM"],
      "rating": 4.8,
      "totalReviews": 124,
      "isVerified": true
    }
  ],
  "total": 10
}
```

**Endpoint:** `GET /api/doctors/:id` (Public)
- Single doctor ki details return karta hai

---

### 2. Appointment Booking System

**Endpoint:** `POST /api/appointments` (Patient Only)
- Patient naya appointment book karta hai
- Request body:
```json
{
  "doctorId": "doctor_user_id",
  "date": "2024-01-15",
  "time": "09:00-09:30 AM",
  "type": "In-Person",
  "patientNotes": "Patient notes"
}
```

**Booking Logic:**
1. Doctor database se check hota hai
2. Patient database se check hota hai
3. Doctor us din available hai ya nahi check hota hai
4. Time slot already booked hai ya nahi check hota hai
5. Agar sab theek hai to appointment create hota hai
6. **AUTOMATIC NOTIFICATION:** Doctor ko notification bhejta hai

**Automatic Notification to Doctor:**
```
Title: "New Appointment Booked"
Message: "Patient Name has booked an appointment with you on Date at Time"
Type: "appointment"
Related ID: appointment_id
```

**Endpoint:** `GET /api/appointments` (Patient Only)
- Patient ke saare appointments return karta hai
- Filters: status, startDate, endDate
- Response:
```json
{
  "appointments": [
    {
      "_id": "appointment_id",
      "patientId": "patient_id",
      "patientName": "Patient Name",
      "doctorId": "doctor_id",
      "doctorName": "Doctor Name",
      "specialization": "Cardiology",
      "date": "2024-01-15T00:00:00.000Z",
      "time": "09:00-09:30 AM",
      "type": "In-Person",
      "location": "Hospital Name",
      "status": "pending",
      "patientNotes": "Notes"
    }
  ],
  "total": 5
}
```

**Endpoint:** `DELETE /api/appointments/cancel` (Patient Only)
- Patient appointment cancel kar sakta hai
- Body: `{ "appointmentId": "id", "reason": "reason" }`

---

### 3. Doctor Appointment Management

**Endpoint:** `GET /api/appments/doctor/my-appointments` (Doctor Only)
- Doctor ke saare appointments return karta hai
- Filters: status, startDate, endDate

**Endpoint:** `PUT /api/appointments/:id/status` (Doctor Only)
- Doctor appointment status update kar sakta hai
- Status options: confirmed, completed, rejected
- Body:
```json
{
  "status": "confirmed",
  "doctorNotes": "Doctor notes"
}
```

**Automatic Notification to Patient:**
Jab doctor status update karta hai, patient ko automatic notification milti hai:
- Confirmed: "Your appointment with Doctor Name on Date at Time has been confirmed"
- Completed: "Your appointment with Doctor Name has been completed"
- Rejected: "Your appointment with Doctor Name on Date at Time has been rejected"

---

### 4. Notification System

**Endpoint:** `GET /api/notifications` (Authenticated)
- User ke saare notifications return karta hai
- Response:
```json
{
  "notifications": [
    {
      "_id": "notification_id",
      "userId": "user_id",
      "title": "Notification Title",
      "message": "Notification message",
      "type": "appointment",
      "icon": "calendar",
      "iconColor": "#3B82F6",
      "iconBackgroundColor": "#DBEAFE",
      "relatedId": "appointment_id",
      "isRead": false,
      "createdAt": "2024-01-15T10:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 50,
    "totalPages": 3
  },
  "unreadCount": 5
}
```

**Endpoint:** `PUT /api/notifications/mark-read` (Authenticated)
- Notification ko read mark karta hai

**Endpoint:** `PUT /api/notifications/mark-all-read` (Authenticated)
- Saare notifications ko read mark karta hai

**Endpoint:** `DELETE /api/notifications/:id` (Authenticated)
- Notification delete karta hai

---

## Frontend Architecture (Flutter + Riverpod)

### 1. Doctor Listing

**Controller:** `doctor_controller.dart`
- Backend se doctors fetch karta hai: `GET /api/doctors`
- Data mapping: Backend fields → Frontend model
- **Status:** 100% REAL - No dummy data fallback

**Model:** `doctor_model.dart`
- Backend response se data map karta hai:
  - `profileImage` → `image`
  - `fee` → `doctorFee`
  - `clinic` → `branch`
  - `totalReviews` → `reviews`
  - `clinicAddress` → `branch` (fallback)

**API Service:** `api_service.dart`
- Base URL configuration:
  - Web: `http://localhost:3000/api`
  - Android: `http://10.0.2.2:3000/api`
  - Others: `http://127.0.0.1:3000/api`
- Auto token management for authenticated requests

---

### 2. Appointment Booking

**Controller:** `appointment_controller.dart`
- Appointments fetch karta hai: `GET /api/appointments`
- New appointment book karta hai: `POST /api/appointments`
- Appointment cancel karta hai: `DELETE /api/appointments/cancel`
- **Status:** 100% REAL - No dummy data fallback
- Status mapping:
  - `pending`, `confirmed` → Upcoming
  - `completed`, `cancelled`, `rejected` → Completed

**Model:** `appointment_model.dart`
- Backend response se data map karta hai:
  - `doctorImage` → `doctorimage`
  - `time` → `time`
  - `type` → `type`
  - `location` → `location`
  - `status` → `status`
  - `date` → `date`
  - `_id` → `id`

---

## Complete Workflow

### Patient Side:

1. **Doctor Viewing:**
   - Patient app kholta hai
   - Doctors tab mein jaata hai
   - `DoctorController` se doctors fetch hote hain
   - Backend: `GET /api/doctors` call hota hai
   - Doctors list display hoti hai with filters

2. **Appointment Booking:**
   - Patient kisi doctor ko select karta hai
   - Available days aur slots dekhta hai
   - Date aur time select karta hai
   - "Book Appointment" button dabata hai
   - Frontend: `POST /api/appointments` call hota hai
   - Backend: Appointment create hota hai
   - **AUTOMATIC:** Doctor ko notification bhejta hai
   - Patient ko success message milta hai

3. **Viewing Appointments:**
   - Patient Appointments tab mein jaata hai
   - `AppointmentController` se appointments fetch hote hain
   - Backend: `GET /api/appointments` call hota hai
   - Upcoming aur Completed appointments separate display hote hain

4. **Receiving Notifications:**
   - Jab doctor appointment status update karta hai
   - Patient ko automatic notification milti hai
   - Notification tab mein dekh sakta hai
   - Notifications read/unread status track hota hai

### Doctor Side:

1. **Viewing Appointments:**
   - Doctor app kholta hai
   - Appointments tab mein jaata hai
   - Backend: `GET /api/appointments/doctor/my-appointments` call hota hai
   - Saare patient appointments display hote hain

2. **Managing Appointments:**
   - Doctor appointment status update kar sakta hai
   - Options: Confirm, Complete, Reject
   - Backend: `PUT /api/appointments/:id/status` call hota hai
   - **AUTOMATIC:** Patient ko notification bhejta hai

3. **Receiving Notifications:**
   - Jab patient naya appointment book karta hai
   - Doctor ko automatic notification milti hai
   - Notification tab mein dekh sakta hai

---

## Data Flow Diagram

```
Patient App                    Backend                    Doctor App
    |                            |                            |
    |-- GET /doctors ----------->|                            |
    |<-- doctors list -----------|                            |
    |                            |                            |
    |-- POST /appointments ---->|                            |
    |   (book appointment)      |                            |
    |                            |-- Create appointment       |
    |                            |-- Send notification ------>|
    |<-- success response -------|                            |
    |                            |                            |
    |                            |                            |-- GET notifications
    |                            |                            |<-- New appointment notification
    |                            |                            |
    |                            |                            |-- PUT /appointments/:id/status
    |                            |                            |   (confirm appointment)
    |                            |<-- Update status ----------|
    |                            |-- Send notification ------>|
    |                            |                            |
    |-- GET notifications ------|                            |
    |<-- Appointment confirmed |                            |
    |    notification            |                            |
```

---

## Key Features Implemented

✅ **Real-time Doctor Listing:** Backend se doctors fetch hote hain with filters (100% REAL)
✅ **Appointment Booking:** Complete booking flow with validation (100% REAL)
✅ **Automatic Notifications:** Doctor aur patient dono ko automatic notifications milti hain (100% REAL)
✅ **Status Management:** Doctor appointments ko confirm/reject/complete kar sakta hai (100% REAL)
✅ **Data Mapping:** Proper field mapping between backend and frontend (100% REAL)
✅ **Error Handling:** API failures ke liye proper error messages (NO DUMMY DATA)
✅ **Authentication:** JWT token based authentication (100% REAL)
✅ **Role-based Access:** Patient aur doctor alag-alag endpoints access kar sakte hain (100% REAL)
✅ **All Controllers:** No dummy data in any controller - fully backend connected

---

## Environment Setup

### Backend:
```bash
cd medicare-backend
npm install
npm run start:dev
```
Server runs on: `http://0.0.0.0:3000/api`

### Frontend:
```bash
cd medicare
flutter pub get
flutter run
```

### Database:
- MongoDB Atlas connection already configured
- Connection string in `.env` file

---

## Testing Checklist

1. ✅ Backend doctors endpoint working
2. ✅ Frontend doctor listing working
3. ✅ Appointment booking working
4. ✅ Doctor notification on booking
5. ✅ Patient notification on status update
6. ✅ Appointment status management
7. ✅ Data mapping correct
8. ✅ **No dummy data anywhere** - All controllers use real backend data
9. ✅ Auth controllers connected to backend
10. ✅ All API calls properly configured

---

## Conclusion

App bilkul **100% REAL** hai aur properly working hai - **KOI DUMMY DATA NAHI**:
- Backend se real doctors fetch hote hain
- Patient doctors list mein dekh sakta hai
- Appointment booking sahi se hoti hai with date/time selection
- Doctor ko automatic notification milti hai jab patient book karta hai
- Doctor appointments ko manage kar sakta hai
- Patient ko notification milti hai jab doctor status update karta hai
- Sab kuch real-time aur properly connected hai
- **All controllers use real backend data - no fallbacks**
- **Ready for deployment**
