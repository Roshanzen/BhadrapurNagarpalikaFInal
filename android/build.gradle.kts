// Project-level build.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

buildscript {
    repositories {
        google()  // Make sure this is present
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.3") // Ensure you're using the latest version
        classpath("com.android.tools.build:gradle:7.0.4") // Specify the appropriate Android Gradle plugin version
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.5.31") // Add Kotlin plugin dependency
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
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
