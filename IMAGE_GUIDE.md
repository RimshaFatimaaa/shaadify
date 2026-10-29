# Image Guide for Shaadify App

## Current Status
Right now, the app uses **placeholder images from the internet** (picsum.photos) for moodboards. You don't need any images to run the app, but adding your own images will make it look much better!

## Images You Can Add (Optional but Recommended)

### 1. **Moodboard Images** (Most Important)
**Location:** `assets/images/moodboards/`

**What you need:**
- **6 images per theme** (10 themes = 60 images total)
- **Recommended size:** 400x600 pixels or larger
- **Format:** JPG or PNG

**Theme folders to create:**
```
assets/images/moodboards/
├── royal/
│   ├── royal_1.jpg
│   ├── royal_2.jpg
│   ├── royal_3.jpg
│   ├── royal_4.jpg
│   ├── royal_5.jpg
│   └── royal_6.jpg
├── pastel/
│   ├── pastel_1.jpg
│   └── ... (6 images)
├── neon/
├── rustic/
├── garden/
├── classic_red/
├── modern_minimalist/
├── vintage/
├── boho/
└── luxury/
```

**What kind of images:**
- Wedding stage decorations matching the theme
- Table setups
- Flower arrangements
- Lighting setups
- Overall venue ambiance
- Color-coordinated décor elements

### 2. **Vendor Profile Images** (Optional)
**Location:** `assets/images/vendors/`

**What you need:**
- Profile pictures for vendors (square format recommended)
- **Size:** 200x200 pixels or larger
- **Format:** JPG or PNG

**Example:**
```
assets/images/vendors/
├── vendor_1.jpg
├── vendor_2.jpg
└── vendor_3.jpg
```

### 3. **Wedding Item Images** (Optional)
**Location:** `assets/images/items/`

**What you need:**
- Images for each wedding item category
- **Size:** 300x300 pixels (square)
- **Format:** JPG or PNG

**Categories:**
- Venue images
- Décor examples
- Catering setups
- Makeup looks
- Photography samples
- Music/Dhol setups
- Nikah setups
- Gift examples
- Car entry decorations

**Example:**
```
assets/images/items/
├── venue_banquet.jpg
├── venue_garden.jpg
├── decor_royal.jpg
├── decor_pastel.jpg
├── catering_buffet.jpg
└── ...
```

### 4. **Theme Preview Images** (Optional)
**Location:** `assets/images/themes/`

**What you need:**
- One representative image per theme
- **Size:** 400x300 pixels
- **Format:** JPG or PNG

**Example:**
```
assets/images/themes/
├── royal_preview.jpg
├── pastel_preview.jpg
├── neon_preview.jpg
└── ... (one per theme)
```

## Minimum Images Needed to See Results

**To see images in your app, you need at least:**

### Option 1: Quick Test (6 images)
- Add **6 moodboard images** in `assets/images/moodboards/royal/`
- Name them: `royal_1.jpg` through `royal_6.jpg`
- The app will use these when "Royal" theme is selected

### Option 2: Full Experience (60+ images)
- Add **6 images per theme** (10 themes × 6 = 60 images)
- This gives you complete moodboard coverage

## Where to Get Images

1. **Free Stock Photos:**
   - Unsplash.com (search "wedding decoration", "wedding stage")
   - Pexels.com (search "wedding")
   - Pixabay.com

2. **Pakistani Wedding Images:**
   - Search for "Pakistani wedding decoration"
   - "Mehndi decoration Pakistan"
   - "Barat stage decoration"
   - "Walima setup"

3. **Create Your Own:**
   - Take photos at local weddings
   - Use vendor portfolios
   - Create moodboard collages

## Image Naming Convention

**For Moodboards:**
- Format: `{theme}_{number}.jpg`
- Example: `royal_1.jpg`, `pastel_2.jpg`

**For Vendors:**
- Format: `vendor_{id}.jpg`
- Example: `vendor_1.jpg`, `vendor_2.jpg`

**For Items:**
- Format: `{category}_{name}.jpg`
- Example: `venue_banquet.jpg`, `decor_royal.jpg`

## Quick Start (Minimum Setup)

1. Create folder: `assets/images/moodboards/royal/`
2. Add 6 images named: `royal_1.jpg`, `royal_2.jpg`, ... `royal_6.jpg`
3. The code will automatically use these when Royal theme is selected

## Image Specifications

| Type | Recommended Size | Format | Aspect Ratio |
|------|-----------------|--------|--------------|
| Moodboard | 400×600px | JPG/PNG | 2:3 (portrait) |
| Vendor Profile | 200×200px | JPG/PNG | 1:1 (square) |
| Item Image | 300×300px | JPG/PNG | 1:1 (square) |
| Theme Preview | 400×300px | JPG/PNG | 4:3 (landscape) |

## File Size Tips

- Keep images under **500KB each** for faster loading
- Use JPG for photos (smaller file size)
- Use PNG for graphics with transparency
- Compress images before adding to app

## Testing Your Images

After adding images:
1. Run `flutter pub get` (if you updated pubspec.yaml)
2. Run `flutter run`
3. Navigate to Moodboard screen
4. Select a theme that has images
5. You should see your images!

---

**Note:** The app currently works without any images (uses placeholders). Adding images is optional but will make your app look professional!

