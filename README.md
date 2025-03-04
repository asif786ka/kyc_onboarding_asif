# Multi-Region KYC Onboarding System

This monorepo contains both the KYC Library and the Main Application that demonstrates its usage. The system is designed to handle Know Your Customer (KYC) onboarding across multiple regions with different regulatory requirements.

## Project Structure

```
kyc_monorepo/
├── apps/
│   ├── main_app/                   # Primary app using KYC Library
│   ├── kyc_library/                # Standalone KYC Library Package
├── packages/                       # Shared Utility Packages
│   ├── api_services/
│   ├── ui_components/
```

## Setup Instructions

1. Clone the repository:
```bash
git clone https://github.com/yourusername/kyc_monorepo.git
cd kyc_monorepo
```

2. Set up the KYC Library:
```bash
cd apps/kyc_library/kyc_region_library
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Set up the Main App:
```bash
cd ../../main_app/main_app
flutter pub get
```

4. Run the Main App:
```bash
flutter run
```

## Features

- Multi-region support (US, EU, UK, UAE)
- Dynamic region-based API configuration
- Secure document storage
- Step-by-step KYC process
- BLoC pattern for state management
- Clean Architecture implementation

## Library Usage

To use the KYC Library in your Flutter application:

1. Add the dependency to your pubspec.yaml:
```yaml
dependencies:
  kyc_region_library:
    path: path/to/kyc_library
```

2. Import and use the KYC screen:
```dart
import 'package:kyc_region_library/kyc_region_library.dart';

// Use the KYC screen with a specific region
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => KYCScreen(region: 'US'),
  ),
);
```

## Architecture

The project follows Clean Architecture principles with the following layers:

1. Presentation Layer (UI)
   - Screens and widgets
   - BLoC for state management

2. Domain Layer
   - Use cases
   - Entity models
   - Repository interfaces

3. Data Layer
   - API implementation
   - Local storage
   - Repository implementations

## Contributing

1. Create a feature branch:
```bash
git checkout -b feature/your-feature-name
```

2. Make your changes and commit:
```bash
git add .
git commit -m "Description of changes"
```

3. Push and create a pull request:
```bash
git push origin feature/your-feature-name
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For any questions or support, please contact:
- Email: asif786ka@gmail.com
# kyc_onboarding_asif
