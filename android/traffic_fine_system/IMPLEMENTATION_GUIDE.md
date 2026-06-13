# SL Traffic Fine System - Architecture & Implementation Guide

## System Overview

This is a comprehensive traffic fine management system for Sri Lanka Police Department following government digitalization policy. The system consists of three main applications:

1. **Mobile App (Android)** - For on-the-spot fine payment by traffic officers
2. **Public Web Portal** - For drivers to pay fines online
3. **Admin Dashboard** - For senior officials to monitor collections

---

## Current Implementation Status

### ✅ COMPLETED - Mobile App Core Features

#### Authentication System
```
Login Screen → Badge Number (sl1234) + Password (1234)
   ↓
Mock Authentication (Hardcoded for testing)
   ↓
Dashboard
```

#### Officer Registration
- Complete form with validation
- Badge number, name, district, password
- Redirects to login screen

#### Enhanced Dashboard
```
Officer Card (Badge, Name, District)
        ↓
Statistics (Total, Unpaid, Collected)
        ↓
Quick Actions (Issue, Search, History)
        ↓
Notification Bell (Dynamic count of unpaid)
```

#### Notification System (Fully Functional)
- Real-time notification bell with badge count
- Bottom sheet with all notifications
- Click-to-view fine details modal
- Status indicators (PAID/PENDING)
- Color-coded UI (Green=Paid, Red=Pending)

---

## 🔨 NEXT IMPLEMENTATION - Critical Features

### 1. Fine Entry/Issuance Screen

**Location**: `lib/ui/fine/fine_entry_screen.dart` (exists, needs enhancement)

**Features to add:**
```dart
Class FineEntryScreen {
  - Reference Number Input (auto-generated or manual lookup)
  - Category Dropdown (FC001-FC008)
  - Driver Details Form:
    * Driver Name
    * License Number
    * Vehicle Number
  - Violation Details Text Area
  - Location Picked from Map
  - Fine Amount Calculator (based on category)
  - Issue Button → Navigate to Payment
}
```

### 2. Fine Search/Lookup

**For drivers to search issued fines:**
```dart
Class FineSearchScreen {
  - Reference Number Input
  - Category ID Input
  - Search Button
  - Display Results:
    * Fine amount
    * Issue date
    * Payment status
    * Payment button if unpaid
}
```

### 3. Payment Processing

**Location**: `lib/ui/payment/payment_screen.dart` (exists, needs completion)

**Payment Methods:**
- VISA Card
- MasterCard
- LankaQR (Sri Lankan payment method)

**Features:**
```dart
Class PaymentScreen {
  - Card Number (16 digits)
  - Cardholder Name
  - Expiry Date (MM/YY)
  - CVV (3-4 digits)
  - Pay Button
  - Loading state with progress
}
```

**Payment Integration Steps:**
1. Connect to payment gateway API (HubPay, PayMob, or local SL provider)
2. Validate card details
3. Process payment
4. Save transaction record
5. Trigger SMS notification to officer
6. Display confirmation screen

### 4. SMS Notification System

**After successful payment:**
```
SMS to Traffic Officer:
"Hi Officer! Payment of Rs 5000 for fine REF-2024-001 (John Doe - DL1234567) 
has been completed. Driver can retrieve their license. - SL Police"
```

**Implementation:**
- Integrate SMS gateway (Dialog, Mobitel, or Twilio)
- Trigger SMS immediately after payment success
- Log all SMS transactions
- Add retry mechanism for failed SMS

---

## 📊 BACKEND API Requirements

### User Authentication
```
POST /auth/login
{
  "badgeNumber": "SLP-12345",
  "password": "password123"
}
Response:
{
  "accessToken": "jwt_token",
  "tokenType": "Bearer",
  "expiresIn": 3600,
  "officerName": "John Perera",
  "badgeNumber": "SLP-12345",
  "district": "Western Province"
}
```

### Fine Lookup
```
GET /fines/{referenceNumber}?categoryId=FC001
Response:
{
  "referenceNumber": "REF-2024-001",
  "categoryId": "FC001",
  "categoryName": "Speeding",
  "amount": 5000,
  "issuedDate": "2024-01-15T10:30:00",
  "driverName": "John Doe",
  "driverLicense": "DL1234567",
  "vehicleNumber": "CAR-2024",
  "isPaid": false,
  "locationIssued": "Colombo Fort"
}
```

### Fine Creation (For Officers)
```
POST /fines/issue
{
  "driverName": "John Doe",
  "driverLicense": "DL1234567",
  "vehicleNumber": "CAR-2024",
  "categoryId": "FC001",
  "violationDetails": "Speeding 85km/h in 60km/h zone",
  "amount": 5000,
  "locationIssued": "Colombo Fort"
}
Response:
{
  "referenceNumber": "REF-2024-001",
  "createdAt": "2024-01-15T10:30:00"
}
```

### Payment Processing
```
POST /payments
{
  "fineReferenceNumber": "REF-2024-001",
  "amount": 5000,
  "paymentMethod": "VISA",
  "cardDetails": {
    "cardNumber": "1234567890123456",
    "cardholderName": "John Doe",
    "expiryDate": "12/25",
    "cvv": "123"
  }
}
Response:
{
  "paymentId": "PAY-2024-001",
  "status": "SUCCESS",
  "transactionId": "TXN-12345",
  "paidAt": "2024-01-15T10:35:00"
}
```

---

## 📱 Current File Structure

```
lib/
├── data/
│   ├── model/
│   │   ├── fine.dart
│   │   ├── login_response.dart
│   │   ├── notification.dart (NEW)
│   │   └── payment_response.dart
│   ├── network/
│   │   └── api_service.dart
│   ├── repository/
│   │   ├── auth_repository.dart
│   │   └── payment_repository.dart
│   └── local/
│       └── token_manager.dart
├── ui/
│   ├── login/
│   │   ├── login_screen.dart
│   │   ├── registration_screen.dart (NEW)
│   │   └── login_view_model.dart
│   ├── main/
│   │   ├── main_screen.dart (ENHANCED)
│   │   └── app_router.dart
│   ├── fine/
│   │   └── fine_entry_screen.dart (needs work)
│   ├── payment/
│   │   └── payment_screen.dart (needs work)
│   └── confirmation/
│       └── confirmation_screen.dart
└── utils/
    ├── app_constants.dart (updated)
    ├── validation_utils.dart
    ├── network_utils.dart
    └── providers.dart
```

---

## 🚀 Implementation Priority

### Phase 1 (Current) ✅
- [x] Authentication & Login
- [x] Registration
- [x] Enhanced Dashboard
- [x] Notification System

### Phase 2 (Next)
- [ ] Fine Entry/Issuance
- [ ] Fine Amount Calculation
- [ ] Location Mapping

### Phase 3
- [ ] Payment Gateway Integration
- [ ] Card Processing
- [ ] Transaction Logging

### Phase 4
- [ ] SMS Notifications
- [ ] Payment Confirmation
- [ ] Receipt Generation

### Phase 5
- [ ] Backend API Integration
- [ ] Remove mock data
- [ ] Live payment processing

---

## 💡 Key Features Summary

| Feature | Status | Details |
|---------|--------|---------|
| Officer Login | ✅ Complete | Badge + Password, Mock auth |
| Registration | ✅ Complete | Full form with validation |
| Dashboard | ✅ Complete | Stats, actions, officer info |
| Notifications | ✅ Complete | Dynamic bell, detail view |
| Fine Lookup | 🔨 In Progress | Search by reference |
| Fine Issuance | 🔨 In Progress | Form + validation |
| Payment | ⏳ Pending | Visa, MasterCard, LankaQR |
| SMS Alerts | ⏳ Pending | Officer notification |
| Admin Portal | ⏳ Pending | Web dashboard |

---

## 🔐 Security Considerations

1. **Token Management**: JWT tokens with 1-hour expiration
2. **Password Security**: Hash with bcrypt (backend)
3. **Card PCI Compliance**: Never store full card numbers
4. **HTTPS**: All API calls must be encrypted
5. **Authentication**: Verify officer badge number uniqueness
6. **Rate Limiting**: Prevent brute force attacks
7. **Audit Logging**: Track all fine issuances and payments

---

## 📞 Integration Checklist

Before going live:

- [ ] Backend API endpoints created and tested
- [ ] Payment gateway account setup
- [ ] SMS provider account configured
- [ ] Database schema designed and migrated
- [ ] Authentication server deployed
- [ ] SSL certificates configured
- [ ] Mobile app signed for release
- [ ] Test with real payment data
- [ ] User acceptance testing completed
- [ ] Documentation written for officers
- [ ] Support team trained

---

## Testing Guide

### Manual Testing
1. Launch app → Splash screen
2. Login: Badge `sl1234` / Password `1234`
3. View dashboard with mock notifications
4. Click notification bell → See all fines
5. Click fine → View complete details

### Unit Tests Needed
- Authentication validation
- Payment amount calculation
- Date formatting
- Notification filtering

---

## Contact & Support

For implementation assistance, refer to:
- Backend team for API specifications
- Payment provider for integration docs
- SMS provider for rate limits and pricing
- Security team for PCI compliance

