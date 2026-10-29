# Shaadify App - Complete Feature List

## USER SIDE FEATURES

### 1. Authentication & Profile
- **Login/Signup**: User authentication with email and password
- **Profile Management**: 
  - View user profile with name and email
  - Update location settings
  - Enable/disable notifications
  - Language selection (Multiple languages supported)
  - View saved vendors count
  - View booked vendors count
  - Logout functionality

### 2. Home Screen
- **Dashboard Overview**: 
  - Welcome section
  - Quick access to main features
  - Category browsing
  - Top-rated vendors display
  - Deals and promotions carousel

### 3. Event Planning (Canvas)
- **Event Selection**: 
  - Select from 7 event types:
    - Mehndi (Henna ceremony)
    - Barat (Main wedding ceremony)
    - Walima (Reception dinner)
    - Mayun (Pre-wedding celebration)
    - Engagement
    - Nikah (Islamic marriage ceremony)
    - Qawali Night
- **Drag & Drop Canvas**: 
  - Interactive drag-and-drop interface for planning
  - Add wedding items to events
  - Real-time budget tracking
  - Budget meter with color indicators (Green/Yellow/Red)
  - Category filtering (Venue, Décor, Catering, Makeup, Photography, Music, etc.)
  - City filtering
  - Price level selection (Budget/Balanced/Premium)
  - Auto-generate budget plan feature
  - Timeline generation
  - Theme and color palette selection

### 4. Vendor Marketplace
- **Browse Vendors**: 
  - View all vendors by category
  - Filter by category and city
  - Vendor cards showing:
    - Profile image (with first letter fallback)
    - Name, category, location
    - Rating and review count
    - Price range
    - Verified badge
- **Vendor Details**: 
  - Full vendor profile
  - Package options
  - Reviews and ratings
  - Contact information
  - Save/unsave vendors
  - Book vendor functionality

### 5. Booked Vendors (Cart)
- **Booking Management**: 
  - View pending bookings
  - View confirmed bookings
  - Group bookings by event type
  - Booking cards showing:
    - Vendor information
    - Plan name and price
    - Booking status (Pending/Confirmed/Cancelled)
    - Booking date
  - Cancel pending bookings
  - **Report Vendor**: Report button on all confirmed vendors
  - QR Code viewing for confirmed venue bookings

### 6. Saved Vendors
- **Favorites Management**: 
  - View all saved vendors
  - Remove vendors from saved list
  - Quick access to vendor details

### 7. Pro Plan Subscription
- **Subscription Options**: 
  - Monthly plan (Rs. 999/month)
  - Yearly plan (Rs. 9,999/year - 17% savings)
- **Pro Features**:
  - Wedding Visualization (3D visualization of booked vendors)
  - 10% discount on Pro vendors
  - Priority support
  - Advanced planning tools
  - Unlimited events
  - Early access to new features (yearly plan)

### 8. Wedding Visualization (Pro Feature)
- **3D Visualization**: 
  - Visual representation of confirmed vendors
  - Summary cards for each vendor
  - Overall wedding summary
  - Only available for Pro users

### 9. Vendor Reporting
- **Report Confirmed Vendors**: 
  - Report button on all confirmed vendor cards
  - Report reasons:
    - Poor Service Quality
    - Unprofessional Behavior
    - Payment Issues
    - False Information
    - Safety Concerns
    - Cancellation Issues
    - Other
  - Additional details text field
  - Submit reports to app support

### 10. Previous Reports
- **Report History**: 
  - View all previously submitted reports
  - Report status tracking (Pending/Reviewed/Resolved)
  - View report details:
    - Vendor name and category
    - Report reason
    - Description
    - Report date
    - Status badge

### 11. Notifications
- **Notification Center**: 
  - View all app notifications
  - Notification management

### 12. Additional Features
- **Personality Quiz**: Available from home screen
- **Feedback System**: Submit feedback about the app
- **Multi-language Support**: 
  - English
  - Urdu
  - Sindhi
  - Pashto
  - Balochi
  - Saraiki

---

## VENDOR SIDE FEATURES

### 1. Authentication & Registration
- **Vendor Signup**: 
  - Business name
  - Vendor category selection
  - Owner name
  - Business location (city)
  - Email and password
  - **Subscription Required**: Must subscribe before signup
- **Vendor Login**: 
  - Email and password
  - Owner name
  - **Automatic Active Subscription**: Vendors who login get active subscription automatically

### 2. Dashboard
- **Overview**: 
  - Welcome card with business name
  - Quick stats:
    - New leads this week
    - Profile views
    - Booked via app (revenue)
  - Latest activity feed
  - Quick navigation to leads and packages

### 3. Leads & Bookings Management
- **Lead Management**: 
  - View leads in tabs:
    - Pending leads
    - Confirmed leads
    - Completed leads
  - Lead cards showing:
    - Client name
    - Event type and date
    - Package name
    - Location
    - Status badge
  - Accept/reject pending leads
  - View lead details
  - QR Code generation for confirmed bookings
  - Mark leads as completed

### 4. Packages Management
- **Package Management**: 
  - View all packages
  - Add new packages
  - Edit existing packages
  - Delete packages
  - Package details:
    - Package name
    - Price
    - Description
    - Features list

### 5. Business Profile
- **Profile Management**: 
  - Edit business information:
    - Business name
    - Vendor category
    - Owner name
    - Phone number
    - Email
    - Address
    - Website
    - Business description
    - City/location
  - View verification status

### 6. Subscription Management
- **Subscription Plans**: 
  - Monthly plan (Rs. 1,999/month)
  - Yearly plan (Rs. 19,999/year - 17% savings)
- **Subscription Features**:
  - View current subscription status
  - Active subscription badge
  - Renewal date display
  - Manage subscription
  - Change plan
  - Cancel subscription
  - **Monthly Subscription Menu Item**: Appears in menu when logged in (instead of Subscribe Now)

### 7. Analytics
- **Business Analytics**: 
  - View business performance metrics
  - Analytics dashboard
  - Performance insights

### 8. Menu & Settings
- **Menu Options**: 
  - Subscription plan section
  - Monthly subscription (if logged in without active subscription)
  - Analytics
  - Settings
  - Help & Support
  - Logout

### 9. Settings
- **App Settings**: 
  - General settings
  - Notification preferences
  - Account settings

### 10. Help & Support
- **Support Features**: 
  - Help documentation
  - Support contact information
  - FAQ section

### 11. Notifications
- **Notification Center**: 
  - View all vendor notifications
  - Lead notifications
  - Booking updates

### 12. QR Code System
- **QR Code Generation**: 
  - Generate QR codes for confirmed bookings
  - Share QR codes with clients
  - QR code viewing for venue bookings

---

## SHARED FEATURES

### 1. Multi-language Support
- English
- Urdu
- Sindhi
- Pashto
- Balochi
- Saraiki

### 2. Notifications System
- Real-time notifications
- Notification center
- Notification preferences

### 3. Authentication
- Secure login/signup
- Session management
- Logout functionality

### 4. UI/UX Features
- Consistent maroon and pistachio color theme
- Blurred background images
- Responsive design
- Smooth navigation
- Bottom navigation bar
- Profile images with first letter fallback

---

## TECHNICAL FEATURES

### Data Persistence
- SharedPreferences for local storage
- User preferences
- Subscription data
- Vendor reports
- Saved vendors
- Booked vendors

### State Management
- Provider pattern for state management
- Real-time updates
- Notifications system

### Payment Integration
- Payment screen for subscriptions
- Secure payment processing

---

## EVENT TYPES SUPPORTED

1. **Mehndi** - Traditional henna ceremony
2. **Barat** - Main wedding ceremony
3. **Walima** - Reception dinner
4. **Mayun** - Pre-wedding celebration
5. **Engagement** - Engagement ceremony
6. **Nikah** - Islamic marriage ceremony
7. **Qawali Night** - Musical celebration night

---

## VENDOR CATEGORIES SUPPORTED

1. Venue
2. Décor
3. Catering
4. Makeup
5. Photography
6. Music
7. Nikah Setup
8. Gifts
9. Car Entry
10. Other

---

## CITIES SUPPORTED

- Lahore
- Karachi
- Islamabad
- Rawalpindi
- Faisalabad
- Multan
- Peshawar
- Quetta
- And more...

