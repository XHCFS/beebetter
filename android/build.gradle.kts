// Read Flutter SDK path from local.properties or environment variable
val flutterSdkPath: String? = run {
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        val properties = java.util.Properties()
        localPropertiesFile.inputStream().use { properties.load(it) }
        properties.getProperty("flutter.sdk")
    } else {
        System.getenv("FLUTTER_ROOT")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        // Flutter engine artifacts repository (required to resolve io.flutter:flutter_embedding_*)
        if (flutterSdkPath != null) {
            maven {
                url = uri("${flutterSdkPath}/bin/cache/artifacts/engine/android")
            }
        }
        // Flutter hosted Maven repository (fallback)
        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
