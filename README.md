# MiniASOS

MiniASOS is a simple ecommerce app inspired by the ASOS app for devices running iOS 9.3 or higher.

The app includes the following features:
- A Facebook style menu to select product categories.
- A product grid screen implemented with a UICollectionView.
- A product detail screen with product description and image carousel.
- Double tap an item in the product grid to fave/unfave the product.
- View the list of favourited products.
- Add a product to the basket
- View the content of the basket
- A badge onto the basket icon indicates the number of the items in the basket.
- Support for localisation.


Build, test and run
=
WeatherHype is implemented is Swift 3 and therefore requires Xcode 8.0 to run.

Open the `WeatherHype.xcworkspace`in Xcode and hit:

* `CMD+U`  Run the Unit and Integration Tests
* `CMD+R`  Build & Run the app


Technical Notes
=

The app uses CocoaPods for dependency management and depends on SwiftyJSON for JSON parsing.
I consciously avoided the use of other libraries for (e.g networking, slide-out menu, activity indicator, cache, etc. ).

The app design promotes a separation of the UI, Model and Business layers.
The main patterns used are IoC & Dependency Injection, MVC, Observer, Delegation.
The Model layer uses value types rather than reference types.
The app avoids to access global singletons (e.g via `.shared()`). Singletons are passed to the dependent classes instead.

The component `ImageDownloader` caches the downloaed images in memory and resizes large images down to 400px width to reduce memory usage and improve rendering performance.
It's possible to reset the image cache by shaking the device.
The image cache is also reset on memory warning events.


Technical Improvements
=

This initial implementation can be improved in the following areas:

* Error handling: network requests should handle error conditions (e.g network errors, timeouts, API errors) and display an appropriate message to the user.
* Offline support: add some support for lack of connectivity and inform the user if the data of stale data.
* Improved design also taking advantage of hi resolution assets.

