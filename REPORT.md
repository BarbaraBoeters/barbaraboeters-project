# Plantastic

## Short Overview
Plantastic is an assistant helping you to remember when to water your plants. It notifies the user only when being near to the plant in question. 
![alt tag](SCREENSHOT NEEDED)

## Technical Design

### Overview

The plants are saved into the Firebase Realtime Database with also a photo into the Firebase Storage. The database is used to show all the plants through a tableview. In addition I used Corelocation and and Mapkit to get or choose the location of the plant. Using Mapkit the different plants are showed on a map. As a extra design feature i used IQKeyboardManagerSwift for moving up the screen when using the keyboard. 

### Model
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

### View
This project mainly uses the storyboard, but also has the following custom views which are used to populate the tableview and to create round photos:
- PlantCell
- RoundedImageView

### Controller
The app consists of five controllers. In the first controller (RegisterViewController.swift) you can log in/sign up which uses Firebase to create the users and to log the users in. The second controller (MyGardenViewController) shows a list of the plants you saved in Firebase. It uses the PlantCell.swift to display the different plants in the tableview. The third controller(AddPlantViewController) allows the user to add a plant giving it a name, extra information, an interval of days when to give water, a photo. The location can be confirmed in the next controller(PlantViewController) in which you can either use your current location, or a searched location. Back in the controller where your plants are being displayed in the tableview, you can click on the top of the controller which will show you the last controller (GeoViewController). In this controller you will see all your plants on the map, with the geofences in red. In this controller you will get notification when you are near a plant and if it needs water. 

### RegisterViewController.swift
#### Data
The RegisterViewController contains the log in and sign up connection to Firebase. 

#### Methods
- signUpDidTouch() -> creates a new user into Firebase and logs in automatically
- logInDidTouch() -> logs in at Firebase
- errorAlert() -> function that is called when there is an error

### MyGardenViewController.swift
#### Data
Uses Firebase to show the plants into a tableview. It uses two arrays: Plant and User. 

#### Methods
- retrieveDataFirebase() -> Ordering by "interval", this method retrieves all the plants from the current user from Firebase
- logOutDidTouch() -> Logs out the current user
- configureStorage() -> Holds the reference to Firebase Storage
- tableview functions -> used to display the plants in a tableview.

### AddPlantViewController.swift
#### Data
Uses Firebase to upload one plant with a location and a photo. 

#### Methods
- addPhoto()
- stepperAction()
- addPlant()
- onCancel()
- alertError()

Extention:
- imagePickerController()
- imagePickerControllerDidCancel()

### PlantLocationViewController.swift
#### Data

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

### GeoViewController.swift
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
