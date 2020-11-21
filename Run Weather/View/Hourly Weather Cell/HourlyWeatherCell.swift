//
//  HourlyWeatherCell.swift
//  runTime
//
//  Created by michael taylor on 10/15/20.
//

import UIKit

class HourlyWeatherCell: UITableViewCell {
    
    struct Model {
        
        let chanceOfRain: String
        let feelsLike: String
        let runningCondition: String
        let runningConditionsColor: UIColor
        let windSpeed: String
        let weatherIconName: String
        let currentHour: String
        
    }
    
    var model: Model? {
        didSet {
            applyModel()
        }
    }
    
    @IBOutlet weak var runningConditionsLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var chanceOfRainLabel: UILabel!
    @IBOutlet weak var currentHourLabel: UILabel!
    @IBOutlet weak var backgroundColorView: UIView!
    
    
    
    func applyModel() {
        guard let model = model else { return }
        
        chanceOfRainLabel.text = model.chanceOfRain
        feelsLikeLabel.text = model.feelsLike
        runningConditionsLabel.text = model.runningCondition
        backgroundColorView.backgroundColor = model.runningConditionsColor
        windSpeedLabel.text = model.windSpeed
        weatherIconImageView.image = UIImage(systemName: model.weatherIconName)
        currentHourLabel.text = model.currentHour
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColorView.layer.cornerRadius = backgroundColorView.bounds.size.width/2
        backgroundColorView.clipsToBounds = true
        backgroundColorView.layer.borderColor = UIColor.label.cgColor
        backgroundColorView.layer.borderWidth = 1.0
        runningConditionsLabel.layer.shadowColor = UIColor.black.cgColor
        runningConditionsLabel.layer.shadowRadius = 4.0
        runningConditionsLabel.layer.shadowOpacity = 1.0
        runningConditionsLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        runningConditionsLabel.layer.masksToBounds = false
    }

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColorView.layer.cornerRadius = backgroundColorView.bounds.size.width/2
    }
    
}
