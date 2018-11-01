//
//  DataModel.swift
//  GetWeather
//
//  Created by 許雅筑 on 2017/7/24.
//  Copyright © 2017年 hsu.ya.chu. All rights reserved.
//

import Foundation
import Alamofire

class DataModel {
    
    private var _date: Double?
    private var _mornTemp: String?
    private var _nightTemp: String?
    private var _weather: String?
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Taiwan&appid=da20170669c4c2578512fa84cce8ccab")!

    var dateToday: String {
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy/MM/dd  EEEE"
        let datetemp = Date(timeIntervalSince1970: _date!)
        return (_date != nil) ? "Today,\(dateFormatter.string(from: datetemp))" : "Date Invalid"

    }
    
    var dateTomorrow: String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy/MM/dd  EEEE"
        let datetemp = Date(timeIntervalSince1970: _date!)
        return (_date != nil) ? "Tomorrow,\(dateFormatter.string(from: datetemp))" : "Date Invalid"
        
    }
    
    var mornTemp: String {
        return _mornTemp ?? "0 °C"
    }
    
    var nightTemp: String {
        return _nightTemp ?? "0 °C"
    }
    
    
    var weather: String {
        return _weather ?? "Weather Invalid"
    }
    
    init(weatherDict: Dictionary<String, AnyObject>){


        if let temp = weatherDict["temp"] as? JSONStandard,
            let mornTemp = temp["morn"] as? Double,
            let nightTemp = temp["night"] as? Double,
            let weatherArray = weatherDict["weather"] as? [JSONStandard],
            let weather = weatherArray[0]["main"] as? String
            
        {
            self._mornTemp = String(format: "%.0f °C", mornTemp - 273.15)
            self._nightTemp = String(format: "%.0f °C", nightTemp - 273.15)
            self._weather = weather
        }
        if let dateTemp = weatherDict["dt"]  {
            self._date = dateTemp as! Double
        }
        
    }
    
}



 
