# Plantastic
<img src="https://github.com/barbaraboeters/barbaraboeters-project/blob/master/doc/Afbeelding4.png" width="200px" height="200px" />

## Programming Project - Barbara Boeters - 10774513

## Global Summary
Plantastic is a reminder app which helps you remember when to water your plants. Notifications are given when the user is close by a saved plant in need of water. 

## Description
For this project I created a reminder app that uses geofencing, Firebase and notifications. Existing plant-reminder apps lack in locationbased reminders. For example: when you get a notification while being somewhere else, you will most likely forget about it by the time you get home. Plantastic is an app that will offer the user a location based reminder. Instead of forgetting to give your plants water because you got the notification on the wrong place, this app will only tell you when you are close by. 

## Components
- Register and logging in
- Adding plants with photo, location, interval of days, name and information
- Map view to choose or use current location
- Tableview to show plants 
- Map view to show plants and their geofences

## Used Frameworks
- Firebase
- CoreLocation
- IQKeyboardManagerSwift
- Mapkit

## Instructions
This app requires CocoaPods and Firebase. Install or simulate using Xcode. To simulate the functionality: (1) insert '0' at the interval in AddPlantViewController, (2) simulate a location (for example: London) and (3) add the plant, (4) go to GeoViewController (Map) and (5) simulate going to another place and back again.
Note: The search function to choose your location doesn't seem to work well in the GeoViewController when running on the simulator. On the iPhone is does work. 


#### External Sources:
Tutorials & Fora: 
- https://www.appcoda.com/geo-targeting-ios/
- http://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
- http://sweettutos.com/2015/04/24/swift-mapkit-tutorial-series-how-to-search-a-place-address-or-poi-in-the-map/
- https://www.youtube.com/watch?v=GX4mcOOUrWQ
- http://stackoverflow.com/questions/31038759/conditional-binding-if-let-error-initializer-for-conditional-binding-must-hav
- https://firebase.google.com/docs/storage/ios/download-files
- http://mrgott.com/swift-programing/32-firebase-storage-how-to-download-files-using-firebase-3-sdk-with-swift-3-in-xcode-8
- https://www.ioscreator.com/tutorials/uistepper-tutorial-ios8-swift
- http://stackoverflow.com/questions/31694635/convert-optional-string-to-int-in-swift
- http://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/

Icon maker: 
- [Make App Icon](https://makeappicon.com)

Copyright (c) 2017, BarbaraBoeters All rights reserved.

[![BCH compliance](https://bettercodehub.com/edge/badge/BarbaraBoeters/barbaraboeters-project)](https://bettercodehub.com)
