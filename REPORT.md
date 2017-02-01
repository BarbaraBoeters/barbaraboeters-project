# Plantastic

## Short Overview
Plantastic is an assistant helping you to remember when to water your plants. It notifies the user only when being near to the plant in question. 
![alt tag](SCREENSHOT NEEDED)

## Technical Design

### Overview

The plants are saved into the Firebase Realtime Database with also a photo into the Firebase Storage. The database is used to show all the plants through a tableview. In addition I used Corelocation and and Mapkit to get or choose the location of the plant. Using Mapkit the different plants are showed on a map. As a extra design feature i used IQKeyboardManagerSwift for moving up the screen when using the keyboard. 


### Classes

#### RegisterViewController.swift
### Data
The RegisterViewController contains the log in and sign up connection to Firebase. 

### Methods
- signUpDidTouch() -> creates a new user into Firebase and logs in automatically
- logInDidTouch() -> logs in at Firebase
- errorAlert() -> function that is called when there is an error

#### MyGardenViewController.swift
### Data
Uses Firebase to show the plants into a tableview. It uses two arrays: Plant and User. 

### Methods
- retrieveDataFirebase() -> Ordering by "interval", this method retrieves all the plants from the current user from Firebase
- logOutDidTouch() -> Logs out the current user
- configureStorage() -> Holds the reference to Firebase Storage
- tableview functions -> used to display the plants in a tableview.

#### AddPlantViewController.swift
### Data
Uses Firebase to upload one plant with a location and a photo. 

### Methods
- addPhoto()
- stepperAction()
- addPlant()
- onCancel()
- alertError()

Extention:
- imagePickerController()
- imagePickerControllerDidCancel()

#### PlantLocationViewController.swift
### Data

### Methods
- onCancel()
- searchButton()
- toCurrentLocation()
- dropAnnotationPin()
- locationManager()
- segue

Extention:
- zoomToUserLocation
- locationManager

#### GeoViewController.swift
### Data

### Methods
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
