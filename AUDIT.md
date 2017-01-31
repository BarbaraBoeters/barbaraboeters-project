#Task List
- Keep Unit Interfaces Small
    - GeoViewController.setupData(Double,Double,String) -> Tried to create a struct for coordinates but couldnt make it work. 
    - MyGardenViewController.tableView(UITableView,UITableViewCellEditingStyle,IndexPath) -> its already short?
    - Plant.init(String,String,Bool,String,Int,String,Double,Double,Double) -> will not change, except for deleting the completed bool because at the moment its not doing anything

- Write Short Units of Code
    - GeoViewController.getLocations(@escapinggetLocationsComplete)
    - AddPlantViewController.addPlant(Any)
    - GeoViewController.viewDidLoad() -> tried putting the setups in different functions
    - GeoViewController.setupData(Double,Double,String) 

    - MyGardenViewController.viewDidLoad() -> functie maken van firebase checks -> done
    - GeoViewController.updateRegionsWithLocation(CLLocation) -> probably done? dont remember fixing
    - GeoViewController.viewDidAppear(Bool) -> made a alert function -> done
    - GeoViewController.showWaterAlert() -> put the alert in another function -> done
    - GeoViewController.checkIntervalPlants() -> put part of the function in another function -> done

    - PlantLocationViewController.searchButton(Any) -> struct/object maken -> tried but couldnt make it work
    - GeoViewController.plantAlert(String,String) -> try to put the post in another function -> done but im getting a new problem: 
        - GeoViewController.postPlant()

- Write Clean Code
    - AppDelegate.swift -> done
    - AppDelegate.swift -> done
    - GeoViewController.swift -> done
![alt tag](https://github.com/barbaraboeters/barbaraboeters-project/blob/master/doc/BetterCodeHub.png)
