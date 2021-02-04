flutter build web
Remove-Item '..\application\public\*' -Recurse
Copy-Item -Path '.\build\web\*' -Destination '..\application\public' -Recurse