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
    
    packaging {
        jniLibs {
            // Handle duplicate native libraries (e.g., libonnxruntime.so)
            // Pick the first occurrence when duplicates are found
            pickFirsts += listOf("**/libonnxruntime.so")
        }
    }
}

flutter {
    source = "../.."
}

// Configure Cargokit to only build for Android 64-bit targets
// This prevents the "Unknown darwin target or platform" error
// by filtering out unsupported platforms before Cargokit processes them
afterEvaluate {
    // Configure Cargokit tasks directly - they are Exec tasks
    tasks.withType<org.gradle.api.tasks.Exec>().configureEach {
        if (name.contains("cargokit", ignoreCase = true)) {
            doFirst {
                val currentTargets = System.getenv("CARGOKIT_TARGET_PLATFORMS")
                if (currentTargets != null) {
                    // Filter to only supported Android 64-bit targets
                    val supportedTargets = currentTargets.split(",")
                        .filter { it == "android-arm64" || it == "android-x64" }
                        .joinToString(",")
                    
                    if (supportedTargets.isNotEmpty()) {
                        // Override the environment variable for this Exec task
                        environment("CARGOKIT_TARGET_PLATFORMS", supportedTargets)
                    }
                }
            }
        }
    }
}
