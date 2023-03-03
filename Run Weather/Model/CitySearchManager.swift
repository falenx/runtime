//
//  CitySearchManager.swift
//  runTime
//
//  Created by michael taylor on 11/4/20.
//

import Foundation


protocol CitySearchManagerDelegate {
    func didUpdateSearch(_ citySearchManager: CitySearchManager, location: LocationModel)
    func didFailWithCityError(error: Error)
}

struct CitySearchManager {
    
    
    let cityURL = "https://api.weatherapi.com/v1/search.json?key=23f7947dc120486e8ef191204201010&q="
    
    var delegate: CitySearchManagerDelegate?
    
    func fetchCities(cityName: String) {
        let urlString = "\(cityURL)\(cityName)"
        performRequest(with: urlString)
    }
    
    func parseJSON(_ locationData: Data) -> LocationModel? {
        let decoder = JSONDecoder()
        

        do {
            let decodedData = try decoder.decode([APILocationData].self, from: locationData)
            var locationResults = LocationModel(names: [])
            if decodedData.count > 0 {
                for i in 0...((decodedData.count) - 1) {
                    let cityName = decodedData[i].name
                    let stateName = decodedData[i].region
                    print(cityName)
                    let tempName = cityName + ", " + stateName
                    locationResults.names.append(String(tempName) )
                }
            }
            return locationResults
        }
        catch {
            delegate?.didFailWithCityError(error: error)
            return nil
        }
    }
    
    
    func performRequest(with urlString: String) {
        
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Got an error")
                    //self.delegate?.didFailWithError(error: error!)
                    
                    return
                }
                if let safeData = data {
                    if let searchResults = self.parseJSON(safeData) {
                        //self.delegate?.didUpdateWeather(self, weather: weather)
                        self.delegate?.didUpdateSearch(self, location: searchResults)
                        
                    }
                }
            }
            task.resume()
        }
    }
    
}

    

