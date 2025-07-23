# NGO Mobile Application

A Flutter-based mobile application for NGOs to connect volunteers with beneficiaries, featuring role-based access control and accessibility features.

## Features

- **Authentication System**: Secure sign-in/sign-up with Firebase
- **Role-Based Access**: Different interfaces for volunteers and beneficiaries
- **Accessibility Features**: Adjustable text sizes for better readability
- **Resource Management**: Resources for different beneficiary categories
- **Chat Support**: Built-in help/support chat functionality

## Getting Started

This project is built with Flutter. To get started:

1. Ensure you have Flutter installed on your system
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Set up Firebase for your project (see Firebase setup below)
5. Run the app using `flutter run`

### Firebase Setup

1. Create a new Firebase project
2. Add Android and iOS apps to your Firebase project
3. Download the configuration files and place them in the appropriate directories
4. Enable Email/Password authentication in Firebase Console

## Project Structure

- `lib/` - Main application code
  - `auth/` - Authentication screens and logic
  - `home/` - Main screens for different user roles
  - `resources/` - Resource data and screens
  - `chat/` - Chat functionality
  - `accessibility/` - Accessibility features
  - `widgets/` - Reusable UI components

## Dependencies

- `firebase_core`: ^2.15.1
- `firebase_auth`: ^4.9.0
- `cloud_firestore`: ^4.10.0
- `provider`: ^6.0.5
- `flutter_svg`: ^2.0.7

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
