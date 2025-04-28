import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Carregar o keystore.properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("keystore.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "br.dev.kidgbzin.midlet_store"
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
        applicationId = "br.dev.kidgbzin.midlet_store"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keyAliasValue = keystoreProperties["keyAlias"]?.toString()
            val keyPasswordValue = keystoreProperties["keyPassword"]?.toString()
            val storeFileValue = keystoreProperties["storeFile"]?.toString()
            val storePasswordValue = keystoreProperties["storePassword"]?.toString()

            if (keyAliasValue != null && keyPasswordValue != null && storeFileValue != null && storePasswordValue != null) {
                keyAlias = keyAliasValue
                keyPassword = keyPasswordValue
                storeFile = file(storeFileValue)
                storePassword = storePasswordValue
            }
            else {
                throw RuntimeException("""
                    The project's keystore could not be found. 
                    Please ensure it is properly configured and available.
                    If you are cloning this project and are not part of the development team, code contributions are closed.
                    Please refer to the repository for contribution guidelines.
                """.trimIndent())
            }
        }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("release")
        }
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}