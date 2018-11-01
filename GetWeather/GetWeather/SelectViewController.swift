//
//  SelectViewController.swift
//  GetWeather
//
//  Created by 許雅筑 on 2017/7/24.
//  Copyright © 2017年 hsu.ya.chu. All rights reserved.
//

import UIKit

protocol GetMessageDelegate:NSObjectProtocol
{
    
    func getMessage(controller:SelectViewController,lat:Double, long:Double,region:String)
}

class SelectViewController: UIViewController {
    
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    
    var delegate:GetMessageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        latitudeTextField?.text = "0"
        longitudeTextField?.text = "0"
        regionTextField?.text = ""
        
        latitudeTextField?.isEnabled = true
        longitudeTextField?.isEnabled = true
        regionTextField?.isEnabled = false
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //close keyboard
        latitudeTextField?.resignFirstResponder()
        longitudeTextField?.resignFirstResponder()
        regionTextField?.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func ToggleAction(_ sender: UISegmentedControl) {
        //segment button
        if sender.selectedSegmentIndex == 0 {
            latitudeTextField?.isEnabled = true
            longitudeTextField?.isEnabled = true
            regionTextField?.isEnabled = false
        }
        else{
            latitudeTextField?.isEnabled = false
            longitudeTextField?.isEnabled = false
            regionTextField?.isEnabled = true
        }
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        //        if latitudeTextField.text != "" && longitudeTextField.text != "" || regionTextField.text != ""{
        //use delegate
        if(delegate != nil)
        {

            delegate?.getMessage(controller: self, lat: Double(latitudeTextField.text!)!, long: Double(longitudeTextField.text!)!, region: (regionTextField!.text!))
            
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    @IBAction func closeView(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
