# API Integration Guide

## Overview
This project now includes a complete API integration setup for making HTTP requests to your backend.

## Setup Instructions

### 1. Update Base URL
Edit `lib/app/core/constants/api_constants.dart` and replace the base URL with your actual API endpoint:

```dart
static const String baseUrl = 'https://your-api-endpoint.com/api';
```

### 2. Install Dependencies
Run the following command to install the required packages:

```bash
flutter pub get
```

### 3. API Structure

#### Services Created:
- **ApiService** (`lib/app/data/services/api_service.dart`)
  - Handles all HTTP requests (GET, POST, PUT, DELETE)
  - Automatically includes authentication headers
  - Handles error responses

- **AuthService** (`lib/app/data/services/auth_service.dart`)
  - Manages authentication (register, login, logout)
  - Handles token management
  - Stores user data locally

- **StorageService** (`lib/app/data/services/storage_service.dart`)
  - Manages local storage using SharedPreferences
  - Stores authentication tokens
  - Stores user data

#### Constants:
- **ApiConstants** (`lib/app/core/constants/api_constants.dart`)
  - Contains all API endpoints
  - Defines request headers

## Usage Examples

### Registration
The `RegisterController` is already integrated with the API:

```dart
await _authService.register(user);
```

### Login
Create a `LoginController` and use:

```dart
final response = await _authService.login(email, password);
```

### Making Custom API Calls

```dart
// GET request
final data = await _apiService.get('/endpoint', requiresAuth: true);

// POST request
final response = await _apiService.post(
  '/endpoint',
  {'key': 'value'},
  requiresAuth: true
);

// PUT request
final updated = await _apiService.put(
  '/endpoint',
  {'key': 'value'},
  requiresAuth: true
);

// DELETE request
final deleted = await _apiService.delete('/endpoint', requiresAuth: true);
```

## Expected API Response Format

### Registration/Login Response:
```json
{
  "token": "your-jwt-token",
  "user": {
    "id": "user-id",
    "name": "John Doe",
    "email": "john@example.com"
  },
  "message": "Success message"
}
```

### Error Response:
```json
{
  "error": "Error message",
  "message": "Detailed error description"
}
```

## Features
- ✅ Automatic token management
- ✅ Local data persistence
- ✅ Error handling
- ✅ Network connectivity detection
- ✅ Authentication headers
- ✅ HTTP status code handling
- ✅ JSON encoding/decoding

## Next Steps
1. Update `ApiConstants.baseUrl` with your actual endpoint
2. Adjust API endpoints in `ApiConstants` to match your backend
3. Update response handling if your API format differs
4. Test the integration with your backend

## Troubleshooting
- If you get "No internet connection" error, check your device's network
- If you get "Unauthorized" error, check if the token is valid
- For other errors, check the console for detailed error messages
