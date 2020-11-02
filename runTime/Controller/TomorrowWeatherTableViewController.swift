//
//  TomorrowWeatherTableViewController.swift
//  runTime
//
//  Created by michael taylor on 10/19/20.
//

import UIKit

class TomorrowWeatherTableViewController: UITableViewController {
    
    var weather: WeatherModel?{
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "HourlyWeatherCell", bundle: nil), forCellReuseIdentifier: "hourlyWeatherCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        weather = WeatherModelStore.shared.model
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 24
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourlyWeatherCell", for: indexPath) as! HourlyWeatherCell
        
        let index = 24 + indexPath.row
        let hour = weather?.hoursArray[index]
        cell.chanceOfRainLabel.text = String(hour?.chanceOfRain ?? 0) + "%"
        if (hour?.isCelsius) ?? false {
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
        } else if (hour?.currentHour ?? 0 == 0){
            cell.currentHourLabel.text = String(12) + " AM"
        }else {
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


