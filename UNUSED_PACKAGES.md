# 📦 Unused Packages Analysis

## Packages NOT Used in Project ❌

Based on code analysis, the following packages are installed but **NOT being used** in your project:

### 1. **lottie** (^3.3.1)
- **Status:** ❌ NOT USED
- **Reason:** 
  - No import statements found
  - `Launderer.json` file exists in assets but never loaded
  - No `Lottie.asset()` or `LottieBuilder` usage
- **Can Remove:** YES

### 2. **razorpay_flutter** (^1.4.0)
- **Status:** ❌ NOT USED (Commented out)
- **Reason:**
  - All razorpay code is commented out in `payment_view_model.dart`
  - Currently using different payment method
  - Only exists as commented legacy code
- **Can Remove:** YES (unless you plan to use it in future)

### 3. **permission_handler** (^12.0.1)
- **Status:** ❌ NOT USED
- **Reason:**
  - No import statements found
  - Not being used for location or any other permissions
  - Geolocator handles its own permissions
- **Can Remove:** YES

### 4. **flutter_local_notifications** (^18.0.1)
- **Status:** ❌ NOT USED
- **Reason:**
  - Just added but not integrated yet
  - Service created but not actually used
  - You decided not to use popup notifications
- **Can Remove:** YES

---

## Packages Being USED ✅

### Core Packages:
- ✅ **flutter** - Core framework
- ✅ **cupertino_icons** - iOS icons (used in pubspec, even if not explicitly imported)
- ✅ **provider** - State management (heavily used)

### UI Packages:
- ✅ **google_fonts** - Custom fonts (used in text_styles.dart)
- ✅ **smooth_page_indicator** - Page indicators (used in onboarding)
- ✅ **buttons_tabbar** - Tab bar widget (used in custom_tab_section.dart)
- ✅ **carousel_slider** - Image carousel (used in home screen)

### Firebase Packages:
- ✅ **firebase_core** - Firebase initialization
- ✅ **firebase_auth** - Authentication
- ✅ **cloud_firestore** - Database

### Location Packages:
- ✅ **google_maps_flutter** - Maps (used in pick_up_screen)
- ✅ **geolocator** - Location access (used in pick_up_screen)
- ✅ **geocoding** - Address conversion (used in pick_up_screen)

### Utility Packages:
- ✅ **intl** - Date formatting (heavily used)
- ✅ **shared_preferences** - Local storage (used in preference_helper.dart)
- ✅ **url_launcher** - Make phone calls (used in home screen)

---

## Recommended Actions

### Can Safely Remove:
```yaml
dependencies:
  # Remove these:
  # lottie: ^3.3.1                          # ❌ Not used
  # permission_handler: ^12.0.1              # ❌ Not used
  # flutter_local_notifications: ^18.0.1     # ❌ Not used
  # razorpay_flutter: ^1.4.0                 # ❌ Not used (commented code)
```

### Should Keep:
All other packages are actively being used in the project.

---

## How to Remove

1. **Edit pubspec.yaml** - Remove/comment out unused packages
2. **Run:** `flutter pub get`
3. **Clean build:** `flutter clean`
4. **Test app** to ensure everything still works

---

## Optional: Clean Up Unused Assets

You can also remove:
- `assets/lottie/Launderer.json` (if lottie package is removed)

---

## File Cleanup

After removing packages, you can also delete:
- `lib/Features/notification/service/notification_service.dart` (flutter_local_notifications wrapper, not used)

---

## Estimated Size Reduction

Removing these packages will:
- Reduce app size by ~2-5 MB
- Speed up build times
- Reduce dependency complexity
- Cleaner pubspec.yaml

---

## Summary

**Total Packages in pubspec.yaml:** 18
**Actually Used:** 14
**NOT Used:** 4 (lottie, razorpay_flutter, permission_handler, flutter_local_notifications)
**Removal Impact:** LOW (safe to remove)

