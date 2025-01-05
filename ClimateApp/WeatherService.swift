//
//  WeatherService.swift
//  ClimateApp
//
//  Created by Talari Praveen kumar on 05/01/25.
//

import Foundation


class WeatherService {
    
    // Fetch current weather
    func fetchCurrentWeather(for city: String, completion: @escaping (CurrentWeatherResponse?) -> Void) {
        let urlString = "\(baseUrl)weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching weather data: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(CurrentWeatherResponse.self, from: data)
                completion(weatherResponse)
            } catch {
                print("Error decoding weather data: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    // Fetch 3-day forecast
    func fetchForecast(for city: String, completion: @escaping (ForecastResponse?) -> Void) {
        let urlString = "\(baseUrl)forecast?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching forecast data: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            
            do {
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(forecastResponse)
            } catch {
                print("Error decoding forecast data: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}

