//
//  DataModelWeekly.swift
//  GetWeather
//
//  Created by 許雅筑 on 2017/7/24.
//  Copyright © 2017年 hsu.ya.chu. All rights reserved.
//

import Foundation

import Alamofire

class DataModelWeekly {
    
    private var _date: String?
    private var _hightemp: String?
    private var _lowtemp: String?
    private var _weather: String?
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    
    
    var date: String {
        
        return _date ?? "Invalid"
    }
    
    var hightemp: String {
        return _hightemp ?? "0 °C"
    }
    
    var lowtemp: String {
        return _lowtemp ?? "0 °C"
    }
    
    
    var weather: String {
        return _weather ?? "Weather Invalid"
    }
    
    init(weatherDict: Dictionary<String, AnyObject>){
        
        if let temp = weatherDict["temp"] as? JSONStandard,
            let min = temp["min"] as? Double,
            let max = temp["max"] as? Double,
            let weatherArray = weatherDict["weather"] as? [JSONStandard],
            let weather = weatherArray[0]["main"] as? String,
            let dt = weatherDict["dt"] as? Double {
            
            //            let minkelvinToFarenheitPreDivision = (min * (9/5) - 459.67)
            //            let minkelvinToFarenheit = Double(round(10 * minkelvinToFarenheitPreDivision/10))
            //            self._lowtemp = "\(minkelvinToFarenheit)"
            
            self._lowtemp = String(format: "%.0f °C", min - 273.15)
            self._hightemp = String(format: "%.0f °C", max - 273.15)
            
            
            //            let maxkelvinToFarenheitPreDivision = (max * (9/5) - 459.67)
            //            let maxkelvinToFarenheit = Double(round(10 * maxkelvinToFarenheitPreDivision/10))
            //            self._hightemp = "\(maxkelvinToFarenheit)"
            
            self._weather = weather
            
        }
        if let date = weatherDict["dt"] as? Double {
            let dateTemp = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = " MM/dd  EEEE"
//            dateFormatter.timeStyle = .none
            let string = "\(dateFormatter.string(from: dateTemp))"

            self._date = string

        }
        
    }
    
    
    
}


