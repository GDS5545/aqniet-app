plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "kz.zdravunion.aqniet"
    compileSdk = 35

    defaultConfig {
        applicationId = "kz.zdravunion.aqniet"
        minSdk = 21
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}
