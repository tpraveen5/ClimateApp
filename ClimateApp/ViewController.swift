//
//  ViewController.swift
//  ClimateApp
//
//  Created by Talari Praveen kumar on 05/01/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tfUserInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func onTapSubmit(_ sender: Any) {
        let city = tfUserInput.text ?? ""
        if city.isEmpty {
            Alert.makeWithAppNameTitle(and: "Please enter city name", title: "Alert")
                .action(.default("Ok", { _ in
                }), isPreferred: false)
                .show(on: self)
        } else {
            if let weather = SBMain.instantiateViewController(withIdentifier:"WeatherDetailsVC") as? WeatherDetailsVC
            {
                weather.city = city
                self.navigationController?.pushViewController(weather, animated: true)
            }
        }
    }
}
