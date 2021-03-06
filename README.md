# SteamDeals
Built an Android mobile app that allows single sign-on with Google accounts, bookmark favorite game deals from Steam store.

Features:
- Single sign-on with Google accounts: I followed Firebase documentation on setting up with Flutter using this link: 
https://firebase.google.com/docs/auth/flutter/federated-auth
- Bookmark deals: set up collection of users on Firebase so every user has their own wishlist array where the game deals are placed when bookmarked
- Dynamic search bar: deals are fetched dynamically from CheapShark API using title entered by users on search bar so results are different on changes.

Technology: 
- Flutter, Firebase, CheapShark API, Dart

Useful links:
- https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html
- https://flutterforyou.com/how-to-fetch-data-from-api-and-show-in-flutter-listview/
- https://www.flutterbeads.com/pass-data-to-stateful-widget-in-flutter/
- https://stackoverflow.com/questions/64934102/firestore-add-or-remove-elements-to-existing-array-with-flutter

Screenshots: 
- Profile: 

![Profile](/lib/screenshots/profile.png)

- Explore:

![Explore](/lib/screenshots/explore.png)

- Search: 

![Explore](/lib/screenshots/search.png)

- Home: 

![Home](/lib/screenshots/home.png)

- Not logged in yet:

![Anonymous](/lib/screenshots/anonymous.png)





