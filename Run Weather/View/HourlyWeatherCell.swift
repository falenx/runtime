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
    @IBOutlet weak var backgroundColorView: UIView!
    
    
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColorView.layer.cornerRadius = backgroundColorView.bounds.size.width/2
        backgroundColorView.clipsToBounds = true
        backgroundColorView.layer.borderColor = UIColor.label.cgColor
        backgroundColorView.layer.borderWidth = 1.0
    }

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColorView.layer.cornerRadius = backgroundColorView.bounds.size.width/2
    }
    
}
