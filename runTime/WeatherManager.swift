//
//  WeatherManager.swift
//  runTime
//
//  Created by michael taylor on 10/9/20.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {

    let weatherURL = "https://api.weatherapi.com/v1/forecast.json?key=23f7947dc120486e8ef191204201010&days=5"
    
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&q=lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Got an error")
                    self.delegate?.didFailWithError(error: error!)
                    
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(APIWeatherData.self, from: weatherData)
            
            let temp = decodedData.current.temp_f
            let wind = decodedData.current.wind_mph
            let name = decodedData.location.name
            let rain = decodedData.forecast.forecastday[0].hour[15].chance_of_rain
            let windDir = decodedData.current.wind_dir
            let humidity = decodedData.current.humidity
            let feelsLike = decodedData.current.feelslike_f
            let uv = decodedData.current.uv
            let conditionId = decodedData.current.condition.code
            
            let weather = WeatherModel(conditionId: conditionId,
                                       cityName: name,
                                       temperature: temp,
                                       humidity: humidity,
                                       feelsLike: feelsLike,
                                       windSpeed: wind,
                                       windDirection: windDir,
                                       uvRating: uv,
                                       chanceOfRain: Double(rain) ?? 0)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
