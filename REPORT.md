# Plantastic
<img src="https://github.com/barbaraboeters/barbaraboeters-project/blob/master/doc/Afbeelding4.png" width="200px" height="200px" />

## Short Overview
Plantastic is an app that helps the user to remember when to water his/her plants. Plants are added with the following information: location, name, interval of days and a photo. On the homepage it will show the plants of the user in a tableview. When pressing the 'Go to the Map'-button a map will appear with all the plants of the user. It notifies the user only when being near to a plant, and if it needs water. 

## 
<img src="https://github.com/barbaraboeters/barbaraboeters-project/blob/master/doc/Overview.png"/>

## Technical Design

### Overview

The plants are saved into the Firebase Realtime Database with also a photo into the Firebase Storage. The database is used to show all the plants through a tableview. In addition I used Corelocation and and Mapkit to get or choose the location of the plant. Using Mapkit the different plants are showed on a map. As a extra design feature i used IQKeyboardManagerSwift for moving up the screen when using the keyboard. 

### 1. Model
#### Plant
This object is quite large because of the info of the plant itself, the location and the checking of the interval. It is used to upload the different plants, and to download the plants onto the tableview or on the map. 

| Plant         | Values        |
| ------------- |:-------------:|
| key      | String |
| name      | String      |
| info | String      |
| uid | String |
| interval | Int |
| ref | FIRDatabaseReference? |
| completed | Bool |
| lastUpdated | Double |
| latitude | Double |
| longitude | Double |
| imageUrl | String |

#### User
This object is used to log in, sign up or log out of Firebase. It was also used to get the right plant objects from the current user instead of all the plants in the database. 

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
The app consists of five controllers. In the first controller (RegisterViewController.swift) you can log in/sign up which uses Firebase to create the users and to log the users in. The second controller (MyGardenViewController) shows a list of the plants you saved in Firebase. It uses the PlantCell.swift to display the different plants in the tableview. The third controller(AddPlantViewController) allows the user to add a plant giving it a name, extra information, an interval of days when to give water, a photo. The location can be confirmed in the next controller(PlantViewController) in which you can either use your current location, or a searched location. Back in the controller where your plants are being displayed in the tableview, you can click on the top of the controller which will show you the last controller (GeoViewController). In this controller you will see all your plants on the map, with the geofences in red. In this controller you will get notification when you are near a plant and if it needs water. 

#### 1. RegisterViewController.swift
The RegisterViewController contains the log in and sign up connection to Firebase. Users are able to sign in with an emailadres and with a password of at least 6 characters long. Functions like signUpDidTouch(), logInDidTouch() are called on and used when using the buttons on the interface. The errorAlert() function is called when there are errors like if signing up or logging in didn't work.

##### Methods
- signUpDidTouch() -> creates a new user into Firebase and logs in automatically
- logInDidTouch() -> logs in at Firebase
- errorAlert() -> function that is called when there is an error

#### 2. MyGardenViewController.swift
This is the homepage of the app. In this view at first you will see an empty tableview. When plants are added the tableview will be populated with the name, extra info, interval and the photo. Plants can also be deleted by swiping to the left. Upon deletion they also dissapear from the Firebase Real-time Database. The tableview is ordered on the lowest interval to the highest. From this screen you can access the viewcontroller where you can add plants, and the map with all the plants with geofences. 

##### Methods
- retrieveDataFirebase() -> Ordering by "interval", this method retrieves all the plants from the current user from Firebase
- logOutDidTouch() -> Logs out the current user
- configureStorage() -> Holds the reference to Firebase Storage
- tableview functions -> used to display the plants in a tableview.

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
This viewcontroller will show a map and the current location of the user. There are two options of saving a location. Either the user chooses the button that saves the current location, or the user uses the searchbar to find a custom location on the map. The current location can be saved by using the 'Use my location' button. The custom location can be saved by using the 'done' button. When these buttons are clicked, the information is being send through to the AddPlantViewController through a segue. 

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
Shows a map with all the plants from the current user with a red radius around them. Use of Geofencing only within this viewcontroller. When the user is close to a plant, functions are called to check if the plants needs water and if yes, the user receives a notification (within this window). When clicking on the 'OK' button, the lastUpdated value in Firebase resets.

##### Methods
- setupLocationManager() -> configuration of the Locationmanager during viewDidLoad()
- setupMapView() -> configuration of the MapView during viewDidLoad()
- getLocations -> Downloads the plants from Firebase, but only of the current user. These objects are pushed to an array and the locations are being showed on the MapView. 
- viewDidAppear() -> checks if the user authorized that his or her location is being used.  
- mapView() -> creates the red circle around the pinannotations. 
- updatePlants() -> downloads the plants of the current user out of Firebase and calls on the checkIntervalPlants() function.
- checkIntervalPlants() -> calls on the intervalCheck() function. After it only calls on the showWaterAlert() function if there are any plants being send back.
- intervalCheck() -> checks the timedifference of every plant 
- showWaterAlert() -> for all the plants that need water there will be one notification. When using the 'OK' button the postPlant() function will be called
- postPlant() -> uploads the plant object again to the Firebase Database so the lastUpdated value will be resetted. 
- errorAlertMessage() -> is called different times for error handling
- plantAlert() -> change with errorAlertMessage() is that plantAlert() calls on the postPlant() function
- backButton() -> dismisses this view and goes back to the MyGardenViewController
- toCurrentUserLocation() -> button which brings you to your current location

Extention: 
- Locationmanager functions -> to check if the user enters or exists the region
- setupData() -> checks if regions can be monitored. After that the data of the plants is being displayed on the map by a radius and a pin.

#### AppDelegate
In AppDelegate the connections to and/or frameworks of Firebase, CoreLocation and IQKeyboardManager are being established
- IQKeyboardManager: https://github.com/hackiftekhar/IQKeyboardManager
- Firebase: https://firebase.google.com
- CoreLocation: https://www.raywenderlich.com/136165/core-location-geofencing-tutorial & https://www.appcoda.com/geo-targeting-ios/

## Changes and Challenges

**Firebase** 

One of the biggest challenges was to use Firebase Database and Firebase Storage. Most of the code came fom a [tutorial](https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2) and I only understood bits of it. To be able to save or update objects into Firebase Database was a challenge that was met with a lot of errors. For example: when one or multiple values needed to be updated, I decided to completely overwrite the object. There is a way to actually just update a certain value, but I wasn't able to make it work.
I used Firebase Storage for uploading and downloading photos that are connected to certain plants. This was a last minute implementation because I kept on leaving it to the end, because it didn't seem that important. But at the end I looked at my product and I thought it was something that I really wanted to learn, so I decided to implement it in the last two days of the project. I spent a long time figuring out how to upload the photo's, but after talking with other students I coudl figure it out. The downloading and presenting the photo's in the tableview I completely implemented on my own.

**Geofencing**

As this app is not really a 'new' idea, I decided (together with my teachers) to add Geofencing to my project. The main challenge was to make it work on the background and to combine this with checking if the water needed water. The initial [tutorial](https://www.raywenderlich.com/136165/core-location-geofencing-tutorial) was so full of code that I couldn't make sense of it. Though in this tutorial there was the option for background checking, I decided after a long struggle with a [tutorial](https://www.appcoda.com/geo-targeting-ios/) a fellow student recommended. This tutorial did explain quite well how to get the geofencing working, but failed to explain how to keep it working on the background. I tried to go back to the first tutorial but that seemed too big of an effort for the time left. Together with my teacher we decided for now it would be OK to just have the geofencing working in the GeoViewController. 

**Notifications**

Next to checking of geofences in the background, I also wanted to implement background notifications. Notifications within one viewcontroller is easily achieved, but it already seems to become more difficult if you want it throughout the app because it also relies on implementing geofence checks on the background.

## Decisions

Process book: 

Defend your decisions by writing an argument of a most a single paragraph. 
Why was it good to do it different than you thought before? Are there trade-offs for your current solution? 
In an ideal world, given much more time, would you choose another solution?

### Future Goals
If there was more time, the following functions would have been implemented. 
- Background notification
- Sharing of plants (creation of groups in Firebase)
- Further perfectioning of the maps
- Implementing a Countdown

## Bugs
- Location services sometimes become unavailable during simulation. The solution is to delete the app from the simulator and to run it again. 

## Credits
Frameworks:
- Firebase
- CoreLocation
- Mapkit
- IQKeyboardManagerSwift

Icon maker: 
- [Make App Icon](https://makeappicon.com)
