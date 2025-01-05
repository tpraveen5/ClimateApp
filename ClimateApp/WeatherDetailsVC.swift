//
//  WeatherDetailsVC.swift
//  ClimateApp
//
//  Created by Talari Praveen kumar on 05/01/25.
//

import UIKit

class WeatherDetailsVC: UIViewController {

    @IBOutlet weak var currentCityEnteredByUser: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    private let weatherService = WeatherService()
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var lblDayOne: UILabel!
    @IBOutlet weak var lblDayThree: UILabel!
    @IBOutlet weak var lblDayTwo: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var city:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading(true)
        fetchWeather(city: self.city ?? "")
        fetchThreeDayForecast(city: self.city ?? "")
    }
    
    private func fetchWeather(city:String) {
        weatherService.fetchCurrentWeather(for: city) { [weak self] currentWeather in
            DispatchQueue.main.async {
                self?.showLoading(false)
                if let currentWeather = currentWeather {
                    self?.updateCurrentWeatherUI(with: currentWeather)
                } else {
                    self?.showError("Failed to load current weather.")
                }
            }
        }
    }
    
    private func fetchThreeDayForecast(city: String) {
        weatherService.fetchForecast(for: city) { [weak self] forecastResponse in
            DispatchQueue.main.async {
                if let forecastResponse = forecastResponse {
                    self?.updateForecastUI(with: forecastResponse)
                } else {
                    self?.showError("Failed to load 3-day forecast.")
                }
            }
        }
    }
    
    private func updateCurrentWeatherUI(with weather: CurrentWeatherResponse) {
        currentCityEnteredByUser.text = "City: \(weather.name)"
        lblTemperature.text = "Temperature: \(weather.main.temp)°C"
        lblCondition.text = "Condition: \(weather.weather.first?.description ?? "")"
    }

    private func updateForecastUI(with forecastResponse: ForecastResponse) {
        // Dictionary to store unique dates and their corresponding forecasts
        var dateForecastMap: [String: (temp: Double, description: String)] = [:]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Input format from dt_txt
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM dd" // Desired output format
        
        for forecast in forecastResponse.list {
            // Parse the dt_txt to extract the date
            if let date = formatter.date(from: forecast.dt_txt) {
                let formattedDate = outputFormatter.string(from: date)
                
                // Store the first forecast of each unique date
                if dateForecastMap[formattedDate] == nil {
                    let temp = forecast.main.temp
                    let description = forecast.weather.first?.description ?? "N/A"
                    dateForecastMap[formattedDate] = (temp, description)
                }
            }
        }
        
        // Get the sorted forecast details
        let sortedForecasts = dateForecastMap.sorted(by: { $0.key < $1.key })
        
        // Safely assign to labels
        if sortedForecasts.indices.contains(0) {
            let dayOne = sortedForecasts[0]
            lblDayOne.text = "\(dayOne.key): \(dayOne.value.temp)°C, \(dayOne.value.description)"
        } else {
            lblDayOne.text = "No data"
        }
        
        if sortedForecasts.indices.contains(1) {
            let dayTwo = sortedForecasts[1]
            lblDayTwo.text = "\(dayTwo.key): \(dayTwo.value.temp)°C, \(dayTwo.value.description)"
        } else {
            lblDayTwo.text = "No data"
        }
        
        if sortedForecasts.indices.contains(2) {
            let dayThree = sortedForecasts[2]
            lblDayThree.text = "\(dayThree.key): \(dayThree.value.temp)°C, \(dayThree.value.description)"
        } else {
            lblDayThree.text = "No data"
        }
    }

    
    private func setupUI() {
        currentCityEnteredByUser.text = "City: "
        lblTemperature.text = "Loading current weather..."
        lblCondition.text = "Loading forecast..."
        lblError.text = ""
        loadingIndicator.startAnimating()
        loadingIndicator.hidesWhenStopped = true
    }
    
    private func showLoading(_ isLoading: Bool) {
        loadingIndicator.isHidden = !isLoading
        //lblError.isHidden = isLoading
    }
    
    private func showError(_ message: String) {
        lblError.text = message
        lblError.isHidden = false
    }

    @IBAction func onTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
