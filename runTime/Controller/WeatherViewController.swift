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
            if self.settings.isCelsius ?? false {
                self.currentConditionsLabel.text = ((weather?.temperatureStringC ?? "") + "°")
            } else {
                self.currentConditionsLabel.text = ((weather?.temperatureStringF ?? "") + "°")
            }
            self.hourlyTableView.reloadData()
            
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var currentConditionsLabel: UILabel!
    @IBOutlet weak var currentConditionsStatementLabel: UILabel!
    @IBOutlet weak var currentRunRatingLabel: UILabel!
    @IBOutlet weak var hourlyTableView: UITableView!
    
    var weatherManager = WeatherManager()
    var citySearchManager = CitySearchManager()
    let locationManager = CLLocationManager()
    
    
    var weather: WeatherModel?
    
    
    

    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toSettingsViewController", sender: self)
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
    //var settings = SettingsModelStore.shared.model ?? SettingsModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
        
        hourlyTableView.dataSource = self
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        citySearchManager.delegate = self
        
        hourlyTableView.register(UINib(nibName: "HourlyWeatherCell", bundle: nil), forCellReuseIdentifier: "hourlyWeatherCell")
        
        fetchData()
        
        
        //find where the db is
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settings = SettingsModelStore.shared.model!
    }
    
}

func dateConvert(date: Int) -> Int {
    if date == 12 {
        return 12
    }
    return date - 12
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text?.trimmingCharacters(in: .whitespaces) {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter a city to search for"
            return true
        }
    }
    
    @IBAction func searchFieldChanged(_ sender: UITextField) {
        citySearchManager.fetchCities(cityName: searchTextField.text ?? "")
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
            if self.settings.isCelsius ?? false {
                self.currentConditionsLabel.text = weather.temperatureStringC + "°"
            } else {
                self.currentConditionsLabel.text = weather.temperatureStringF + "°"
            }
            self.currentWeatherImageView.image = UIImage(systemName: weather.conditionName)
            self.currentCityLabel.text = weather.cityName
            self.currentConditionsStatementLabel.text = weather.conditionStatement
            self.currentRunRatingLabel.text = String(weather.getRunningConditions())
            self.currentRunRatingLabel.textColor = self.getRunningConditionsColor(String(weather.getRunningConditions()))
            self.weather = weather
            self.hourlyTableView.reloadData()
            self.view.layoutIfNeeded()
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
        for i in location.names {
            print(i)
        }
        
        
    }
    
    func didFailWithCityError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude

            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
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


