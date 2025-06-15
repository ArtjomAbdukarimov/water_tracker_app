plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // <-- здесь должно быть то же, что в вашем MainActivity.kt: com.example.water_tracker_app_new
    namespace = "com.example.water_tracker_app_new"
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
        // <-- это остаётся старым applicationId, он должен совпадать с google-services.json
        applicationId = "com.example.water_tracker_app"
        minSdk = 23
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

// затем подключаем плагин Google Services
apply(plugin = "com.google.gms.google-services")

flutter {
    source = "../.."
}