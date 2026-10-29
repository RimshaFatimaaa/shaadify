# Fix: Symlink Support Error on Windows

## Error Message
```
Building with plugins requires symlink support.
Please enable Developer Mode in your system settings.
```

## What This Means
This is a **normal Windows security feature**, not a code error. Flutter plugins need to create symbolic links during build, and Windows requires Developer Mode to allow this.

## Solution 1: Enable Developer Mode (Recommended) ✅

### Steps:
1. Open Windows Settings:
   - Press `Windows + I`
   - OR run: `start ms-settings:developers`

2. In Settings:
   - Go to **Privacy & Security** → **For developers**
   - OR search for "Developer Mode" in the search bar

3. Enable Developer Mode:
   - Toggle **"Developer Mode"** to **ON**
   - Click **"Yes"** if prompted
   - Wait for it to finish (may take 1-2 minutes)

4. Restart your IDE:
   - Close Android Studio/VS Code completely
   - Reopen it

5. Try building again:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## Solution 2: Run as Administrator (Alternative)

If you can't enable Developer Mode:

1. **Close Android Studio/VS Code**

2. **Right-click** on Android Studio/VS Code icon

3. Select **"Run as administrator"**

4. Open your project and try building again

**Note:** You'll need to run as administrator every time you build.

## Solution 3: Use WSL (Windows Subsystem for Linux)

If you have WSL installed:
- Build your Flutter app inside WSL
- No Developer Mode needed in WSL

## Verify It's Working

After enabling Developer Mode, run:
```bash
flutter doctor -v
```

You should see no symlink-related errors.

## Why This Happens

- Flutter plugins create symbolic links during build
- Windows restricts symlink creation for security
- Developer Mode allows symlinks without admin rights
- This is a **Windows security feature**, not a Flutter bug

## Still Having Issues?

1. Make sure you **restarted your IDE** after enabling Developer Mode
2. Try running `flutter clean` then `flutter pub get`
3. Check if your Windows account has proper permissions
4. Try running the IDE as administrator once to see if that helps

---

**This is completely normal and expected on Windows!** ✅

