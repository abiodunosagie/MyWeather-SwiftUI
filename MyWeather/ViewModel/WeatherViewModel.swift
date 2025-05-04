//
//  WeatherViewModel.swift
//  MyWeather
//
//  Created by Abiodun Osagie on 04/05/2025.
//

import Foundation

import CoreLocation
import SwiftUI

class WeatherViewModel: ObservableObject {
    // MARK: - Properties
    @Published var currentWeather: CurrentWeatherResponse?
    @Published var forecasts: [DailyForecast] = []
    @Published var isLoading = false
    @Published var error: WeatherError?
    @Published var showError = false
    @Published var cityName = "Loading..."
    @Published var mode: DayTimeMode = .day
    
    private let weatherService = WeatherAPIService()
    private let locationManager = LocationManager()
    
    // MARK: - Init
    init() {
        setupLocationSubscription()
    }
    
    // MARK: - Public Methods
    func fetchWeatherForCurrentLocation() {
        locationManager.requestLocation()
    }
    
    func fetchWeather(for city: String) {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.error = nil
            }
            
            do {
                let weatherData = try await weatherService.fetchCurrentWeather(for: city)
                
                // Get location coordinates for forecast
                let lat = weatherData.coord.lat
                let lon = weatherData.coord.lon
                
                // Fetch forecast with coordinates for more accuracy
                let forecastData = try await weatherService.fetchForecast(latitude: lat, longitude: lon)
                
                await MainActor.run {
                    self.currentWeather = weatherData
                    self.forecasts = forecastData.dailyForecasts()
                    self.cityName = weatherData.cityName
                    self.mode = weatherData.dayTimeMode
                    self.isLoading = false
                }
            } catch let weatherError as WeatherError {
                await handleError(weatherError)
            } catch {
                await handleError(.decodingError(error))
            }
        }
    }
    
    func fetchWeatherFromLocation(latitude: Double, longitude: Double) {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.error = nil
            }
            
            do {
                let weatherData = try await weatherService.fetchCurrentWeather(latitude: latitude, longitude: longitude)
                let forecastData = try await weatherService.fetchForecast(latitude: latitude, longitude: longitude)
                
                await MainActor.run {
                    self.currentWeather = weatherData
                    self.forecasts = forecastData.dailyForecasts()
                    self.cityName = weatherData.cityName
                    self.mode = weatherData.dayTimeMode
                    self.isLoading = false
                }
            } catch let weatherError as WeatherError {
                await handleError(weatherError)
            } catch {
                await handleError(.decodingError(error))
            }
        }
    }
    
    func toggleMode() {
        mode = mode == .day ? .night : .day
    }
    
    // MARK: - Private Methods
    private func setupLocationSubscription() {
        // Observer for location updates
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self = self else { return }
                self.fetchWeatherFromLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
            .cancel()
        
        // Observer for city name updates
        locationManager.$cityName
            .filter { !$0.isEmpty }
            .sink { [weak self] cityName in
                guard let self = self else { return }
                self.cityName = cityName
            }
            .cancel()
        
        // Observer for location errors
        locationManager.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                guard let self = self else { return }
                Task {
                    await self.handleError(.locationError(error))
                }
            }
            .cancel()
    }
    
    private func handleError(_ error: WeatherError) async {
        await MainActor.run {
            self.error = error
            self.showError = true
            self.isLoading = false
            
            // If we failed to get weather for a specific reason, fall back to a default city
            if self.currentWeather == nil {
                self.fetchWeather(for: "London") // Default fallback
            }
        }
    }
}
