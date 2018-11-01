//
//  TableViewCell.swift
//  GetWeather
//
//  Created by 許雅筑 on 2017/7/24.
//  Copyright © 2017年 hsu.ya.chu. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    func configureCell(forecast: DataModelWeekly){
        tempMinLabel.text = "\(forecast.lowtemp)"
        tempMaxLabel.text = "\(forecast.hightemp)"
        dateLabel.text = "\(forecast.date)"
        
        weatherLabel.text = forecast.weather
        weatherImage.image = UIImage(named: forecast.weather)
    }
    
    
    
}
