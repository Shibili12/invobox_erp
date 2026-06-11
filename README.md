# INVOBOX ERP — Flutter Windows App

A desktop ERP application built with Flutter for Windows, featuring:
- Login screen
- Sales Invoice List with filter & pagination
- New Sales Invoice creation with line items

---

## Project Structure (MVC)

```
lib/
├── main.dart                          ← App entry point & routing
├── core/
│   ├── app_theme.dart                 ← Colors, ThemeData
│   └── app_routes.dart                ← Route name constants
├── models/
│   ├── login_model.dart               ← Login data model
│   └── sales_invoice_model.dart       ← Invoice & line item models
├── controllers/
│   ├── login_controller.dart          ← Login state & API logic
│   ├── invoice_list_controller.dart   ← List filter, pagination
│   └── new_sales_controller.dart      ← New invoice state
├── views/
│   ├── login/
│   │   └── login_view.dart            ← Login screen UI
│   ├── invoice_list/
│   │   └── invoice_list_view.dart     ← Invoice list screen UI
│   └── new_sales/
│       └── new_sales_view.dart        ← New sales screen UI
└── widgets/
    └── shared_widgets.dart            ← Reusable widgets
```

---

## Prerequisites

Since you have Android/iOS Flutter experience, Windows requires one extra tool:

### 1. Enable Windows desktop support
Open a terminal and run:
```bash
flutter config --enable-windows-desktop
```

### 2. Install Visual Studio (required for Windows builds)
Download **Visual Studio 2022** (Community edition is free):
https://visualstudio.microsoft.com/downloads/

During installation, select these workloads:
- ✅ **Desktop development with C++**
- ✅ **Windows 10/11 SDK**

### 3. Verify your setup
```bash
flutter doctor
```
You should see ✅ next to "Windows Version" and "Visual Studio".

---

## Getting Started

### Clone / copy the project, then:

```bash
# Step 1 — Install dependencies
flutter pub get

# Step 2 — Run on Windows desktop
flutter run -d windows

# Step 3 — Build a release .exe
flutter build windows --release
```

The release `.exe` will be at:
```
build/windows/x64/runner/Release/invobox_erp.exe
```

---

## Key Differences: Windows vs Android/iOS

| Topic | Android/iOS | Windows |
|-------|-------------|---------|
| Build tool | Gradle / Xcode | Visual Studio (CMake) |
| Entry point | same `main.dart` | same `main.dart` |
| Window size | device screen | set via `window_manager` package |
| Navigation | push/pop | same Navigator API |
| Keyboard | virtual | physical — add shortcuts |
| Hover states | not needed | use `MouseRegion` / `InkWell` |
| Title bar | OS native | custom (see `AppTitleBar` widget) |

---

## Optional: Set a fixed window size

Add `window_manager: ^0.3.7` to `pubspec.yaml`, then in `main.dart`:

```dart
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 800),
    minimumSize: Size(1024, 600),
    center: true,
    title: 'INVOBOX ERP',
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const InvoboxApp());
}
```

---

## Connecting to a Real API

The controllers have placeholder async methods. Replace them with your HTTP calls:

```dart
// In login_controller.dart — replace the Future.delayed with:
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> login() async {
  _status = LoginStatus.loading;
  notifyListeners();
  try {
    final res = await http.post(
      Uri.parse('https://$_domain/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );
    if (res.statusCode == 200) {
      _status = LoginStatus.success;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid credentials';
      _status = LoginStatus.error;
      notifyListeners();
      return false;
    }
  } catch (e) {
    _errorMessage = 'Connection failed: $e';
    _status = LoginStatus.error;
    notifyListeners();
    return false;
  }
}
```

Add `http: ^1.2.0` to `pubspec.yaml` for HTTP support.

---

## State Management

This project uses **Provider** (same as many Flutter apps).

Each screen gets its own `ChangeNotifier` controller:
- `context.watch<LoginController>()` — rebuilds on changes
- `context.read<LoginController>()` — one-time read (in callbacks)

---

## Screens Summary

### Screen 1 — Login (`/`)
- Username + password fields
- Domain badge with edit icon
- Remember me checkbox
- Login / Exit buttons

### Screen 2 — Invoice List (`/invoice-list`)
- Filter by: Sales ID, Invoice No, Customer Name, Date range
- Sortable data table with pagination (58 pages demo)
- Edit ✏️ and Print 🖨️ actions per row

### Screen 3 — New Sales (`/new-sales`)
- Header fields: date, time, customer, tax type, payment mode
- Dynamic line items table (add/remove rows, auto-calculates VAT at 15%)
- Totals bar: Qty, Items, Gross, VAT, Net
- Save (F12), Import, Cancel, Close buttons

---

## Troubleshooting

**`flutter doctor` shows Visual Studio missing**
→ Install Visual Studio 2022 with "Desktop development with C++" workload.

**`flutter run -d windows` says no devices**
→ Run `flutter config --enable-windows-desktop` first.

**Build error: CMake not found**
→ Visual Studio was installed without the C++ workload. Re-run the installer and add it.

**App window is too small**
→ Add the `window_manager` package (see above) to set a minimum size.

---

## Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1      # State management
  intl: ^0.18.1         # Date formatting
  google_fonts: ^6.1.0  # Optional typography
```

---

## App Icon Setup

The icon is already pre-generated for all platforms inside this project:

| Platform | Location | Format |
|----------|----------|--------|
| Windows  | `windows/runner/resources/app_icon.ico` | ICO (16–256px) |
| macOS    | `macos/Runner/Assets.xcassets/AppIcon.appiconset/` | PNG set |
| Android  | `android/app/src/main/res/mipmap-*/ic_launcher.png` | PNG set |
| iOS      | `ios/Runner/Assets.xcassets/AppIcon.appiconset/` | PNG set |

### To regenerate icons from a new image

1. Replace `assets/icon.png` with your new 1024×1024 PNG
2. Run:
```bash
flutter pub get
dart run flutter_launcher_icons
```
This will auto-regenerate icons for all platforms.
