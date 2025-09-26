# Environment Setup Guide

This project uses environment variables to securely store sensitive configuration data like API keys.

## Setup Instructions

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Environment Configuration
1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit the `.env` file with your actual Firebase configuration values:
   ```env
   # Firebase Configuration
   FIREBASE_ANDROID_API_KEY=your_android_api_key_here
   FIREBASE_IOS_API_KEY=your_ios_api_key_here
   FIREBASE_PROJECT_ID=your_project_id_here
   FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id_here
   FIREBASE_STORAGE_BUCKET=your_storage_bucket_here
   FIREBASE_ANDROID_APP_ID=your_android_app_id_here
   FIREBASE_IOS_APP_ID=your_ios_app_id_here
   FIREBASE_IOS_BUNDLE_ID=your_ios_bundle_id_here
   ```

### 3. Firebase Configuration Files
You'll also need to add the Firebase configuration files:
- `android/app/google-services.json` (for Android)
- `ios/Runner/GoogleService-Info.plist` (for iOS)

These files are automatically ignored by git for security reasons.

## Security Notes

- **Never commit the `.env` file** - it contains sensitive API keys
- **Never commit Firebase configuration files** - they contain sensitive data
- The `.env.example` file shows the required format without sensitive data
- All sensitive files are listed in `.gitignore`

## Getting Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to Project Settings > General
4. Scroll down to "Your apps" section
5. Download the configuration files for your platforms
6. Extract the values from these files to populate your `.env` file

## Troubleshooting

If you see "Firebase not configured" messages:
1. Ensure your `.env` file exists and contains valid values
2. Check that the Firebase configuration files are in the correct locations
3. Verify that all environment variable names match exactly (case-sensitive)
