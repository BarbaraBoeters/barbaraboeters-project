# Plantastic
<img src="https://github.com/barbaraboeters/barbaraboeters-project/blob/master/doc/Afbeelding4.png" width="200px" height="200px" />

## Short Overview
Plantastic is an app that helps the user to remember when to water his/her plants. Plants are added with the following information: location, name, interval of days and a photo. On the homepage (MyGardenViewController) the plants of the current user are being displayed in a tableview. When using the 'Go to the Map'-button a map will appear with all plants. The user only gets notified when being close to a plant which is in need of water. 

## 
<img src="https://github.com/barbaraboeters/barbaraboeters-project/blob/master/doc/Overview.png"/>

## Technical Design

### Overview

The plants are saved into the Firebase Realtime Database. Next to that the photo is being stored into the Firebase Storage. The database is used to show all plants on a tableview. In addition I used Corelocation and Mapkit to get or choose the location of the plant. The plants are showed on a map using MapKit. As a extra design feature I used IQKeyboardManagerSwift for moving up the screen when using the keyboard. 

### 1. Model
#### Plant
This object is quite large because of the info of the plant itself, the location and the interval. It is used to upload objects of plants and to download the plants onto the tableview and on the map. 

| Plant         | Values        |
| ------------- |:-------------:|
| key      | String |
| name      | String      |
| info | String      |
| uid | String |
| interval | Int |
| ref | FIRDatabaseReference |
| completed | Bool |
| lastUpdated | Double |
| latitude | Double |
| longitude | Double |
| imageUrl | String |

#### User
This object is used to log in, sign up or log out of Firebase. It is also used to get the right plant objects from the current user instead of all the plants in the database. 

| User         | Values        |
| ------------- |:-------------:|
| uid | String |
| e-mail | String |

### 2. View
This project mainly uses the storyboard, but also has the following custom views which are used to populate the tableview and to create round photos:
- PlantCell
- RoundedImageView

### 3. Controller
#### Overview
This app consists of five controllers. In the first controller (RegisterViewController.swift) you can log in/sign up. This uses Firebase to create the users and to log the users in. The second controller (MyGardenViewController) shows a list of the plants you saved into Firebase. It uses the PlantCell.swift to display the different plants in the tableview. The third controller(AddPlantViewController) allows the user to add a plant giving it a name, extra information, an interval of days when to give water and a photo. The location can be confirmed in the next controller(PlantViewController) in which you can either use your current location or search for another location. Back in the controller where your plants are being displayed in the tableview, you can click on the top of the controller which will show you the last controller (GeoViewController). In this controller you will see all your plants on the map with the geofences in red. In this controller you will receive a notification when you are near a plant and if it needs water. 

#### 1. RegisterViewController.swift
The RegisterViewController contains the log in and sign up connection to Firebase. Users are able to sign in with an emailadres and with a password of at least 6 characters long. Functions like signUpDidTouch(), logInDidTouch() are called on and used when using the log in or sign up button. The errorAlert() function is called when there are errors, for example if signing up or logging in didn't work.

##### Methods
- signUpDidTouch() -> creates a new user into Firebase and logs in automatically
- logInDidTouch() -> logs in at Firebase
- errorAlert() -> function that is called when there is an error

#### 2. MyGardenViewController.swift
This is the homepage of the app. In this view you will at first witness an empty tableview. When plants are being added, the tableview will be populated with the name, extra info, interval and photo of the plant. The photo of the plant is being downloaded from Firebase Storage. The rest of the information is pulled from Firebase Database. Plants can be deleted by swiping to the left. Upon deletion they also dissapear from the Firebase Database. The tableview is ordered on the lowest interval to the highest. From this screen you can access the viewcontroller where you can add plants, and the map showing all plants with geofences. 

##### Methods
- retrieveDataFirebase() -> this method retrieves all the plants from the current user from Firebase, ordered by "interval"
- logOutDidTouch() -> logs out the current user
- configureStorage() -> Holds the reference to Firebase Storage
- tableview functions -> used to display the plants in a tableview and to download the photo's from Firebase Storage

#### 3. AddPlantViewController.swift
In this viewcontroller the user can add a photo from the photolibrary, a name, extra info, an interval and the location (this last one will open up a new viewcontroller in which you can choose your location). The information is uploaded to Firebase Database (name, info, interval and location) and the Firebase Storage(photo). In this viewcontroller you can also access your photolibrary by calling on the imagePickerController(). 

##### Methods
- addPhoto() -> presents the image picker 
- stepperAction() -> handles the stepper and only allows you to choose an interval between 1 and 30 with 1 step at a time. 
- addPlant() -> quite a complex function which forces you to first choose your location. It pushes the information to Firebase Database and Storage
- onCancel() -> cancels adding a plant and brings you back to MyGardenViewController
- alertError() -> function that is called when there is an error

Extention:
- imagePickerController()
- imagePickerControllerDidCancel()

#### 4. PlantLocationViewController.swift
This viewcontroller will show a map and the current location of the user. There are two options of saving a location. Either the user chooses the button that saves the current location, or the user uses the searchbar to find a custom location on the map. The current location can be saved by using the 'Use my location' button. The custom location can be saved by using the 'done' button after using the search function. When these buttons are used, the information is being send through to the AddPlantViewController through a segue. 

##### Methods
- onCancel() -> dismisses this view and goes back to the AddPlantViewController
- searchButton() -> Uses the text from the searchbar to perform a MKLocalSearchRequest
- toCurrentLocation() -> button which brings you to your current location
- locationManager() functions -> handles the configuration of CoreLocation like your current location and coordinates
- prepare(for segue: UIStoryboardSegue) -> pushes the coordinates to the AddPlantViewController

Extention:
- zoomToUserLocation
- locationManager

#### 5. GeoViewController.swift
Shows a map with all the plants from the current user with red geofences. The use of Geofencing is only possible within this viewcontroller. When the user is close to a plant, functions are called to check if the plants needs water. If yes, the user will then receive a notification (within this window). When clicking on the 'OK' button, the lastUpdated value in Firebase will be updated.

##### Methods
- setupLocationManager() -> configuration of the Locationmanager during viewDidLoad()
- setupMapView() -> configuration of the MapView during viewDidLoad()
- getLocations -> downloads the plants from Firebase, but only of the current user. These objects are pushed to an array and the locations are being showed on the MapView. 
- viewDidAppear() -> checks if the user authorized that his or her location is being used.  
- mapView() -> creates the red circle around the pinannotations. 
- updatePlants() -> downloads the plants of the current user out of Firebase and calls on the checkIntervalPlants() function.
- checkIntervalPlants() -> calls on the intervalCheck() function. After it only calls on the showWaterAlert() function if there are any plants being send back.
- intervalCheck() -> checks the timedifference of every plant 
- showWaterAlert() -> for all the plants that need water there will be one notification. When using the 'OK' button, the postPlant() function will be called
- postPlant() -> uploads the complete plant object to the Firebase Database so the lastUpdated value will be resetted. 
- errorAlertMessage() -> is called different times for error handling
- plantAlert() -> the change with errorAlertMessage() is that plantAlert() calls the postPlant() function
- backButton() -> dismisses this view and goes back to the MyGardenViewController
- toCurrentUserLocation() -> a button which brings you to your current location

Extention: 
- Locationmanager functions -> a check if the user enters or exists the region
- setupData() -> checks if regions can be monitored. After that the data of the plants is being displayed on the map by a radius and a pin.

#### AppDelegate
In AppDelegate the connections to and/or frameworks of Firebase, CoreLocation and IQKeyboardManager are being established
- IQKeyboardManager: https://github.com/hackiftekhar/IQKeyboardManager
- Firebase: https://firebase.google.com
- CoreLocation: https://www.raywenderlich.com/136165/core-location-geofencing-tutorial & https://www.appcoda.com/geo-targeting-ios/

## Changes and Challenges

**Firebase** 

One of the biggest challenges was to use Firebase Database and Storage. Most of the code came fom a [tutorial](https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2), but I only understood bits of it. To be able to save or update objects into Firebase Database was a challenge that was met with a lot of errors. For example: if one or multiple values needed to be updated, I decided to completely overwrite the object. There is a way to actually just update a certain value, but I wasn't able to make it work.
I used Firebase Storage for uploading and downloading photos that are connected to certain plants. This was a last minute implementation because I kept on leaving it to the end, because it didn't seem that important. But at the end I looked at my product and I thought it was something that I really wanted to learn, which is why I decided to implement it in the last two days of the project. I spent a long time figuring out how to upload the photo's, but after talking with other students I finally could figure it out.

**Geofencing**

As this app was not really a 'new' idea, I decided (together with my teachers) to add a geofence function to my project. The main challenge was to get it to work on the background and to combine this with the checks if the water needed water. The initial [tutorial](https://www.raywenderlich.com/136165/core-location-geofencing-tutorial) had too much code for me to be able to understand. In this tutorial there was the option for background checking, but I decided to go with another [tutorial](https://www.appcoda.com/geo-targeting-ios/) that a fellow student recommended. This tutorial did explain quite well how to get the geofencing working, but failed to explain how to keep it working on the background. I tried to go back to the first tutorial but that seemed too big of an effort for the time left. Together with my teacher we decided that for now it would be OK to just have the geofencing working in the GeoViewController. 

**Notifications**

Next to wanting to get the geofences working in the background, I also wanted to implement background notifications. Notifications within one viewcontroller are easily achieved, but it already seems to become more difficult if you want it throughout the app. It is difficult because it also relies on constantly implementing the geofence checks in the background.

## Better Code Hub 
Please have a look at the [AUDIT](https://github.com/BarbaraBoeters/barbaraboeters-project/blob/master/AUDIT.md) report for more details. 

## Changes to DESIGN.md 
In the DESIGN document I stated what the minimum requirements were for this product to be viable. I am pleased to announce that most of these requierements worked out. The user can register and log in. Plants can be added with a photo, frequency, name and location. The user gets an alert only if the plant in the neighbourhood needs water (though only in one viewcontroller). Last but not least: there is a map with all the plants and their radius in red. 

The goal of my initial proposal was to design an app that is simplistic in its use. The dream was to create an app with only one view, though this was difficult for me to achieve this month. In my DESIGN.md I initially thought I would have three viewcontrollers(RegisterViewController, MyGardenViewController & AddPlantViewController). I did keep these viewcontrollers as is, though I changed some minor things to the viewcontrollers themselves and added two extra viewcontrollers for the maps. 

RegisterViewController is basically exactly the same as I imagined how it would be. It still consists of one view with two text fields and two buttons which you use to either log in or register a user. 

MyGardenViewController still consists of a tableview with all the plants of the user. In the DESIGN document I wanted (if time allowed it) to add a homescreen which would display the next plant in need of water and a sidebar with all the plants of the current user. Unfortunately I didn't have time to implement this.

AddPlantViewController is almost the same as I explained in the DESIGN document. I implemented a struct in which the name, frequency and extra info were saved, but added some more values (completed, uid, lastUpdated, latitude and longitude). I was able to get Firebase Storage working so I could implement the addPhoto function. The biggest change was to add a location for each plant. You can choose the location by clicking on 'Set my Location'. This brings the user to a new viewcontroller (PlantLocationViewController) in which you can either choose your current location, or search for a location. 

## Decisions
Initially I wanted to create an app in which you could just add plants and which would give you a notification when those plants need water. By researching the app store I found that there were already similar apps (for example: WaterMe). To add something new to an existing idea, I ended up changing my goal. The choice quickly fell on adding a location for every plant. That way you could take care of plants in different places (at home, at work, at your parents etc.). Also there could have been an extra option to share plants, for example between housemates. Unfortunately I couldn't implement the extra option, but I succeeded in creating an app which gives you a solution to not only forgetting about your plants, but also to only get a notification when you are **near** your plant. 

One of the decisions I made, was choosing to only implement local notifications and local geofencing instead of keeping it running on the background. By limiting Geofencing and background notifications to only in-app in-viewcontroller implementation, the user doesn't get overloaded with notifications which could be so irritating that the user could potentially decide to deny notifications. At the other hand it is a function you actually should not miss with an app like this. If you don't get warned you when you need to water your plants because of your app being in the background, it feels kind of useless. 

A last and minor decision was to choose to lock the portrait orientation. This decision is based on my personal preference of using the phone using one hand. Having the screen switch between landscape and portrait orientation would be an unnecessary feature. 

In an ideal world, I would have spent more time figuring out how to get the notifications and geofencing working on the background. With the background notifications and geofencing I believe that Plantastic would be a fantastic app to use on a daily basis.

Please find more details in my [PROCESS](https://github.com/BarbaraBoeters/barbaraboeters-project/blob/master/PROCESS.md) book.

### Future Goals 
- Background notification
- Sharing of plants (creation of groups in Firebase)
- Further perfectioning of the maps
- Implementing a Countdown for every plant
- Homescreen with a photo and a countdown for the next plant that needs water
- Create a search function by using an API or use of webscraping

## Bugs
- Location services sometimes become unavailable during simulation. The solution is to delete the app from the simulator and to run it again. If this doesn't work, it sometimes helps to restart Xcode.

## Credits
Frameworks:
- Firebase
- CoreLocation
- Mapkit
- IQKeyboardManagerSwift

Icon maker: 
- [Make App Icon](https://makeappicon.com)
