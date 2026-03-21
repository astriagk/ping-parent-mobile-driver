// TODO: Add go_router to pubspec.yaml before implementing
// Required package: go_router: ^14.0.0
//
// GoRouter configuration + auth guard for the Driver app.
//
// Route structure (per Architecture.md):
//   /login           — standalone screen, no shell
//   /                — ShellRoute → AppShell (BottomNav + AppBar)
//     /drive         — location_emit feature (active drive screen)
//     /notifications — notifications feature
//
// Auth guard: global redirect checks SecureStorage for valid JWT.
// Unauthenticated users always redirect to /login.
//
// Deep links: FCM notification taps carry a route path; GoRouter navigates
// directly to the target screen on app open or foreground.
