# Eshara (إشارة)

<p align="center">
  <img src="path/to/your/logo.png" alt="Eshara Logo" width="150"/>
</p>

<p align="center">
  Bridging communication for the deaf and hard-of-hearing community through real-time sign language translation.
</p>

<p align="center">
  <a href="https://github.com/your-username/eshara/LICENSE"><img src="https://img.shields.io/github/license/your-username/eshara?style=for-the-badge" alt="License"></a>
  <a href="#"><img src="https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter" alt="Flutter Version"></a>
  <a href="#"><img src="https://img.shields.io/badge/platform-android%20%7C%20ios-green?style=for-the-badge" alt="Platform"></a>
</p>

---

## 📖 Table of Contents

- ✨ Features
- 🛠️ Tech Stack & Architecture
- 🚀 Getting Started
- 📚 Project Documentation
- 🌍 Localization
- 🤝 Contributing
- 📝 License

## ✨ Features

Eshara offers a comprehensive set of features to facilitate seamless communication:

- **Sign-to-Text Translation**: Real-time translation of sign language gestures into written text using the device's camera.
- **Text-to-Sign Translation**: Converts written text into animated sign language videos.
- **Comprehensive Dictionary**: A searchable library of sign language words and phrases, complete with video demonstrations and descriptions.
- **User Authentication**: Secure sign-up and login functionality for a personalized experience.
- **Word Request**: Users can request new signs to be added to the dictionary by recording and uploading a video.
- **User Profile Management**: Allows users to view and manage their account details.

## 🛠️ Tech Stack & Architecture

The application is built with a focus on scalability, maintainability, and performance.

### Core Technologies

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: flutter_bloc (BLoC Pattern)
- **Dependency Injection**: get_it
- **Networking**: dio for robust HTTP requests.
- **Local Storage**: shared_preferences for storing simple data like auth tokens.
- **Localization**: flutter_localizations with the `intl` package.

### Architecture: Clean Architecture (هيكل المشروع)

The project strictly follows the principles of **Clean Architecture**, which separates the code into distinct, independent layers. This promotes a modular, scalable, and highly testable codebase.

```
lib/
├── Core/
│   ├── di/                     # Dependency Injection (GetIt)
│   ├── Helper/                 # Shared widgets, theme, constants
│   └── ...
├── features/
│   └── <FeatureName>/          # Feature-based modularization
│       ├── Data/               # Data Layer
│       │   ├── datasources/    # Remote & Local Data Sources
│       │   ├── models/         # Data Transfer Objects (DTOs)
│       │   └── repositories/   # Repository Implementations
│       ├── Domain/             # Domain Layer
│       │   ├── entities/       # Core Business Objects
│       │   ├── repositories/   # Abstract Repository Contracts
│       │   └── usecases/       # Application-specific Business Rules
│       └── UI/ (or Presentation) # Presentation Layer
│           ├── bloc/           # BLoCs/Cubits for State Management
│           ├── Screens/        # Feature-specific pages
│           └── widgets/        # Reusable widgets for the feature
├── l10n/                       # Localization files
└── main.dart                   # Application entry point
```

- **Domain Layer**: The core of the application. It contains the business logic (use cases) and entities, and has no dependencies on any other layer.
- **Data Layer**: Responsible for data retrieval. It implements the repositories defined in the Domain layer and contains data sources (remote API, local database, etc.).
- **Presentation Layer (UI)**: The user-facing layer. It contains the Flutter widgets (Screens, Widgets) and uses BLoC to manage state and interact with the Domain layer via use cases.

### API Integration

The application communicates with a backend server via a RESTful API.

- **HTTP Client**: `dio` is configured as a singleton instance with a base URL and an interceptor.
- **Authentication**: The interceptor automatically attaches the JWT token (retrieved from `shared_preferences`) to the headers of authenticated requests.

### Video Handling

Video is a core component of the application for both displaying and capturing sign language.

- **Recording & Upload**: The app integrates with the device's camera to record videos and uses `dio` to upload them as `multipart/form-data`.
- **Playback**: A video player widget is used to stream and display sign language videos from the server.

## 🚀 Getting Started

Follow these instructions to get the project up and running on your local machine.

### Prerequisites

- **Flutter SDK**: Ensure you have the Flutter SDK installed. For installation instructions, see the official Flutter documentation.
- **IDE**: An IDE like Android Studio or VS Code with the Flutter plugin.

### Installation & Running

1.  **Clone the repository:**

    ```sh
    git clone https://github.com/your-username/eshara.git
    cd eshara
    ```

2.  **Install dependencies:**

    ```sh
    flutter pub get
    ```

3.  **Run the application:**
    ```sh
    flutter run
    ```

## 📚 Project Documentation

For a deeper understanding of the project's implementation, architecture, and conventions, please refer to our detailed documentation:

- **Architecture Overview**: A detailed guide to the Clean Architecture principles, folder structure, and data flow within the app.
- **State Management Strategy**: Explains our use of the BLoC pattern for managing state.
- **API Integration Guide**: Details on how the app communicates with the backend.
- **Contribution Guidelines**: How to contribute to the project, coding standards, and pull request process.

## 🌍 Localization

The application supports multiple languages to cater to a diverse user base.

- **Supported Languages**:
  - English (en)
  - Arabic (ar)
- **Implementation**: We use Flutter's built-in internationalization support (`flutter_localizations` and the `intl` package) to manage translations. All localized strings are located in the `lib/l10n` directory.

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.
