//
//  WeatherApiService.swift
//  MyWeather
//
//  Created by Abiodun Osagie on 04/05/2025.
//

import Foundation
import CoreLocation

class WeatherAPIService {
    // MARK: - Properties
    private let apiKey = "0cd049838d1c3a6340dec0295370a525" // Replace with your API key
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    
    // MARK: - API Methods
    func fetchCurrentWeather(for city: String) async throws -> CurrentWeatherResponse {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw WeatherError.invalidCity
        }
        
        let urlString = "\(baseURL)/weather?q=\(encodedCity)&units=metric&appid=\(apiKey)"
        return try await performRequest(with: urlString)
    }
    
    func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> CurrentWeatherResponse {
        let urlString = "\(baseURL)/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
        return try await performRequest(with: urlString)
    }
    
    func fetchForecast(latitude: Double, longitude: Double) async throws -> ForecastResponse {
        let urlString = "\(baseURL)/forecast?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
        return try await performRequest(with: urlString)
    }
    
    func fetchForecast(for city: String) async throws -> ForecastResponse {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw WeatherError.invalidCity
        }
        
        let urlString = "\(baseURL)/forecast?q=\(encodedCity)&units=metric&appid=\(apiKey)"
        return try await performRequest(with: urlString)
    }
    
    // MARK: - Private Methods
    private func performRequest<T: Decodable>(with urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 401 {
                throw WeatherError.invalidAPIKey
            } else if httpResponse.statusCode == 404 {
                throw WeatherError.cityNotFound
            } else {
                throw WeatherError.serverError(statusCode: httpResponse.statusCode)
            }
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw WeatherError.decodingError(error)
        }
    }
}

// MARK: - Error Types
enum WeatherError: Error, LocalizedError {
    case invalidURL
    case invalidCity
    case invalidResponse
    case invalidAPIKey
    case cityNotFound
    case decodingError(Error)
    case serverError(statusCode: Int)
    case locationError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidCity:
            return "Invalid city name"
        case .invalidResponse:
            return "Invalid response from the server"
        case .invalidAPIKey:
            return "Invalid API key"
        case .cityNotFound:
            return "City not found"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .locationError(let error):
            return "Location error: \(error.localizedDescription)"
        }
    }
}
