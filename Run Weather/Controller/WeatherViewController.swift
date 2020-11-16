//
//  ViewController.swift
//  runTime
//
//  Created by michael taylor on 10/4/20.
//

import UIKit
import CoreLocation
import CoreData



class WeatherViewController: UIViewController{

    
    var settings = SettingsModel(){
        didSet {
            updateModel()
            
        }
    }
    
    var weather: WeatherModel? {
        didSet {
            updateModel()
        }
    }
    
    
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var currentConditionsStatementLabel: UILabel!
    @IBOutlet weak var currentRunRatingLabel: UILabel!
    @IBOutlet weak var hourlyTableView: UITableView!
    @IBOutlet weak var currentConditionsBackgroundImage: UIImageView!
    
    
    var weatherManager = WeatherManager()
    var citySearchManager = CitySearchManager()
    let locationManager = CLLocationManager()
    var locations: LocationModel?
    var resultsTableController: ResultsTableController?
    var searchController: UISearchController?
    var foundCity: String?
    
    @IBAction func currentLocationButtonPressed(_ sender: UIBarButtonItem) {
        self.currentCityLabel.text = "Loading running scores"
        locationManager.requestLocation()
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toSettingsViewController", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
        hourlyTableView.dataSource = self
        weatherManager.delegate = self
        citySearchManager.delegate = self
        
        hourlyTableView.register(UINib(nibName: "HourlyWeatherCell", bundle: nil), forCellReuseIdentifier: "hourlyWeatherCell")
        
        fetchData()
        
        resultsTableController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsTableController") as? ResultsTableController
        resultsTableController?.tableView.delegate = self
           
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController?.delegate = self
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        updateModel()
        //find where the db is
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settings = SettingsModelStore.shared.model!
    }
    
    func updateModel() {
                
        guard let weather = self.weather else {
            return
        }
        
        
        if self.settings.isCelsius ?? false {
            if foundCity != nil {
                self.currentCityLabel.text = "\(foundCity!)   \(weather.temperatureStringC + "°")"
            } else {
                self.currentCityLabel.text = "\(weather.cityName)   \(weather.temperatureStringC + "°")"
            }
        } else {
            if foundCity != nil {
                self.currentCityLabel.text = "\(foundCity!)   \(weather.temperatureStringF + "°")"
            } else {
                self.currentCityLabel.text = "\(weather.cityName)   \(weather.temperatureStringF + "°")"

            }
            
        }
        if weather.chanceOfRain > 70 {
            self.currentConditionsBackgroundImage.image = UIImage(named: "RainRun.jpeg")
        } else if weather.isDay == 0 {
            self.currentConditionsBackgroundImage.image = UIImage(named: "NightRun.png")
        } else {
            if weather.currentHour < 10 {
                self.currentConditionsBackgroundImage.image = UIImage(named: "runPic.jpg")
            } else {
                self.currentConditionsBackgroundImage.image = UIImage(named: "DayRun.jpg")
            }
        }
        
        self.currentWeatherImageView.image = UIImage(systemName: weather.conditionName)
        self.currentConditionsStatementLabel.text = weather.conditionStatement
        self.currentRunRatingLabel.text = String(weather.getRunningConditions())
        self.currentRunRatingLabel.textColor = self.getRunningConditionsColor(String(weather.getRunningConditions()))
        
        self.hourlyTableView.reloadData()
        self.view.layoutIfNeeded()
        
        
    }
    
    func resetModel() {
        self.currentCityLabel.text = "Failed, no network connection"
        self.currentConditionsStatementLabel.text = ""
        self.currentRunRatingLabel.text = ""
        self.currentWeatherImageView.image = UIImage(systemName: "sun.min")
        self.currentConditionsBackgroundImage.image = UIImage(named: "")
    
    }
}



//MARK: - UITableViewDelegate

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchString = locations?.names[indexPath.row].split(separator: ",")[0] ?? ""
        if (searchString.split(separator: " ").count) > 1 {
            let newString = searchString.replacingOccurrences(of: " ", with: "%20")
            weatherManager.fetchWeather(cityName: String(newString))
        }
        weatherManager.fetchWeather(cityName: String(searchString))
        searchController?.searchBar.searchTextField.text = ""
        searchController?.searchBar.resignFirstResponder()
        searchController?.searchBar.showsCancelButton = false
        resultsTableController?.locations?.names = []
        resultsTableController?.dismiss(animated: true)
        self.foundCity = nil
        
    }
}

extension WeatherViewController: UISearchControllerDelegate {
 
}

extension WeatherViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.showsSearchResultsController = true
        citySearchManager.fetchCities(cityName: searchController.searchBar.searchTextField.text ?? "")
    }
}

//MARK: - SearchBarDelegate

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel button clicked")
        searchBar.searchTextField.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false

    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func fetchData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Settings")
        do {
            settings.savedSettingsArray = try managedContext.fetch(fetchRequest)
            settings.isCelsius = settings.savedSettingsArray.last?.value(forKeyPath: "isCelsius") as? Bool ?? false
            settings.ignoreRain = settings.savedSettingsArray.last?.value(forKeyPath: "ignoreRain") as? Bool ?? false
            settings.idealTemperature = settings.savedSettingsArray.last?.value(forKeyPath: "idealTemperature") as? Double ?? 65
            settings.idealWindSpeed = settings.savedSettingsArray.last?.value(forKeyPath: "idealWindSpeed") as? Double ?? 2
            settings.idealHumidity = settings.savedSettingsArray.last?.value(forKeyPath: "idealHumidity") as? Double ?? 40
            SettingsModelStore.shared.updateModel(settings)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.weather = weather
            
            WeatherModelStore.shared.updateModel(weather)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CitySearchManagerDelegate

extension WeatherViewController: CitySearchManagerDelegate {
    
    func didUpdateSearch(_ citySearchManager: CitySearchManager, location: LocationModel) {
        DispatchQueue.main.async {
            self.locations = location
            self.resultsTableController?.locations = self.locations
        }
    }
    
    func didFailWithCityError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var firstLocation: CLPlacemark?
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error == nil {
                    firstLocation = placemarks?[0]
                    self.foundCity = firstLocation?.locality ?? ""
                    self.weatherManager.fetchWeather(latitude: lat, longitude: lon)
                }
                else {
                    print("error occured geocoding")
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        resetModel()
        print(error)
    }
}

//MARK: - UITableViewDataSource

extension WeatherViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 23 - (weather?.currentHour ?? 0)
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourlyWeatherCell", for: indexPath) as! HourlyWeatherCell
        
        let index = (weather?.currentHour ?? 0) + indexPath.row + 1
        let hour = weather?.hoursArray[index]
        cell.chanceOfRainLabel.text = String(hour?.chanceOfRain ?? 0) + "%"
        if (settings.isCelsius) ?? false {
            cell.feelsLikeLabel.text = String(hour?.feelsLikeC ?? 0) + "°"
        } else {
            cell.feelsLikeLabel.text = String(hour?.feelsLikeF ?? 0) + "°"
        }
        cell.runningConditionsLabel.text = String(hour?.getRunningConditions() ?? 0)
        cell.backgroundColorView.backgroundColor = getRunningConditionsColor(String(hour?.getRunningConditions() ?? 0))
        cell.windSpeedLabel.text = String(hour?.windSpeed ?? 0) + " MPH"
        cell.weatherIconImageView.image = UIImage(systemName: hour?.conditionName ?? "sun.min")
        if (hour?.currentHour ?? 0 > 11) {
            cell.currentHourLabel.text = String(dateConvert(date: hour?.currentHour ?? 0)) + " PM"
        } else {
            cell.currentHourLabel.text = String(hour?.currentHour ?? 0) + " AM"
        }
        return cell
    }
    
    func getRunningConditionsColor(_ runCondition: String) -> UIColor{
        let conditionRecieved = Int(runCondition)
        
        if conditionRecieved == 10 {
            return UIColor(red: 54/256, green: 181/256, blue: 0/256, alpha: 1.0)
        } else if (7...9).contains(conditionRecieved ?? 0) {
            return UIColor(red: 118/256, green: 255/256, blue: 0/256, alpha: 1.0)
        } else if (4...6).contains(conditionRecieved ?? 0) {
            return UIColor(red: 255/256, green: 204/256, blue: 0/256, alpha: 1.0)
        } else {
            return UIColor.red
        }
    }
    
}
func dateConvert(date: Int) -> Int {
    if date == 12 {
        return 12
    }
    return date - 12
}



