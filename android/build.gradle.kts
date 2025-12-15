plugins {
    id("com.android.application")
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
        release {
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}
