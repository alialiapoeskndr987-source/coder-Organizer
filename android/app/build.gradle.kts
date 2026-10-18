plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.coderorganizer.coder_organizer"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion = flutter.ndkVersion — حُذف عمداً: لا كود C/C++ في المشروع
    // (path_provider_android مقفول على 2.2.23 الخالص عبر dependency_overrides)،
    // وإفراد NDK يبطئ البناء ويستهلك مساحة بلا داعٍ.

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Required by Firebase Auth SDK (desugared java.time APIs)
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.coderorganizer" // D-020
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26 // SRS 2.2: Android 8.0+
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = 24 // v1.24
        versionName = "1.24" // v1.24
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // v1.23 — نسختا توزيع:
    // stable = الهوية الرسمية (com.coderorganizer) بشمول كل المعماريات.
    // lite   = حزمة مستقلة (.lite) لتفادي أي تعارض تثبيت سابق + وضع تغليف
    //          قديم (extractNativeLibs=true) لأقصى توافق مع ROMs المصنّعين.
    flavorDimensions += "channel"
    productFlavors {
        create("stable") {
            dimension = "channel"
            manifestPlaceholders["appName"] = "Coder Organizer"
        }
        create("lite") {
            dimension = "channel"
            applicationIdSuffix = ".lite"
            versionNameSuffix = "-lite"
            manifestPlaceholders["appName"] = "Coder Organizer Lite"
            packaging {
                jniLibs {
                    useLegacyPackaging = true
                }
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
