# Plantastic
<img src="https://github.com/barbaraboeters/barbaraboeters-project/blob/master/doc/Afbeelding4.png" width="200px" height="200px" />

Programming Project
Barbara Boeters - 10774513

## Global Summary
Plantastic is a reminder app which helps you remember when to water your plants. Notifications are given when the user is close by a saved plant in need of water. 

## Description
For this project I created a reminder app that uses geofencing, Firebase and notifications. Existing plant-reminder apps lack in locationbased reminders. For example: when you get a notification while being somewhere else, you will most likely forget about it by the time you get home. Plantastic is an app that will offer the user a location based reminder. Instead of forgetting about giving your plants water because you get the notification on the wrong place, this app will only tell you when you are close by. 

## Components
Register and logging in
Adding plants with photo, location, interval of days, name and information
Map view to choose or use current location
Tableview to show plants 
Map view to show plants and their geofences

## Used Frameworks
Firebase
CoreLocation
IQKeyboardManagerSwift
Mapkit

## Instructions
This app requires CocoaPods and Firebase. Install or simulate using Xcode. To simulate the functionality: (1) insert '0' at the interval in AddPlantViewController, (2) simulate a location (for example: London) and (3) add the plant, (4) go to GeoViewController (Map) and (5) simulate going to another place and back again. 

## Minimum Viable Product
1. De gebruiker kan registreren 
2. Er kunnen planten toegevoegd worden met foto, frequentie, naam en locatie
3. De gebruiker krijgt pas een alert wanneer een plant water nodig heeft en hij/zij op de locatie is van de plant
4. Kaart met alle planten en hun radius/geofence

### Extra 
1. Delen met huisgenoten en rouleren van taak
2. Zoekfunctie planten met behulp van een API of webscrape
3. Homescherm maken met de eerstvolgende plant aan de beurt is
4. Status maken van de plant
5. Countdown bij elke plant

#### External Sources:
Frameworks:
- Firebase
- CoreLocation
- Mapkit 
- IQKeyboardManagerSwift

Tutorials & Forum: 
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

[![BCH compliance](https://bettercodehub.com/edge/badge/BarbaraBoeters/barbaraboeters-project)](https://bettercodehub.com)



The README.md should also acknowledge sources of external code, images and other materials that are in the repository but not created by yourself. Make sure that it is clear which directories are copyrighted by different creators.

