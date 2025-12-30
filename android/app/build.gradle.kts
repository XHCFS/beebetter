import java.util.Properties
import java.io.File

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.beebetter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.beebetter"
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

// Read Flutter SDK path from local.properties
val localPropertiesFile = File(rootProject.projectDir, "local.properties")
val properties = Properties()
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { properties.load(it) }
}
val flutterSdkPath = properties.getProperty("flutter.sdk") ?: System.getenv("FLUTTER_ROOT")

// Read engine version from Flutter SDK
val embeddingVersion = if (flutterSdkPath != null) {
    val engineVersionFile = File("$flutterSdkPath/bin/internal/engine.version")
    if (engineVersionFile.exists()) {
        engineVersionFile.readText().trim()
    } else {
        "1.0.0" // fallback
    }
} else {
    "1.0.0" // fallback
}

dependencies {
    // Explicitly add Flutter embedding dependency
    implementation("io.flutter:flutter_embedding_release:$embeddingVersion")
}

flutter {
    source = "../.."
}
