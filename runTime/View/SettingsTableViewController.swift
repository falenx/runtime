//
//  SettingsTableViewController.swift
//  runTime
//
//  Created by michael taylor on 10/26/20.
//

import UIKit
import CoreData
import Foundation

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {
    
    var settings = SettingsModel(){
        didSet {
            tableView.reloadData()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        tableView.register(UINib(nibName: "PreferenceSwitchCell", bundle: nil), forCellReuseIdentifier: "preferenceSwitchCell")
        tableView.register(UINib(nibName: "PreferenceEntryCell", bundle: nil), forCellReuseIdentifier: "preferenceEntryCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        settings = SettingsModelStore.shared.model ?? SettingsModel()
        fetchData()
        settings.isCelsius = settings.savedSettingsArray.last?.value(forKeyPath: "isCelsius") as? Bool
        settings.ignoreRain = settings.savedSettingsArray.last?.value(forKeyPath: "ignoreRain") as? Bool
        settings.idealTemperature = settings.savedSettingsArray.last?.value(forKeyPath: "idealTemperature") as? Double
        settings.idealWindSpeed = settings.savedSettingsArray.last?.value(forKeyPath: "idealWindSpeed") as? Double
        settings.idealHumidity = settings.savedSettingsArray.last?.value(forKeyPath: "idealHumidity") as? Double
        SettingsModelStore.shared.updateModel(settings)

        
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "preferenceSwitchCell", for: indexPath) as! PreferenceSwitchCell
            if indexPath.row == 0 {
                cell.preferenceSwitchLabel.text = settings.settingsArray[indexPath.row]
                cell.preferenceSwitch.isOn = settings.savedSettingsArray.last?.value(forKeyPath: "isCelsius") as? Bool ?? false
            } else {
                cell.preferenceSwitchLabel.text = settings.settingsArray[indexPath.row]
                cell.preferenceSwitch.isOn = settings.savedSettingsArray.last?.value(forKeyPath: "ignoreRain") as? Bool ?? false
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "preferenceEntryCell", for: indexPath) as! PreferenceEntryCell
            if indexPath.row == 2 {
                cell.preferenceEditLabel.text = settings.settingsArray[indexPath.row]
                cell.preferenceTextField.placeholder = settings.savedSettingsArray.last?.value(forKeyPath: "idealHumidity") as? String ?? "40"
            } else if indexPath.row == 3 {
                cell.preferenceEditLabel.text = settings.settingsArray[indexPath.row]
                cell.preferenceTextField.placeholder = settings.savedSettingsArray.last?.value(forKeyPath: "idealWindSpeed") as? String ?? "2"
            } else {
                cell.preferenceEditLabel.text = settings.settingsArray[indexPath.row]
                cell.preferenceTextField.placeholder = settings.savedSettingsArray.last?.value(forKeyPath: "idealTemperature") as? String ?? "65"
            }
            
            return cell
            
        }

    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Settings")
        do {
            settings.savedSettingsArray = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deletePreviousValues() {
        if settings.savedSettingsArray.count >= 1 {
            context.delete((settings.savedSettingsArray[0]))
        }
    }
    func saveContext() {
        let newSetting = Settings(context: context)
        newSetting.isCelsius = SettingsModelStore.shared.model?.isCelsius ?? false
        newSetting.ignoreRain = SettingsModelStore.shared.model?.ignoreRain ?? false
        newSetting.idealHumidity = SettingsModelStore.shared.model?.idealHumidity ?? 40
        newSetting.idealWindSpeed = SettingsModelStore.shared.model?.idealWindSpeed ?? 2
        newSetting.idealTemperature = SettingsModelStore.shared.model?.idealTemperature ?? 65
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
    }
    
    func executeDataChange() {
        SettingsModelStore.shared.updateModel(settings)
        deletePreviousValues()
        saveContext()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < 2 {
            if indexPath.row == 0 {
                if (settings.savedSettingsArray.last?.value(forKeyPath: "isCelsius") != nil) {
                    if settings.savedSettingsArray.last?.value(forKeyPath: "isCelsius") as? Int == 1 {
                        settings.isCelsius = false
                        executeDataChange()
                        tableView.deselectRow(at: indexPath, animated: true)
                    } else {
                        settings.isCelsius = true
                        executeDataChange()
                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                } else {
                    settings.isCelsius = true
                    executeDataChange()
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            } else {
                if (settings.savedSettingsArray.last?.value(forKeyPath: "ignoreRain") != nil) {
                    if settings.savedSettingsArray.last?.value(forKeyPath: "ignoreRain") as? Int ==  1 {
                        settings.ignoreRain = false
                        executeDataChange()
                        tableView.deselectRow(at: indexPath, animated: true)
                    } else {
                        settings.ignoreRain = true
                        executeDataChange()
                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                } else {
                    settings.ignoreRain = true
                    executeDataChange()
                    tableView.deselectRow(at: indexPath, animated: true)
                }
                
            }
            fetchData()
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







