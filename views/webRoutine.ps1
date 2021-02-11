flutter build web
Remove-Item '..\application\public\*' -Recurse
Copy-Item -Path '.\build\web\*' -Destination '..\application\public' -Recurse
Write-Host 'Finished web internal deploy. Compiling for Android now'
flutter build apk --split-per-abi --target-platform android-arm64
Rename-Item '.\build\app\outputs\flutter-apk\app-arm64-v8a-release.apk' -NewName 'arm64.apk'
Move-Item -Path '.\build\app\outputs\flutter-apk\arm64.apk' -Destination '..\application\public'
