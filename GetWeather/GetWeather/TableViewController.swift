//
//  TableViewController.swift
//  GetWeather
//
//  Created by 許雅筑 on 2017/7/24.
//  Copyright © 2017年 hsu.ya.chu. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class TableViewController: UITableViewController,CLLocationManagerDelegate, GetMessageDelegate{
    
    
    
    @IBOutlet weak var cityLabel: UILabel!
    
    var forecast: DataModelWeekly!
    var forecasts = [DataModelWeekly]()
    var receiveString : String?
    var latReceiveData : Double?
    var longReceiveData : Double?
    var locationAtPlace : String?
    
    //get now location
    var latitude: Double = 35
    var longitude: Double = 139
    let locationManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //精確度
        locationManager.requestAlwaysAuthorization()  //初始化
        locationManager.startUpdatingLocation()  //location update
        //update viewcontroller 已繼承tableview
        //        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        //        self.tableView.register(nib, forCellReuseIdentifier: "Cell")

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func downloadForecastData(completed: @escaping ()-> ()){
        Alamofire.request(FORECAST_URL).responseJSON (completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject>{
                if let list = dict["list"] as? [Dictionary<String, AnyObject>]{
                    for obj in list {
                        let forecast = DataModelWeekly(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    //self.forecasts.remove(at: 0)
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            }
            completed()
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //register cell
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        if let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell{
            
            let eachforecast = forecasts[indexPath.row]
            cell.configureCell(forecast: eachforecast)
            
            //            cell.weatherLabel.text = "\(animalArray[indexPath.row])"
            return cell
        }
        else{
            return TableViewCell()
        }
    }
    

    func getMessage(controller: SelectViewController, lat: Double, long: Double, region: String)
    {
        receiveString = region
        latReceiveData = lat
        longReceiveData = long
        
        if (latReceiveData == 0 && longReceiveData == 0){
            //change title
            self.cityLabel.text = "\(receiveString!)"

            FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(receiveString!)&mode=json&appid=da20170669c4c2578512fa84cce8ccab"
            //try
            forecasts.removeAll()
            downloadForecastData{
            
            }
        }
        else if (receiveString == "") {
            FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latReceiveData!)&lon=\(longReceiveData!)&mode=json&appid=da20170669c4c2578512fa84cce8ccab"
            forecasts.removeAll()
            
            //get city
            Alamofire.request(FORECAST_URL).responseJSON (completionHandler: {
                response in
                let result = response.result
                
                if let dict = result.value as? Dictionary<String, AnyObject>{
                    if let locationCity = dict["city"] as? Dictionary<String, AnyObject>{
                        self.cityLabel.text = "\(locationCity["name"] as! String),\(locationCity["country"] as! String)"

                    }
                }
            })
            
            //get informaion
            downloadForecastData{
                
            }
            //get city

            
            
            
        }
        

        if(region == "" && lat == 0 && long == 0)
        {
            let myAlert = UIAlertController(title: "null", message: "you need type", preferredStyle: .alert)
            self.present(myAlert, animated: true, completion: nil)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "passTableValue" {
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
            FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(self.latitude)&lon=\(self.longitude)&mode=json&appid=da20170669c4c2578512fa84cce8ccab"
            //initial location
            
            updateWeatherInfo(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            
            locationManager.stopUpdatingLocation()
            
            Alamofire.request(FORECAST_URL).responseJSON (completionHandler: {
                response in
                let result = response.result
                
                if let dict = result.value as? Dictionary<String, AnyObject>{
                    if let locationCity = dict["city"] as? Dictionary<String, AnyObject>{
                        self.cityLabel.text = "\(locationCity["name"] as! String),\(locationCity["country"] as! String)"
                        
                    }
                }
                
            })
            downloadForecastData{
                
            }
        }
    }
    
    func updateWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error)
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
