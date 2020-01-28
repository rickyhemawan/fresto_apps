# Fresto Application for BIT(Hons) final project. #
For running this project online, please provide: 
Your `google-services.json` from your own `Firebase account`. 
Create A file called `.env` located at the main project folder which is `../fresto_apps/` and add this line of code:
```javascript
MAPS_API_KEY=<your-api-key-here>
```
When you execute `get dependencies` you should have a `local.properties` inside the `../fresto_apps/android/` please also add the line of code above for android user.
For example:
```javascript
//other code...
flutter.versionName=1.0.0
flutter.versionCode=1
// Add this code
MAPS_API_KEY=<your-api-key-here>
```