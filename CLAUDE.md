# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TravelRates is a Flutter mobile application - a multi-currency converter designed for backpackers. It allows users to track multiple currencies simultaneously with offline support and automatic rate updates when connectivity is available.

## Development Commands

### Running the app
```bash
fvm flutter run
```

### Testing
```bash
# Run all tests
fvm flutter test

# Run a specific test file
fvm flutter test test/path/to/test_file.dart

# Run tests with coverage
fvm flutter test --coverage
```

### Code generation and analysis
```bash
fvm flutter analyze
fvm flutter pub get
fvm dart run build_runner build  # For json_serializable code generation
```

### Localization
Localizations are auto-generated on `flutter pub get`. Access via `context.l10n.<name>`.

To generate country/currency localizations:
```bash
node tools/generate_localizations.js
```

### Icons and splash screen
```bash
fvm dart run flutter_launcher_icons
fvm dart run flutter_native_splash:create
```

### Building releases
Uses flutter_distributor:
```bash
source .env
flutter_distributor release --name internal

# Individual platforms:
flutter_distributor release --name internal --jobs release-android
flutter_distributor release --name internal --jobs release-ios
```

## Architecture

### State Management
The app uses a **hybrid state management approach**:

1. **StateContainer** (InheritedWidget): Legacy global state container that manages:
   - `AppState`: Core application state (conversion model, available currencies, countries)
   - Currency operations (add, remove, reorder)
   - State persistence via `StatePersistence`
   - Accessed via `StateContainer.of(context)`

2. **Riverpod**: Modern state management for:
   - Feature-specific state (e.g., `themeBrightnessNotifierProvider`)
   - Dependency injection (providers for services, app state)
   - Located in `use_cases/*/state/` directories

### Application Structure

**Entry Point** (`main.dart`):
- Initializes services: `LocalStorage`, `RatesApi`, `StatePersistence`, `SharedPreferences`
- Wraps app in `StateContainer` and `ProviderScope`
- Sets up Riverpod provider overrides

**App Root** (`app_root.dart`):
- Initializes Firebase Analytics
- Loads online currency rates via `RatesLoader`
- Configures theme (light/dark mode via Riverpod)
- Sets up routing with go_router
- Provides localized data via `LocalizedDataProvider`

**Routing**:
- Uses `go_router` package
- Routes defined in `lib/routing/router.dart`:
  - `/` - Home screen (currency converter)
  - `/edit` - Edit currencies screen
  - `/about` - About screen

### Feature Organization (Use Cases)

Features are organized by use case in `lib/use_cases/`:

```
use_cases/
├── home/              # Main conversion screen
│   ├── ui/           # Screen components
│   ├── state/        # Riverpod providers
│   └── services/     # Business logic
├── edit_currencies/   # Currency selection/management
├── currency_selection/
├── dark_mode/         # Theme management
├── about/             # App information
├── compare_amount/
└── review_feature/    # App review prompts
```

Each use case contains:
- `ui/` - Flutter widgets and screens
- `state/` - Riverpod providers (if needed)
- `services/` - Business logic and utilities

### Core Services (`lib/services/`)

- **rates_api.dart**: Fetches live currency rates from API
- **rates_loader.dart**: Manages loading rates from API or local storage
- **currency_repository.dart**: Manages available currencies and their rates
- **state_persistence.dart**: Persists app state to local storage
- **local_storage.dart**: File-based storage wrapper
- **preferences.dart**: Shared preferences wrapper
- **logger.dart**: Logging and analytics integration

### Data Models (`lib/model/`)

- **conversion_model.dart**: Current conversion state (amount, currency, selected currencies)
- **currency.dart**: Currency definition
- **currency_rate.dart**: Exchange rate data
- **country.dart**: Country data with flag assets
- **api_configuration.dart**: API credentials (loaded from assets)

### Localization

- Uses Flutter's intl package with ARB files in `lib/l10n/`
- Template file: `app_en.arb`
- Supported locales: English, Swedish, Japanese
- Country/currency names generated via Node.js script from JSON files
- Access via extension: `context.l10n.keyName`

## Important Configuration

### API Configuration
API tokens must be in `assets/data/apiConfiguration.json`:
```json
{
  "apiToken": "token",
  "apiUrl": "http://urlpath.com"
}
```

### Asset Structure
- Flag images: `assets/images/flags/` and `assets/images/flags/2x/`
- Data files: `assets/data/` (currencies.json, countries.json, rates.json)
- Animations: `assets/animations/` (Rive files)

## Testing

Tests follow the same structure as source code. Test files are located in `test/` with the same directory structure as `lib/`.

Key test utilities:
- mockito for mocking
- flutter_test for widget/unit testing
- Coverage reports generated on merge to master at: https://greycastle.gitlab.io/travel-rates/coverage/
