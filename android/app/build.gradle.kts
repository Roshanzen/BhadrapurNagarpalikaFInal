// App-level build.gradle.kts (in android/app/)

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Add this to apply Google services plugin
}

android {
    namespace = "com.example.bhadrapurnagarpalika"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.bhadrapurnagarpalika"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.facebook.android:facebook-android-sdk:18.1.3") // Facebook SDK
    implementation("com.google.android.gms:play-services-auth:4.3.0") // Google Sign-In
    implementation(platform("com.google.firebase:firebase-bom:34.1.0")) // Firebase BOM for consistent versions
    implementation("com.google.firebase:firebase-analytics") // Firebase Analytics
    implementation("com.google.firebase:firebase-auth") // Firebase Authentication
}
