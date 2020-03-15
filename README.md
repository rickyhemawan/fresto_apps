# Fresto Application for BIT(Hons) final project. #
For running this project online, please provide: 
Your `google-services.json` from your own `Firebase account`. 
Create A file called `.env` located at the main project folder which is `../fresto_apps/` and add this line of code:
```javascript
MAPS_API_KEY=<your-api-key-here>
MIDTRANS_CLIENT_KEY=<your-midtrans-client-key-here>
MIDTRANS_CHECKOUT_URL=<your-midtrans-server-url-here>/checkout.php/
```
For further information about [Midtrans](https://midtrans.com/) payment gateway please checkout their [online documentation](https://docs.midtrans.com/en/welcome/index.html)

When you execute `get dependencies` you should have a `local.properties` inside the `../fresto_apps/android/` please also add the line of code below for android user.
For example:
```javascript
//other code...
flutter.versionName=1.0.0
flutter.versionCode=1
// Add this line of code
MAPS_API_KEY=<your-api-key-here>
```