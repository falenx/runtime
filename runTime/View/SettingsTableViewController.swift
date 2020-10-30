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
    
    var settings = SettingsModel()
    

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
      
      //1
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      let managedContext = appDelegate.persistentContainer.viewContext
      
      //2
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Settings")
      
      //3
      do {
        settings.savedSettingsArray = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
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
                //cell.preferenceTextField.placeholder = String(format: "%.0f", settings.idealHumidity ?? 0)
            } else if indexPath.row == 3 {
                cell.preferenceEditLabel.text = settings.settingsArray[indexPath.row]
                //cell.preferenceTextField.placeholder = String(format: "%.0f",settings.idealWindSpeed ?? 0)
            } else {
                cell.preferenceEditLabel.text = settings.settingsArray[indexPath.row]
                //cell.preferenceTextField.placeholder = String(format: "%.0f",settings.idealTemperature ?? 60)
            }
            
            return cell
            
        }

        
    }
    
    func save(isCelsius: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
          }
          
        let managedContext = appDelegate.persistentContainer.viewContext
          

        let entity = NSEntityDescription.entity(forEntityName: "Settings", in: managedContext)!
          
        let setting = NSManagedObject(entity: entity, insertInto: managedContext)
          
        setting.setValue(isCelsius, forKeyPath: "isCelsius")
        
        print("celsius is being saved as ")
        print(isCelsius)
          
        do {
            try managedContext.save()
            print("saved")
            settings.savedSettingsArray.append(setting)
            
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
    func save(ignoreRain: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
          }
          
          let managedContext = appDelegate.persistentContainer.viewContext
          
          let entity = NSEntityDescription.entity(forEntityName: "Settings", in: managedContext)!
          
          let setting = NSManagedObject(entity: entity, insertInto: managedContext)
          
          setting.setValue(ignoreRain, forKeyPath: "ignoreRain")
          
          do {
            try managedContext.save()
            settings.savedSettingsArray.append(setting)
            
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < 2 {
            if indexPath.row == 0 {
                //let condition = (settings.savedSettingsArray.last?.value(forKeyPath: "isCelsius"))
                
                //let cell = tableView.cellForRow(at: indexPath) as! PreferenceSwitchCell

                if (settings.savedSettingsArray.last?.value(forKeyPath: "isCelsius") != nil) {
                    print("celsius is true")
                    save(isCelsius: false)
                    
                } else {
                    print("celsius is false")
                    save(isCelsius: true)
                }
            } else {
                if (settings.savedSettingsArray.last?.value(forKeyPath: "ignoreRain") != nil) == true {
                    save(ignoreRain: false)
                } else {
                    save(ignoreRain: true)
                }
            }
            
            
        }
        tableView.reloadData()
        print("reloaded data")
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







