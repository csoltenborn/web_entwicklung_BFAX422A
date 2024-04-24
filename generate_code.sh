#!/bin/zsh

# script file needs to be executable: chmod +x generate_code.sh

# Generate Dart code using openapi-generator
java -jar tools/openapi-generator-cli-7.3.0.jar generate -g dart -i api.yaml -o openapi

# Navigate to the generated directory
cd openapi

# Install dependencies for Dart project
dart pub get

# Switch to the flutter application directory
cd ../flutter_application

# Run build process for Flutter application
dart run build_runner build --delete-conflicting-outputs

# Switch to the server application directory
cd ../server_application

# Install dependencies for server application
dart pub get

# Move back to the project root directory (optional)
cd ..