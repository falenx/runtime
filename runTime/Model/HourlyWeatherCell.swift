//
//  HourlyWeatherCell.swift
//  runTime
//
//  Created by michael taylor on 10/15/20.
//

import UIKit

class HourlyWeatherCell: UITableViewCell {
    
    
    @IBOutlet weak var runningConditionsLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var chanceOfRainLabel: UILabel!
    @IBOutlet weak var currentHourLabel: UILabel!
    
    
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
