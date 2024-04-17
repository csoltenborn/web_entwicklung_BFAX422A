java -jar tools/openapi-generator-cli-7.3.0.jar generate -g dart -i api.yaml -o openapi

cd openapi

call dart pub get

cd ..\flutter_application

call dart run build_runner build --delete-conflicting-outputs

cd ..\server_application

call dart pub get

cd ..