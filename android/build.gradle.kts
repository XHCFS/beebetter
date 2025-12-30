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
        // Flutter hosted Maven repository (primary source for Flutter engine artifacts)
        // This is the official repository where Flutter publishes engine artifacts
        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
        }
        // Flutter engine artifacts repository (local cache, if available)
        // Note: This path may not exist in CI, so we rely on the hosted repository above
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
