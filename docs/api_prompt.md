# API Integration Prompt Guide

Use this document to define new API endpoints. An AI agent will use this information to generate all necessary integration code following the project's existing patterns.

---

## Project Architecture Summary

This project follows a **Service-Provider-Model** pattern:

```
lib/api/
├── endpoints.dart              # URL definitions
├── models/                     # Response & Request models
├── services/                   # API service classes
└── interfaces/                 # Service contracts

lib/provider/
└── app_pages_providers/        # State management with ChangeNotifier
```

**Key Patterns:**

- JSON field mapping: API uses `snake_case`, Dart models use `camelCase`
- MongoDB ObjectId: mapped from `_id` to `id`
- All responses have: `success`, `data`, `message`, `error` fields
- Services use `ApiClient` for HTTP requests with automatic auth token injection
- Providers call services and manage UI state with `notifyListeners()`

---

## API Definition Template

Copy and fill this template for each new endpoint:

```yaml
ENDPOINT_NAME:
HTTP_METHOD: GET | POST | PUT | PATCH | DELETE
URL_PATH:
REQUIRES_AUTH: true | false

URL_PARAMS:

REQUEST_PAYLOAD:

RESPONSE_PAYLOAD:

SUCCESS_RESPONSE_EXAMPLE:

ERROR_RESPONSE_EXAMPLE:

SERVICE_FILE: existing:<name> | new:<name>
PROVIDER_FILE: existing:<name> | new:<name>

NOTES:
```

---

## Files to Generate/Update

When processing an API definition, the AI should:

1. **Endpoint** (`lib/api/endpoints.dart`)

   - Add new endpoint URL constant or static method

2. **Response Model** (`lib/api/models/<name>_response.dart`)

   - Create response class with `fromJson()` factory
   - Create nested model classes if needed

3. **Request Model** (`lib/api/models/<name>_request.dart`) - if POST/PUT/PATCH

   - Create request class with `toJson()` method
   - Only include non-null optional fields

4. **Service Interface** (`lib/api/interfaces/<name>_service_interface.dart`)

   - Add method signature or create new interface

5. **Service** (`lib/api/services/<name>_service.dart`)

   - Implement the API call method
   - Use `_handleMutationResponse()` for POST/PUT/PATCH/DELETE

6. **Provider** (`lib/provider/app_pages_providers/<name>_provider.dart`)
   - Add state variables, loading flags
   - Implement fetch/create/update methods
   - Call `notifyListeners()` after state changes

---

## Code Generation Patterns

### Endpoint Definition

```dart
// Static URL
static const String myStudents = '$baseUrl/students/my-students';

// Dynamic URL with parameter
static String updateStudent(String id) => '$baseUrl/students/$id';
```

### Response Model

```dart
class DriverListResponse {
  final bool success;
  final List<Driver> data;
  final String? message;

  DriverListResponse({required this.success, required this.data, this.message});

  factory DriverListResponse.fromJson(Map<String, dynamic> json) {
    return DriverListResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => Driver.fromJson(e)).toList()
          : [],
      message: json['message'],
    );
  }
}
```

### Service Method

```dart
// GET request
Future<DriverListResponse> getAssignedDrivers() async {
  final response = await _apiClient.get(Endpoints.assignedDrivers);
  return DriverListResponse.fromJson(jsonDecode(response.body));
}

// POST request
Future<Map<String, dynamic>> assignDriver(Map<String, dynamic> data) async {
  final response = await _apiClient.post(
    Endpoints.assignDriver,
    headers: _jsonHeaders,
    body: jsonEncode(data),
  );
  return _handleMutationResponse(
    response, 'Driver assigned successfully', 'Failed to assign driver'
  );
}
```

### Provider Method

```dart
List<Driver> driverList = [];
bool isLoading = false;
String? errorMessage;

Future<void> fetchDrivers() async {
  isLoading = true;
  errorMessage = null;
  notifyListeners();

  try {
    final driverService = DriverService(ApiClient());
    final response = await driverService.getAssignedDrivers();

    if (response.success) {
      driverList = response.data;
    } else {
      errorMessage = response.message ?? 'Failed to fetch drivers';
    }
  } catch (e) {
    errorMessage = 'An error occurred. Please try again.';
  }

  isLoading = false;
  notifyListeners();
}
```

---

## Usage in Screens

### 1. Register Provider in main.dart

```dart
MultiProvider(
  providers: [
    // ... existing providers
    ChangeNotifierProvider(create: (_) => DriverProvider()),
  ],
  child: MyApp(),
)
```

### 2. Screen with Consumer Pattern

```dart
class DriverListScreen extends StatelessWidget {
  const DriverListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(
      builder: (context, driverCtrl, child) {
        return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => driverCtrl.onInit()),
          child: Scaffold(
            appBar: CommonAppBarLayout1(title: 'Drivers'),
            body: driverCtrl.isLoading
                ? const LoadingSkeleton()
                : driverCtrl.errorMessage != null
                    ? CommonErrorState(
                        title: appFonts.somethingWentWrong,
                        description: driverCtrl.errorMessage!,
                        onButtonTap: () => driverCtrl.fetchDrivers(),
                      )
                    : driverCtrl.driverList.isEmpty
                        ? CommonEmptyState(mainText: 'No drivers found')
                        : ListView.builder(
                            itemCount: driverCtrl.driverList.length,
                            itemBuilder: (context, index) {
                              final driver = driverCtrl.driverList[index];
                              return _buildDriverCard(context, driver);
                            },
                          ),
          ),
        );
      },
    );
  }
}
```

### 3. Access Provider Without Rebuild

```dart
// Read once (doesn't listen for changes)
final driverCtrl = context.read<DriverProvider>();
driverCtrl.fetchDrivers();

// Watch for changes (rebuilds on change)
final driverList = context.watch<DriverProvider>().driverList;
```

### 4. Call Provider Method on Button Tap

```dart
ElevatedButton(
  onPressed: () async {
    final provider = context.read<DriverProvider>();
    final success = await provider.assignDriver(driverId, studentId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Driver assigned successfully')),
      );
    }
  },
  child: Text('Assign Driver'),
)
```

### 5. Navigate and Refresh on Return

```dart
onTap: () async {
  await route.pushNamed(context, routeName.editDriverScreen);
  // Refresh list when returning
  context.read<DriverProvider>().fetchDrivers();
}
```

---

## Your API Definitions Below

```yaml
ENDPOINT_NAME:
HTTP_METHOD:
URL_PATH:
REQUIRES_AUTH:

URL_PARAMS:

REQUEST_PAYLOAD:

RESPONSE_PAYLOAD:

SUCCESS_RESPONSE_EXAMPLE:

ERROR_RESPONSE_EXAMPLE:

SERVICE_FILE:
PROVIDER_FILE:

NOTES:
```
