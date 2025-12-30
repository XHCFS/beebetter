pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        // Flutter hosted Maven repository (primary source)
        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
        }
        // Flutter engine artifacts repository (local cache, if available)
        val localArtifactsPath = "${flutterSdkPath}/bin/cache/artifacts/engine/android"
        val localArtifactsDir = java.io.File(localArtifactsPath)
        if (localArtifactsDir.exists() && localArtifactsDir.isDirectory) {
            maven {
                url = uri(localArtifactsPath)
            }
        }
    }
}

plugins {
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
