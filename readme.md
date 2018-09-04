# Stocks application demo with Push Notifications for iOS

This is a demo of a stocks application created using Swift, Pusher Channels, Pusher Beams and Node.js. [View tutorial](#).


## Getting Started

Download and clone the project. 

The Node.js application is in the `webapi` directory. Copy the `config.example.js` to `config.js` and update the credentials. `cd` to the directory and run the following commands:

```
$ npm install
$ node index
```

When the server is up, open the `Stocks.xcworkspace` file in Xcode. Update the credentials in `AppConstants.swift` and then run the application.


### Prerequisites


- Xcode installed on your machine. Download [here](https://developer.apple.com/xcode/).
- Know your way around the Xcode IDE.
- Basic knowledge of the Swift programming language.
- Basic knowledge of JavaScript.
- Node.js installed on your machine. Download [here](https://nodejs.org/en/download/).
- Cocoapods installed on your machine. Install [here](https://guides.cocoapods.org/using/getting-started.html).
- A Pusher account. Create one [here](https://pusher.com/).



## Built With

* [Pusher](https://pusher.com/) - APIs to enable devs building realtime features
* [Xcode](https://developer.apple.com/xcode/) - iOS development IDE.
