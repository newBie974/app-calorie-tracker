# Authentication Implementation

This document describes the Supabase authentication implementation for the CalorieTracker app.

## Architecture

The authentication system follows clean architecture principles with the following layers:

### 1. Data Layer

- **Models**: `UserModel`, `AuthResult`, `SignInRequest`, `SignUpRequest`
- **Repository**: `SupabaseAuthRepository` - Implements `AuthRepository` interface
- **Data Source**: Supabase Flutter SDK

### 2. Domain Layer

- **Use Cases**:
  - `SignInUseCase` - Handle user sign in
  - `SignUpUseCase` - Handle user registration
  - `SignOutUseCase` - Handle user sign out
  - `GetCurrentUserUseCase` - Get current authenticated user
  - `ResetPasswordUseCase` - Handle password reset

### 3. Presentation Layer

- **Service**: `AuthService` - Coordinates all authentication operations
- **Widgets**:
  - `AuthGuard` - Route protection based on authentication state
  - `AuthStateMixin` - Provides authentication state to widgets
  - Updated login/register forms with Supabase integration

## Features Implemented

### ✅ User Registration

- Email and password validation
- Full name collection
- Password confirmation
- Terms and conditions acceptance
- Real-time form validation with error messages

### ✅ User Sign In

- Email and password authentication
- Form validation
- Error handling with user-friendly messages

### ✅ Password Reset

- Email-based password reset
- Secure link generation via Supabase
- User-friendly success/error states

### ✅ Authentication State Management

- Automatic authentication state detection
- Persistent sessions
- Real-time state updates across the app

### ✅ Route Protection

- `AuthGuard` widget automatically redirects based on auth state
- Authenticated users see main app
- Unauthenticated users see login/register screens

## Configuration

### Environment Variables

Update `env.json` with your Supabase credentials:

```json
{
  "SUPABASE_URL": "your-supabase-url",
  "SUPABASE_ANON_KEY": "your-supabase-anon-key"
}
```

### Supabase Setup

1. Create a new Supabase project
2. Enable email authentication in Authentication > Settings
3. Configure email templates if needed
4. Set up Row Level Security (RLS) policies for your tables

## Usage

### Basic Authentication Flow

```dart
// Get authentication service
final authService = AuthDI.authService;

// Sign in
final signInRequest = SignInRequest(
  email: 'user@example.com',
  password: 'password123',
);
final result = await authService.signInWithEmail(signInRequest);

// Sign up
final signUpRequest = SignUpRequest(
  fullName: 'John Doe',
  email: 'user@example.com',
  password: 'password123',
  confirmPassword: 'password123',
);
final result = await authService.signUpWithEmail(signUpRequest);

// Sign out
await authService.signOut();

// Reset password
await authService.resetPassword('user@example.com');
```

### Using AuthStateMixin

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with AuthStateMixin {
  @override
  Widget build(BuildContext context) {
    if (isAuthenticated) {
      return Text('Welcome ${currentUser?.fullName}');
    } else {
      return Text('Please sign in');
    }
  }
}
```

## Error Handling

The system provides comprehensive error handling with:

- User-friendly French error messages
- Network error detection
- Validation error feedback
- Supabase-specific error mapping

## Security Features

- Password strength validation
- Email format validation
- Secure session management
- Automatic token refresh
- CSRF protection via Supabase

## Testing

The architecture supports easy testing with:

- Dependency injection for mocking
- Separated concerns for unit testing
- Interface-based repository pattern

## Future Enhancements

- Social login (Google, Apple)
- Two-factor authentication
- Biometric authentication
- Remember me functionality
- Account verification flow
