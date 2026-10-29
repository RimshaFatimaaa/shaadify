# Shaadify

Shaadify is a wedding budget visualizer for Pakistani families. It works like a digital moodboard and budgeting tool: drag venues, décor, catering, and other items onto an event canvas, watch the budget meter update, and browse vendors by city.

## Demo

Screen recording of Shaadify running in Chrome (about 3 minutes).

[demo/shaadify-screen-recording.mp4](demo/shaadify-screen-recording.mp4) is the original recording. [demo/shaadify-demo.mp4](demo/shaadify-demo.mp4) is a smaller copy used for playback on this page.

Sign-in on the recording is local. Any email and password opens the app.

## Features

- Drag-and-drop wedding canvas with live prices
- Budget meter that shifts from green to yellow to red as spending grows
- Separate plans for Mehndi, Barat, Walima, Mayun, Engagement, Nikah, and Qawwali Night
- Vendor marketplace with city and category filters, packages, reviews, and bookings
- Saved vendors, booking status, and QR codes for confirmed venue bookings
- Moodboard, bride personality quiz, and outfit-to-theme suggestions
- Price simulator and an automatic wedding timeline
- User and vendor accounts, vendor dashboard, leads, reports, and subscription screens
- English, Urdu, Pashto, Sindhi, Balochi, and Saraiki

## Tech stack

- Flutter (Android, iOS, and web)
- Provider for state
- Shared preferences for data kept on the device
- Mock authentication and mock AI services, ready to connect to a real backend later

## Getting started

You need Flutter 3.10.3 or newer.

```bash
git clone https://github.com/RimshaFatimaaa/shaadify.git
cd shaadify
flutter pub get
flutter run
```

On desktop, Chrome is the quickest target:

```bash
flutter run -d chrome
```

`android/local.properties` is machine-specific and is not in the repository. Flutter recreates it from your local SDK path.

## Project structure

```
lib/
├── constants/          App constants
├── l10n/               Translations
├── models/             Events, items, vendors, bookings
├── providers/          Wedding, language, and feedback state
├── screens/            Auth, home, canvas, marketplace, vendor tools
├── services/           Wedding data, quiz, and mock AI
├── utils/              Price and budget helpers
├── widgets/            Budget meter, cards, and canvas pieces
└── main.dart
demo/
└── shaadify-screen-recording.mp4
```

## Events, themes, and cities

Events: Mehndi, Barat, Walima, Mayun, Engagement, Nikah, Qawwali Night.

Themes include Royal, Pastel, Neon, Rustic, Garden, Classic Red, Modern Minimalist, Vintage, Boho, and Luxury.

Cities: Karachi, Lahore, Islamabad, Rawalpindi, Faisalabad, Multan, Peshawar, Quetta, Sialkot, Gujranwala, Hyderabad, and Sargodha.

## Budget meter

- Green: under 80% of the budget
- Yellow: 80% to 100%
- Red: over the budget

## Notes

This is a university project. Accounts, payments, and AI image generation run locally with sample data. They are not connected to a live server.
