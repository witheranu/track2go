plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.track2go"
    compileSdk = flutter.compileSdkVersion

    // ✅ Explicitly specify the required NDK version to match plugin requirements
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.track2go"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase Core (required)
    implementation("com.google.firebase:firebase-analytics-ktx")

    // Firebase Authentication
    implementation("com.google.firebase:firebase-auth-ktx")

    // Firestore (for storing user/bus/location data)
    implementation("com.google.firebase:firebase-firestore-ktx")

    // Realtime Database (optional if you want faster syncing)
    implementation("com.google.firebase:firebase-database-ktx")

    // Maps & location logic are handled by Flutter packages (like geolocator), not here
}
