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

#### Methods
- addPhoto() -> presents the image picker 
- stepperAction() -> handles the stepper and only allows you to choose an interval between 1 and 30 with 1 step at a time. 
- addPlant() -> -> quite a complex function which forces you to first choose your location. It pushes the information to Firebase Database and Storage
- onCancel() -> cancels adding a plant and brings you back to MyGardenViewController
- alertError() -> function that is called when there is an error

Extention:
- imagePickerController()
- imagePickerControllerDidCancel()

#### 4. PlantLocationViewController.swift
This viewcontroller will show a map and the current location of the user. There are two options of saving a location. Either the user chooses the button that saves the current location, or the user uses the searchbar to find a custom location on the map. The current location can be saved by using the 'Use my location' button. The custom location can be saved by using the 'done' button. 


//  In this view the user can choose a location by using his or her current location, or 
//  searching for one by using the searchbar. The coordinates of the location are being saved
//  in the AddPlantViewController by using a segue.

#### Methods
- onCancel()
- searchButton()
- toCurrentLocation()
- dropAnnotationPin()
- locationManager()
- segue

Extention:
- zoomToUserLocation
- locationManager

#### 5. GeoViewController.swift
#### Data

#### Methods
- setupLocationManager()
- setupMapView()
- getLocations
- viewDidAppear()
- setupData()
- mapView()
- CLLocationManagerDelegate
- updatePlants()
- checkIntervalPlants()
- intervalCheck()
- showWaterAlert()
- updateRegionsWithLocation()

## Changes and Challenges

## Decisions

### Future Goals
If there was more time, the following functions would have been implemented. 
- Background notification
- Sharing of plants (creation of groups in Firebase)
- Further perfectioning of the maps

## Bugs

## Credits
Frameworks:
- Firebase
- CoreLocation
- Mapkit
- IQKeyboardManagerSwift
- https://makeappicon.com
