pluginManagement {
    val flutterSdkPath: String? =
        run {
            val localPropertiesFile = file("local.properties")
            if (localPropertiesFile.exists()) {
                val properties = java.util.Properties()
                localPropertiesFile.inputStream().use { properties.load(it) }
                properties.getProperty("flutter.sdk") ?: System.getenv("FLUTTER_ROOT")
            } else {
                System.getenv("FLUTTER_ROOT")
            }
        }

    if (flutterSdkPath != null) {
        includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
    } else {
        throw GradleException("Flutter SDK not found. Please set flutter.sdk in local.properties or FLUTTER_ROOT environment variable.")
    }

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        // Flutter hosted Maven repository (primary source)
        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
        }
        // Flutter engine artifacts repository (local cache, if available)
        if (flutterSdkPath != null) {
            val localArtifactsPath = "${flutterSdkPath}/bin/cache/artifacts/engine/android"
            val localArtifactsDir = java.io.File(localArtifactsPath)
            if (localArtifactsDir.exists() && localArtifactsDir.isDirectory) {
                maven {
                    url = uri(localArtifactsPath)
                }
            }
        }
    }
}

plugins {
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
}

include(":app")
