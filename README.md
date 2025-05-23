# 📰 News App

A modern Flutter news app that displays the latest headlines in a clean and responsive layout. Built using clean architecture principles and powered by popular Flutter packages.

---

## 🚀 Setup Instructions

1. Clone this repository**
   ```bash
   git clone https://github.com/amanxmhd/news_app.git
   cd news_app

Install dependencies

flutter pub get

Run the app
flutter run
Ensure Flutter SDK is installed. Follow: https://docs.flutter.dev/get-started/install

<table>
  <tr>
    <td><img src="https://github.com/amanxmhd/news_app/blob/main/ui.jpg?raw=true" width="300"/></td>
    <td><img src="https://github.com/amanxmhd/news_app/blob/main/bm.jpg?raw=true" width="300"/></td>
    <td><img src="https://github.com/amanxmhd/news_app/blob/main/ios.jpg?raw=true" width="300"/></td>
  </tr>
</table>



🧱 Architecture Overview
This app follows Clean Architecture with these key layers:

Presentation Layer: Flutter UI + Provider for state management

Domain Layer: Entities and use cases for business logic

Data Layer: Network requests using the http package, with repository pattern for abstraction


📦 Third-party Packages Used :

| Package                                                                 | Why It's Used                        |
| ----------------------------------------------------------------------- | ------------------------------------ |
| [`http`](https://pub.dev/packages/http)                                 | For fetching news data from the API  |
| [`provider`](https://pub.dev/packages/provider)                         | For state management                 |
| [`url_launcher`](https://pub.dev/packages/url_launcher)                 | To open news articles in the browser |
| [`cached_network_image`](https://pub.dev/packages/cached_network_image) | To load and cache images efficiently |
| [`flutter_spinkit`](https://pub.dev/packages/flutter_spinkit)           | Beautiful loading spinners           |


Features : 

Browse top headlines

Read article details

Tap to open full article in browser

Caching for faster performance

Clean and simple user interface
