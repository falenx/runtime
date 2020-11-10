//
//  preferenceSwitchCell.swift
//  runTime
//
//  Created by michael taylor on 10/30/20.
//

import UIKit

protocol PreferenceSwitchCellDelegate:  class {
    func didUpdateSwitch(value: Bool, cell: PreferenceSwitchCell)
}

class PreferenceSwitchCell: UITableViewCell {
    
   
    @IBOutlet weak var preferenceSwitchLabel: UILabel!
    @IBOutlet weak var preferenceSwitch: UISwitch!
    
    
    weak var delegate: PreferenceSwitchCellDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func PreferenceSwitchPressed(_ sender: UISwitch) {
        delegate?.didUpdateSwitch(value: preferenceSwitch.isOn, cell: self)
        
        
    }
    

}
