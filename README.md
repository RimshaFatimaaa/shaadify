# Shaadify

Shaadify is a wedding budget visualizer for Pakistani families. It combines a drag-and-drop planning canvas, a live budget meter, and a vendor marketplace so a family can plan Mehndi, Barat, Walima, and the rest of the wedding in one place.

Tagline: **Plan Your Perfect Pakistani Wedding.**

The interface uses a deep maroon background (`#600000`) with pistachio accents (`#D7E8CD`).

## Demo

Screen recording of Shaadify running in Chrome (about 3 minutes).

https://github.com/user-attachments/assets/6c6269a0-0962-4f11-8a66-8f58b10f74c1

The original recording is [demo/shaadify-screen-recording.mp4](demo/shaadify-screen-recording.mp4). A smaller copy that plays in the browser is [demo/shaadify-demo.mp4](demo/shaadify-demo.mp4).

Sign-in on the recording is local. Any email and password opens the app.

## Accounts

The app has two roles.

**User.** A family planning a wedding. Sign up with name, email, and password, or log in with email and password. The profile shows the name and email, saved and booked vendor counts, location, notification toggle, and language.

**Vendor.** A business listing services. Signup asks for business name, vendor category, owner name, city, email, and password. A vendor subscription is required before registration. Login asks for owner name, email, and password.

Accounts, bookings, and payments are stored on the device. They are not connected to a live server.

## User features

### Home

- Welcome area and shortcuts into planning, vendors, and tools
- Category browsing
- Top-rated vendors
- Deals and promotions

### Event planning

Seven events can be planned separately, each with its own date, budget, theme, color palette, items, and timeline:

| Event | What it is |
| --- | --- |
| Mehndi | Henna ceremony |
| Barat | Main wedding ceremony |
| Walima | Reception dinner |
| Mayun | Pre-wedding celebration |
| Engagement | Engagement ceremony |
| Nikah | Islamic marriage ceremony |
| Qawali Night | Musical celebration |

The canvas is drag and drop. Items such as venue, décor, catering, makeup, photography, and music show a price range and update the budget as they are added. Plans can be filtered by category and city, and by Budget, Balanced, or Premium price level. A plan can also be generated automatically from the chosen budget.

### Budget meter

Spending is compared with the event budget:

- Under 80% is within budget
- 80% to 100% is near the limit
- Over 100% is over budget

If no budget is set, the meter uses fixed PKR bands: under Rs. 5 lakh, Rs. 5 lakh to Rs. 20 lakh, and Rs. 20 lakh and above. Prices are shown in rupees, including lakh and crore formatting.

### Vendor marketplace

- Browse vendors by category and city
- Cards show photo or initial, name, category, location, rating, review count, price range, and a verified badge
- Vendor page includes packages, reviews, contact details, save, and book
- Saved vendors can be opened again or removed
- Bookings are grouped by event and marked pending, confirmed, or cancelled
- Pending bookings can be cancelled
- Confirmed bookings can be reported
- Confirmed venue bookings include a QR code

Report reasons: Poor Service Quality, Unprofessional Behavior, Payment Issues, False Information, Safety Concerns, Cancellation Issues, and Other. Each report can include extra detail. Past reports show vendor, reason, description, date, and status (pending, reviewed, or resolved).

### Planning tools

- **Moodboard.** Theme, event, and color palette suggestions. Image generation is mocked and ready for a real model later.
- **Bride personality quiz.** Questions that suggest a theme, vendors, and a budget range.
- **Outfit-to-theme matching.** A bridal dress photo is used to suggest décor. Matching is mocked.
- **Price simulator.** "What if" changes and their effect on the budget.
- **Timeline.** Built from the items selected for an event.

### Shaadify Pro

| Plan | Price |
| --- | --- |
| Pro Monthly | Rs. 999 / month |
| Pro Yearly | Rs. 9,999 / year (about 17% less than twelve monthly payments) |

Pro includes wedding visualization, 10% off Pro vendors, priority support, advanced planning tools, and unlimited events. The yearly plan also includes early access to new features. Checkout goes through an in-app payment screen and is stored locally.

Wedding visualization is a Pro screen. It summarizes confirmed vendors and the overall wedding.

### Profile, language, and feedback

- Notifications list and a toggle for notification preferences
- Languages: English, Urdu, Pashto, Sindhi, Balochi, and Saraiki
- App feedback, plus a list of feedback already given

## Vendor features

### Dashboard

- Welcome card with the business name
- New leads this week, profile views, and revenue from in-app bookings
- Latest activity
- Shortcuts to leads and packages

### Leads and packages

Leads are split into pending, confirmed, and completed. Each lead shows the client, event type and date, package, location, and status. A vendor can accept or reject a pending lead, open the details, generate a QR code for a confirmed booking, and mark a lead completed.

Packages can be added, edited, and deleted. A package has a name, price, description, and feature list.

### Business profile

Editable fields: business name, category, owner name, phone, email, address, website, description, and city. The profile also shows verification status.

### Subscription

A subscription is required before a vendor can register.

| Plan | Price |
| --- | --- |
| Vendor Monthly | Rs. 1,999 / month |
| Vendor Yearly | Rs. 19,999 / year (about 17% less than twelve monthly payments) |

Both plans include a business listing, booking requests, portfolio management, analytics, reviews, and booking QR codes. The yearly plan adds priority placement and a featured badge. The vendor can see renewal date, change plan, or cancel. Payment is handled on the in-app payment screen and stored on the device.

### Analytics, settings, and help

- Performance metrics for the business
- General settings, notification preferences, and account settings
- Help, support contact, and FAQ
- Lead and booking notifications
- Logout

## Catalog

**Vendor categories:** Venue, Décor, Catering, Makeup, Photography, Music, Nikah Setup, Gifts, Car Entry, Other.

**Cities:** Karachi, Lahore, Islamabad, Rawalpindi, Faisalabad, Multan, Peshawar, Quetta, Sialkot, Gujranwala, Hyderabad, Sargodha.

**Themes:** Royal, Pastel, Neon, Rustic, Garden, Classic Red, Modern Minimalist, Vintage, Boho, Luxury. Each theme has its own color palette.

## Tech stack

- Flutter for Android, iOS, and web
- Provider for app state
- Shared preferences for the user, vendor, subscription, saved vendors, bookings, and reports kept on the device
- Google Fonts (Poppins)
- Mock AI for moodboards, the personality quiz, and outfit matching

## Getting started

Flutter 3.10.3 or newer is required.

```bash
git clone https://github.com/RimshaFatimaaa/shaadify.git
cd shaadify
flutter pub get
flutter run
```

Chrome is the quickest target on a desktop:

```bash
flutter run -d chrome
```

`android/local.properties` is created on each machine from the local Flutter SDK path and is not in this repository.

## Project structure

```
lib/
├── constants/     App name, cities, categories, themes, budget bands
├── l10n/          English, Urdu, Pashto, Sindhi, Balochi, Saraiki
├── models/        Events, items, vendors, bookings, leads, reports, plans
├── providers/     Wedding, language, and feedback state
├── screens/       Auth, home, canvas, marketplace, vendor tools
├── services/      Sample wedding data, quiz, and mock AI
├── utils/         Price formatting and budget status
├── widgets/       Budget meter, cards, and canvas pieces
└── main.dart
demo/
├── shaadify-demo.mp4
└── shaadify-screen-recording.mp4
```

## Notes

This is a university project. Sign-in does not check a real account. Payments, vendor data, and AI images are sample behavior on the device, ready to be wired to a backend later.
