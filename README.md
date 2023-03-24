#SiaraShield-specs

## Verification Flow for iOS
It's a Swift Library to support Verification in iOS

https://user-images.githubusercontent.com/128694120/227514280-31976295-3964-4a5d-a3c4-cbeb764d5fa0.mov


## Installation
Drag and Drop SiaraShield-iOS Directory into your XCode Project Directory.

## Basic usage ✨

  Simply add UIView to Your ViewController And Connect @IBOutlet - SlidingView Class and do below code

https://user-images.githubusercontent.com/128694120/227514349-65e44099-4fd7-4c01-a0a6-03462dbfb65b.mov



```swift

 @IBOutlet weak var slideview: SlidingView!

 //Add masterUrlIdValue for masterUrlId or add in Inspectable as per above video
 slideview.masterUrlIdValue = "Your Key value"
 // Add requestUrlValue for requestUrl or add in Inspectable as per above video
 slideview.requestUrlValue = "Your URL Value"

 //Comolsury to call this method
 //Add the view controller to method getvalue
 slideview.getvalue(vc: self)

## License

CyberSiaraShield-iOS is available under the MIT license. See the LICENSE file for more info.
