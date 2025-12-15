plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle plugin must be applied last
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "kz.zdravunion.aqniet"
    compileSdk = 34

    defaultConfig {
        applicationId = "kz.zdravunion.aqniet"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        debug {
            // debug build без оптимизаций
            isMinifyEnabled = false
        }

        release {
            // ⚠️ ВАЖНО: shrinkResources выключен,
            // иначе Gradle упадёт при minify=false
            isMinifyEnabled = false
            isShrinkResources = false

            // Для Codemagic signing берётся извне,
            // поэтому здесь ничего указывать не нужно
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jv
