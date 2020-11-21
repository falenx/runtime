//
//  PreferenceEntryCell.swift
//  runTime
//
//  Created by michael taylor on 10/30/20.
//

import UIKit


protocol PreferenceEntryCellDelegate:  class {
    func didUpdateTextField(value: Double, cell: PreferenceEntryCell)
}


class PreferenceEntryCell: UITableViewCell {
    
    
    @IBOutlet weak var preferenceEditLabel: UILabel!
    @IBOutlet weak var preferenceTextField: UITextField!
    
    weak var delegate: PreferenceEntryCellDelegate?
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        delegate?.didUpdateTextField(value: Double(preferenceTextField.text ?? "0") ?? 0, cell: self)
        
    }
    
    
    
    
}





