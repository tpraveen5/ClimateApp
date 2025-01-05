//
//  WeatherModel.swift
//  ClimateApp
//
//  Created by Talari Praveen kumar on 05/01/25.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    let main: MainWeatherData
    let weather: [Weather]
    let name: String // City name
    
    struct MainWeatherData: Decodable {
        let temp: Double // Temperature
        let humidity: Int // Humidity
    }
    
    struct Weather: Decodable {
        let description: String // Weather description (e.g., "Clear sky")
    }
}

struct ForecastResponse: Decodable {
    let list: [Forecast]
    
    struct Forecast: Decodable {
        let dt: Int // Unix timestamp
        let main: MainWeatherData
        let weather: [Weather]
        let dt_txt: String
        struct MainWeatherData: Decodable {
            let temp: Double // Temperature
        }
        
        struct Weather: Decodable {
            let description: String // Weather description
        }
    }
}
