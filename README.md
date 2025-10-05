
# Flutter EV Station App

A simple EV charger-finding application where the locations of charging stations are displayed, directions are provided from the user's current location to the stations, and new stations can be added to the application.

## Documentation

Clone the project

```bash
  git clone https://link-to-project
```

Install dependencies

```bash
  flutter pub get
```

Start the app

```bash
  flutter run
```


For Code Design, I have used the following pattern
```bash
main.dart
\lib
    \app
        \bindings
            \login_bindings.dart
            \station_bindings.dart
        \common\widgets
            \common_textfield.dart
        \modules\stations
            \controllers
                \add_station_controller.dart
                \login_controller.dart
                \signup_controller.dart
                \station_controller.dart
                \station_details_controller.dart
            \models
                \station_model.dart
            \views
                \add_station_view.dart
                \home_view.dart
                \login_view.dart
                \map_picker_view.dart
                \sign_up_view.dart
                \station_details_view.dart
        \routes
            \app_pages.dart
            \app_routes.dart
        \utils
            \utils.dart
    \firebase_options.dart
    \main.dart
```

This function is for logging in a user.

```bash
  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password are required");
      return;
    } else if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email");
      return;
    } else if (password.length < 6) {
      Get.snackbar("Error", "Password should be at least 6 characters");
      return;
    } else {
      try {
        isLoading.value = true;

        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        Get.snackbar("Success", "Login successful for $email");
        Get.offAllNamed("/home");
      } catch (e) {
        Get.snackbar("Error", "An unexpected error occurred");
      } finally {
        isLoading.value = false;
      }
    }
  }
```


This function is used for Signing up an user.

```bash
Future<void> signup() async {
    final name = nameController.text();
    final email = emailController.text();
    final password = passwordController.text();
    final confirmPassword = confirmPasswordController.text();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    } else if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    } else if (password.length < 6) {
      Get.snackbar("Error", "Password should be at least 6 characters");
      return;
    } else if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email");
      return;
    } else {
      // Proceed with signup logic (e.g., API call)
      try {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        String message = "An error occurred";
        if (e.code == 'email-already-in-use') {
          message = "The email is already in use";
        } else if (e.code == 'invalid-email') {
          message = "The email is invalid";
        } else if (e.code == 'operation-not-allowed') {
          message = "Operation not allowed";
        } else if (e.code == 'weak-password') {
          message = "The password is too weak";
        }
        Get.snackbar("Error", message);
        return;
      } catch (e) {
        Get.snackbar("Error", "An unexpected error occurred");
        return;
      }
      // For demonstration, we'll just show a success message
      Get.snackbar("Success", "Signup successful for $name");
      Get.offAllNamed("/login");
      // Clear the fields
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    }
  }
```

This function is used for fetching station data from Firebase Firestore.

```bash
Future<void> fetchStations() async {
    try {
      isLoading(true);
      QuerySnapshot snapshot = await db.collection('stations').get();
      var result = snapshot.docs
          .map((doc) => Station.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      stations.assignAll(result);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
```
Adding the configurations for the permission handler for accessing the maps and the current location of the user and EV stations(Android)

```bash
# Inside "gradle.properties" file

android.useAndroidX=true
android.enableJetifier=true
```
```bash
# Inside "AndroidManifest.xml" file

<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION"/>
```

(iOS)

```bash
# Inside "podfile.ios" file

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)

    target.build_configurations.each do |config|
      # You can remove unused permissions here
      # for more information: https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler_apple/ios/Classes/PermissionHandlerEnums.h
      # e.g. when you don't need camera permission, just add 'PERMISSION_CAMERA=0'
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',

        ## dart: PermissionGroup.calendar
        'PERMISSION_EVENTS=1',
        
        ## dart: PermissionGroup.calendarFullAccess
        'PERMISSION_EVENTS_FULL_ACCESS=1',

        ## dart: PermissionGroup.reminders
        'PERMISSION_REMINDERS=1',

        ## dart: PermissionGroup.contacts
        'PERMISSION_CONTACTS=1',

        ## dart: PermissionGroup.camera
        'PERMISSION_CAMERA=1',

        ## dart: PermissionGroup.microphone
        'PERMISSION_MICROPHONE=1',

        ## dart: PermissionGroup.speech
        'PERMISSION_SPEECH_RECOGNIZER=1',

        ## dart: PermissionGroup.photos
        'PERMISSION_PHOTOS=1',

        ## The 'PERMISSION_LOCATION' macro enables the `locationWhenInUse` and `locationAlways` permission. If
        ## the application only requires `locationWhenInUse`, only specify the `PERMISSION_LOCATION_WHENINUSE`
        ## macro.
        ##
        ## dart: [PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse]
        'PERMISSION_LOCATION=1',
        'PERMISSION_LOCATION_WHENINUSE=0',

        ## dart: PermissionGroup.notification
        'PERMISSION_NOTIFICATIONS=1',

        ## dart: PermissionGroup.mediaLibrary
        'PERMISSION_MEDIA_LIBRARY=1',

        ## dart: PermissionGroup.sensors
        'PERMISSION_SENSORS=1',

        ## dart: PermissionGroup.bluetooth
        'PERMISSION_BLUETOOTH=1',

        ## dart: PermissionGroup.appTrackingTransparency
        'PERMISSION_APP_TRACKING_TRANSPARENCY=1',

        ## dart: PermissionGroup.criticalAlerts
        'PERMISSION_CRITICAL_ALERTS=1',

        ## dart: PermissionGroup.assistant
        'PERMISSION_ASSISTANT=1',
      ]

    end
  end
end
```

```bash
# Inside Info.plist

<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location to show nearby EV charging stations.</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to your location even in the background to provide accurate directions to charging stations.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app uses your location to provide continuous navigation and station updates.</string>

```



This function is used for permission handling while opening the home page.

```bash
Future<void> checkPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      locationPermissionGranted(true);
    } else if (status.isDenied) {
      final requestStatus = await Permission.location.request();
      locationPermissionGranted(requestStatus.isGranted);
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      locationPermissionGranted(status.isGranted);
    }
  }
```
This function is used for showing the map having the station location, the user's location, and the direction for the user

```bash
Future<void> _initLocation() async {
    final Station station = Get.arguments as Station;
    try {

      _currentPosition = await Geolocator.getCurrentPosition();

      double distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        station.latitude,
        station.longitude,
      );

      setState(() {
        _distanceInKm = distanceInMeters / 1000;
        _markers = {
          Marker(
            markerId: const MarkerId("station"),
            position: LatLng(station.latitude, station.longitude),
            infoWindow: InfoWindow(
              title: station.name,
              snippet: station.address,
            ),
          ),
          Marker(
            markerId: const MarkerId("user"),
            position: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            infoWindow: const InfoWindow(title: "You are here"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
        };
        _polylines.add(Polyline(
          polylineId: const PolylineId("route"),
          points: [
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            LatLng(station.latitude, station.longitude),
          ],
          color: Colors.blue,
          width: 5,
        ));
      });

      if (_mapController != null) {
        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(
            _currentPosition!.latitude < station.latitude
                ? _currentPosition!.latitude
                : station.longitude,
            _currentPosition!.longitude < station.longitude
                ? _currentPosition!.longitude
                : station.longitude,
          ),
          northeast: LatLng(
            _currentPosition!.latitude > station.latitude
                ? _currentPosition!.latitude
                : station.latitude,
            _currentPosition!.longitude > station.longitude
                ? _currentPosition!.longitude
                : station.longitude,
          ),
        );

        _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 80),
        );
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }
```

This function is used for adding an EV station
```bash
Future<void> addStation({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int availablePoints,
    required int totalPoints,
    List<String>? amenities,
  }) async {
    try {
      isLoading.value = true;

      // Firebase integration
      await FirebaseFirestore.instance.collection('stations').add({
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'available_points': availablePoints,
        'total_points': totalPoints,
        'amenities': amenities ?? [],
        'created_at': FieldValue.serverTimestamp(),
      });


      debugPrint(
        "Station added: $name, $address, $latitude, $longitude, $availablePoints, $totalPoints",
      );

      Get.snackbar(
        "Success",
        "Station added successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    } finally {
      isLoading.value = false;
    }
  }
}
```



Open in Google Maps function

```bash
Future<void> _openGoogleMaps(double lat, double lng) async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("Could not open Google Maps");
    }
  }
```

Screeshots

1. Login page

![01](https://github.com/user-attachments/assets/da926ceb-6d2a-45a3-bdba-0d96344ce03e)

2. Sign Up Page

![02](https://github.com/user-attachments/assets/f7529c2b-b255-4c66-bfd2-541feed2c71f)


3. Home Page

![03](https://github.com/user-attachments/assets/d1892150-e08a-4243-b238-c4664ffc61d2)


4. Station Details Page

![04](https://github.com/user-attachments/assets/69166fe2-c20e-4237-818f-45fa41c3d2f0)


5. Add Station Page

![05](https://github.com/user-attachments/assets/948abfd5-04a6-474e-85ec-b697c0c3b619)


5. Logout Drawer

![06](https://github.com/user-attachments/assets/1f3a8f1b-5f5d-4284-9fa2-9507a14bc563)
