
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
 ~/Desktop/tutoring/김소윤/Bispick/bispick/ [main*] cd ..        
 ~/Desktop/tutoring/김소윤/Bispick/ [main*] ls
README.md bispick
 ~/Desktop/tutoring/김소윤/Bispick/ [main*] cat README.md
# Bispick

Lost and Found request app for BIS

## Getting Started

1. clone this repository
2. flutter run -d chrome --release --web-renderer=html
  **the web renderer is HTML
  **render this in release mode

## Done
1. UI for the application made (customization can be done after QA session)
2. camera service added to the application (for each platform ios +alpha)
3. CRUD functions done with firebase backend services (services used: firebase auth, firebase firestore, firebase firestorage)
4. Lost and Found services done with search services (after found, take picture, upload, on lost)
5. lost: found service done (founder, found time, location, description, photo -> yes -> erase)
6. Categories service (E-device, clothing, stationary, others -> lost items)
7. recently found service (top five recent items)
8. Request services done (add request -> upload -> delete can be only done by teacher's account)

## TODO: 
authentication system for the BIS students (email authentication and verification)
