//
//  ViewController.swift
//  GetWeather
//
//  Created by 許雅筑 on 2017/7/24.
//  Copyright © 2017年 hsu.ya.chu. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController,CLLocationManagerDelegate,GetMessageDelegate {
        
    
    //today

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mornTempLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    //tomorrow
    
    @IBOutlet weak var dateTomoLabel: UILabel!
    @IBOutlet weak var mornTomoLabel: UILabel!
    @IBOutlet weak var nightTomoLabel: UILabel!
    @IBOutlet weak var locationTomorrowLabel: UILabel!
    @IBOutlet weak var weatherTomoImage: UIImageView!
    @IBOutlet weak var weatherTomoLabel: UILabel!
    
    
    var forecast: DataModel!
    var forecastTomorrow : DataModel!
    var forecasts = [DataModel]()
    
    var receiveString : String?
    var latReceiveData : Double?
    var longReceiveData : Double?
    let locationManager: CLLocationManager = CLLocationManager()
    var latitude: Double = 35
    var longitude: Double = 139
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //精確度
        locationManager.requestAlwaysAuthorization()  //初始化
        locationManager.startUpdatingLocation()  //location update
        

        

        
        // 拿位置
        
//        weather.downloadData1(lat: self.latitude, lon: self.longitude) {
//            self.updateUI()
//        }
    }
    
    func updateUI() {
        dateLabel.text = forecast.dateToday
        mornTempLabel.text = forecast.mornTemp
        nightTempLabel.text = forecast.nightTemp
        weatherLabel.text = forecast.weather
        weatherImage.image = UIImage(named: forecast.weather)
    }
    func updateTomoUI() {
        dateTomoLabel.text = forecastTomorrow.dateTomorrow
        mornTomoLabel.text = forecastTomorrow.mornTemp
        nightTomoLabel.text = forecastTomorrow.nightTemp
        weatherTomoLabel.text = forecastTomorrow.weather
        weatherTomoImage.image = UIImage(named: forecastTomorrow.weather)
    }
    
    
    
    
    func downloadForecastData(completed: @escaping ()-> ()){
        Alamofire.request(FORECAST_URL).responseJSON (completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject>{
                if let list = dict["list"] as? [Dictionary<String, AnyObject>]{
                    for obj in list {
                        let forecast = DataModel(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    self.forecast = self.forecasts[0] as! DataModel
                    self.forecastTomorrow = self.forecasts[1] as! DataModel

//                    self.forecast = self.forecasts[0] as! DataModel
//                    self.updateUI()
                }
                if let locationCity = dict["city"] as? Dictionary<String, AnyObject>{
                    self.locationLabel.text = "\(locationCity["name"] as! String),\(locationCity["country"] as! String)"
                    self.locationTomorrowLabel.text = "\(locationCity["name"] as! String),\(locationCity["country"] as! String)"
                    
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.forecast = self.forecasts[0] as! DataModel
                    self.forecastTomorrow = self.forecasts[1] as! DataModel
                    self.updateUI()
                    self.updateTomoUI()
                })


            }
            completed()
        })
        
        
        
    }

    //接收传过来的值
    func getMessage(controller: SelectViewController, lat: Double, long: Double, region: String)
    {
        receiveString = region
        latReceiveData = lat
        longReceiveData = long
        if (latReceiveData == 0 && longReceiveData == 0){
            FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(receiveString!)&mode=json&appid=da20170669c4c2578512fa84cce8ccab"
            downloadForecastData{
                
            }
        }
        else if (receiveString == "") {
            FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latReceiveData!)&lon=\(longReceiveData!)&mode=json&appid=da20170669c4c2578512fa84cce8ccab"
            downloadForecastData{
                
            }
        }
        
        
        if(region == "" && lat == 0 && long == 0)
        {
            let myAlert = UIAlertController(title: "null", message: "you need type", preferredStyle: .alert)
            self.present(myAlert, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "passValue" {
            let destinationViewController = segue.destination as? SelectViewController
            destinationViewController!.delegate = self
        }
        
    }
    
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){ //地理位置更新 會回傳
     var location: CLLocation = locations[locations.count-1] as CLLocation // 可能傳遞多個 只要最後一個
     if location .horizontalAccuracy > 0 {
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
        downloadForecastData{
            
        }
        
     updateWeatherInfo(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
     
     locationManager.stopUpdatingLocation()
     
     }
     }
     
     func updateWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
     

     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
     print(error)
     }
     
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
