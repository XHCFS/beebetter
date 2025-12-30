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
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
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

flutter {
    source = "../.."
}

// Read Flutter SDK path and engine version to construct embedding dependency version
val flutterSdkPath: String? = run {
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        val properties = java.util.Properties()
        localPropertiesFile.inputStream.use { properties.load(it) }
        properties.getProperty("flutter.sdk") ?: System.getenv("FLUTTER_ROOT")
    } else {
        System.getenv("FLUTTER_ROOT")
    }
}

val flutterEngineVersion: String? = run {
    if (flutterSdkPath != null) {
        val engineVersionFile = java.io.File("$flutterSdkPath/bin/internal/engine.version")
        if (engineVersionFile.exists()) {
            engineVersionFile.readText().trim()
        } else {
            null
        }
    } else {
        null
    }
}

dependencies {
    // Explicitly add Flutter embedding dependency
    // The Flutter Gradle plugin should add this automatically, but it's not working in CI
    // We add it explicitly to ensure FlutterActivity is available during compilation
    if (flutterEngineVersion != null) {
        // Use the engine version to construct the embedding version
        // Format: 1.0.0-<engine-version>
        val embeddingVersion = "1.0.0-$flutterEngineVersion"
        implementation("io.flutter:flutter_embedding_release:$embeddingVersion")
        println("Using Flutter embedding version: $embeddingVersion")
    } else {
        // If we can't get the engine version, log a warning
        // The Flutter Gradle plugin should still add the dependency, but if it doesn't,
        // this build will fail and we'll need to investigate further
        println("WARNING: Could not determine Flutter engine version. Flutter Gradle plugin should add embedding dependency.")
    }
    
    // Kotlin stdlib
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:2.1.0")
}
