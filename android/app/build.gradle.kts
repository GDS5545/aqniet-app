plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle plugin must be applied last
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "kz.zdravunion.aqniet"
    compileSdk = 36

    defaultConfig {
        applicationId = "kz.zdravunion.aqniet"
        minSdk = 21
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        debug {
            isMinifyEnabled = false
        }

        release {
            isMinifyEnabled = false
            isShrinkResources = false
            // Signing для release берётся из Codemagic
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

flutter {
    source = "../.."
}
