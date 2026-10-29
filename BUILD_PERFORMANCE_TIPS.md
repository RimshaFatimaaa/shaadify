# Build Performance Tips for Shaadify

## 🚨 CRITICAL: Move Project Out of OneDrive

**Your project is currently in OneDrive, which is causing major slowdowns!**

### Steps to Fix:
1. **Close Android Studio/VS Code completely**
2. **Move the project folder** from:
   ```
   C:\Users\rimsha\OneDrive\Desktop\App_Dev\shaadify
   ```
   To a local folder like:
   ```
   C:\Dev\shaadify
   ```
   or
   ```
   C:\Projects\shaadify
   ```

3. **Open the project from the new location**
4. **Run `flutter pub get`** in the new location

## Other Performance Tips:

### 1. Use Gradle Daemon (Already configured)
- Gradle daemon is now enabled in `gradle.properties`

### 2. Increase Build Speed
```bash
# Use this command for faster builds:
flutter run --release

# Or for debug with optimizations:
flutter run --profile
```

### 3. Exclude Build Folders from Antivirus
Add these folders to your antivirus exclusions:
- `build/`
- `.dart_tool/`
- `android/.gradle/`
- `android/app/build/`

### 4. Use an Emulator for Development
- Emulators are often faster for initial testing
- Test on real device only when needed

### 5. Check System Resources
- Close unnecessary applications
- Ensure at least 8GB RAM available
- Close browser tabs and other heavy apps

### 6. Network Issues
If downloads are slow:
- Check internet connection
- Consider using a VPN if behind a firewall
- Gradle dependencies download on first build

## Expected Build Times (After Fixes):

- **First build**: 3-5 minutes
- **Subsequent builds**: 1-2 minutes
- **Hot reload**: 1-3 seconds
- **Hot restart**: 5-10 seconds

## If Still Slow After Moving:

1. **Check Gradle version**:
   ```bash
   cd android
   ./gradlew --version
   ```

2. **Invalidate caches**:
   - In Android Studio: File → Invalidate Caches / Restart
   - Or: `flutter clean && flutter pub get`

3. **Check for locked files**:
   - Close all IDEs
   - Close any running Flutter processes
   - Restart computer if needed

4. **Monitor build process**:
   ```bash
   flutter run -v
   ```
   This shows detailed output to identify bottlenecks.

