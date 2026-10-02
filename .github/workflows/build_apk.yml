name: qurmaq

on:
  push:
    branches: [ main, master ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4

    - name: Java-nı qurun
      uses: actions/setup-java@v4
      with:
        distribution: 'zulu'
        java-version: '17'

    - name: Flutter-i qurun
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.19.0'
        channel: 'stable'

    - name: Android Platformasını Sıfırdan Sazlayın
      run: |
        rm -rf android
        flutter create . --platforms=android --org com.fedo.music --project-name fedo_music_pro
        
        # Manifestə İnternet və Yaddaş icazələrini əlavə edirik
        cat << 'EOF' > android/app/src/main/AndroidManifest.xml
        <manifest xmlns:android="http://schemas.android.com/apk/res/android">
            <uses-permission android:name="android.permission.INTERNET"/>
            <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
            <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
            <uses-permission android:name="android.permission.READ_MEDIA_AUDIO"/>
            
            <application
                android:label="Fedo Music Pro"
                android:name="${applicationName}"
                android:icon="@mipmap/ic_launcher"
                android:usesCleartextTraffic="true">
                <activity
                    android:name=".MainActivity"
                    android:exported="true"
                    android:launchMode="singleTop"
                    android:theme="@style/LaunchTheme"
                    android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
                    android:hardwareAccelerated="true"
                    android:windowSoftInputMode="adjustResize">
                    <meta-data
                      android:name="io.flutter.embedding.android.NormalTheme"
                      android:value="@style/NormalTheme"
                      />
                    <intent-filter>
                        <action android:name="android.intent.action.MAIN"/>
                        <category android:name="android.intent.category.LAUNCHER"/>
                    </intent-filter>
                </activity>
                <meta-data
                    android:name="flutterEmbedding"
                    android:value="2" />
            </application>
        </manifest>
        EOF

        # app/build.gradle faylına Gradle konfiqurasiyası
        cat << 'EOF' > android/app/build.gradle
        plugins {
            id "com.android.application"
            id "kotlin-android"
            id "dev.flutter.flutter-gradle-plugin"
        }

        android {
            namespace "com.fedo.music.fedo_music_pro"
            compileSdk 34

            defaultConfig {
                applicationId "com.fedo.music.fedo_music_pro"
                minSdk 21
                targetSdk 34
                versionCode 1
                versionName "1.0.0"
            }

            compileOptions {
                sourceCompatibility JavaVersion.VERSION_17
                targetCompatibility JavaVersion.VERSION_17
            }

            kotlinOptions {
                jvmTarget = '17'
            }

            buildTypes {
                release {
                    signingConfig signingConfigs.debug
                    minifyEnabled false
                    shrinkResources false
                }
            }
        }

        flutter {
            source '../..'
        }
        EOF

    - name: Paketləri Yükləyin
      run: flutter pub get

    - name: Release APK Yığın
      run: flutter build apk --release --no-tree-shake-icons

    - name: Hazır APK-nı Yükləyin
      uses: actions/upload-artifact@v4
      with:
        name: Fedo-Music-Pro-v1.0.0
        path: build/app/outputs/flutter-apk/app-release.apk
