# Library Lending System — Flutter Mobile

Flutter Mobile (Android) frontend for the Library Lending System, built as part of a Full-Stack AI Hackathon. **This repo currently reflects Round 1 functionality only (Books: view, add, detail) — Round 2 (search/filter/edit) and Round 3 (Members) were not ported here due to time constraints. See Known Limitations.**

**Stack:** Flutter (Android target), `http` package

---

## Setup Instructions

### Prerequisites
- Flutter SDK installed with Android toolchain configured
- An Android device (physical or emulator) — this project was developed and tested against a **physical Android device** over USB, not an emulator
- The backend API running locally, with both the API host machine and the Android device on the **same WiFi network**

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Configure the API base URL
`lib/services/api_service.dart` uses the development machine's local network IP (not `localhost` or the `10.0.2.2` emulator alias, since this was tested on a physical device):
```dart
static const String baseUrl = 'http://<your-pc-local-ip>:3000/api/books';
```
Find your PC's local IP via `ipconfig` (Windows) and update this constant to match your own network before running.

### 3. Enable cleartext (HTTP, non-HTTPS) traffic
Android 9+ blocks plain HTTP by default. `android/app/src/main/AndroidManifest.xml` includes `android:usesCleartextTraffic="true"` on the `<application>` tag to allow local development against a non-HTTPS API.

### 4. Run
```bash
flutter run
```
Select your connected device if prompted.

---

## Project Structure

```
lib/
├── models/book.dart
├── services/api_service.dart     # baseUrl differs from the Web repo — see above
├── screens/
│   ├── book_list_screen.dart
│   ├── add_book_screen.dart
│   └── book_detail_screen.dart
└── main.dart
```

---

## Functionality Implemented

- View book list (pull-to-refresh supported).
- Add a book, with client-side validation mirroring server rules and server error messages surfaced in the UI.
- View book details.

This matches the Round 1 requirement scope only.

---

## Testing Performed

Build was configured and `flutter run` was initiated against a physical Android device (Gradle build in progress at time of submission); full manual click-through testing (list → add → detail flow) on-device was not completed and confirmed before the round deadline. The same code (model, service logic, screens) is confirmed working in the Flutter Web repo, which shares the same source structure and was fully tested there.

---

## Known Limitations

1. **Round 2 features (search, filter, edit, duplicate-prevention UI) are not present in this repo.** They were built and tested in the Web repo only, due to time constraints — the project's prioritization was backend correctness and Web UI first, with Mobile porting deprioritized when time ran short.
2. **Round 3 features (Members) are not present in this repo**, for the same reason.
3. **On-device build/run was not fully confirmed working end-to-end before submission** — the Gradle build was in progress; earlier `flutter doctor` output flagged an incomplete Android toolchain (SDK/build-tools) that may or may not have affected the final build. This should be verified and, if needed, fixed as a first follow-up item.
4. Base URL is hardcoded to a specific local network IP, which will need updating for any other development machine/network.

---

## How AI Was Used

Claude was used as a mentor/guide throughout: explaining core Flutter/Dart concepts (StatefulWidget lifecycle, FutureBuilder, controller disposal) as the developer wrote the original screens (shared codebase with the Web repo), and specifically helping troubleshoot Android/Flutter environment setup — diagnosing an incomplete Android toolchain via `flutter doctor`, walking through physical-device vs emulator networking differences (`10.0.2.2` vs local network IP vs `localhost`), and resolving a project-scaffolding folder-nesting issue during `flutter create`. Given severe time constraints in the final rounds, effort was prioritized toward the API, Web UI, and backend correctness (Members, Copies, database migration) over completing and verifying the Mobile build — this is reflected honestly above rather than claiming untested functionality works.