# Chatty - Modern Chat Application

A beautiful, modern chat application built with Flutter featuring a completely redesigned UI/UX.

## ✨ New Modern UI Available!

**Your app now has a brand new, modern interface!** 🎉

### Quick Start (2 Minutes)

To use the new modern UI, make these 2 simple changes:

**File:** `lib/app/routes/app_pages.dart`

1. **Change the import:**
```dart
import '../modules/main/views/modern_main_view.dart';
```

2. **Update the route:**
```dart
GetPage(
  name: AppRoutes.dashboard,
  page: () => ModernMainView(),
  binding: MainBinding(),
```

# Chatty — Modern Chat Application

A beautiful, modern chat application built with Flutter. This README includes app details and screenshots located in `assets/ss`.

## 🚀 Project Overview
Chatty is a clean, mobile-first chat UI with modern design patterns, toggleable views, and a focus on UX polish.

## 🖥️ Key Screens
- Onboarding
- Chats (list & grid)
- Stories
- Feed
- Profile & Settings

## 🔧 Technologies
- Framework: Flutter
- State management: GetX (used in this project)

## 🎨 UI Highlights
- Modern, minimal design
- Smooth animations and transitions
- Responsive across common mobile sizes

## 🖼️ Screenshots
All screenshots are stored in `assets/ss`. Use these in the repo description or GitHub pages to showcase the app.

<table>
  <tr>
    <td><img src="/assets/ss/1.jpeg" width="280"></td>
    <td><img src="/assets/ss/2.jpeg" width="280"></td>
    <td><img src="/assets/ss/3.jpeg" width="280"></td>
    <td><img src="/assets/ss/4.jpeg" width="280"></td>
  </tr>
  <tr>
    <td><img src="/assets/ss/5.jpeg" width="280"></td>
    <td><img src="/assets/ss/6.jpeg" width="280"></td>
    <td><img src="/assets/ss/7.jpeg" width="280"></td>
    <td><img src="/assets/ss/8.jpeg" width="280"></td>
  </tr>
  <tr>
    <td><img src="/assets/ss/9.jpeg" width="280"></td>
    <td><img src="/assets/ss/10.jpeg" width="280"></td>
    <td><img src="/assets/ss/WhatsApp%20Image%202025-11-28%20at%2012.38.10%20AM.jpeg" width="280"></td>
    <td><img src="/assets/ss/WhatsApp%20Image%202025-11-28%20at%2012.47.20%20AM11.jpeg" width="280"></td>
  </tr>
</table>

> Tip: If GitHub doesn't render images due to special characters, rename files to simple names (e.g., `ss-01.png`) and update the paths here.

## 🛠️ Setup
```bash
git clone https://github.com/your-username/your-repo.git
cd chatty
flutter pub get
flutter run
```

## 📁 Where to find things
- Screenshots: `assets/ss/` (used above)
- Main entry: `lib/main.dart`
- Modern UI toggle: `lib/app/routes/app_pages.dart` (see docs in repo)

## 📧 Contact
If you want to reach out:
- Email: malikzuraiz1214@gmail.com
- GitHub: https://github.com/MalikZuraiz

---

If you'd like, I can also:
- Rename screenshot files to simpler names and update this README
- Add a dedicated `docs/` folder with a visual gallery page
