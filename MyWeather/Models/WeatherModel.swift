//
//  WeatherModel.swift
//  MyWeather
//
//  Created by Abiodun Osagie on 04/05/2025.
//

import Foundation

// MARK: - Current Weather Response
struct CurrentWeatherResponse: Codable {
    let coord: Coordinates
    let weather: [WeatherCondition]
    let main: MainWeather
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    var cityName: String {
        return name
    }
    
    var temperature: Double {
        return main.temp
    }
    
    var weatherIconName: String {
        guard let condition = weather.first else { return "cloud" }
        return mapConditionToIcon(condition.id, dt: dt, sunrise: sys.sunrise, sunset: sys.sunset)
    }
    
    var dayTimeMode: DayTimeMode {
        let currentTime = Date(timeIntervalSince1970: TimeInterval(dt))
        let sunrise = Date(timeIntervalSince1970: TimeInterval(sys.sunrise))
        let sunset = Date(timeIntervalSince1970: TimeInterval(sys.sunset))
        
        return (currentTime >= sunrise && currentTime < sunset) ? .day : .night
    }
    
    private func mapConditionToIcon(_ id: Int, dt: Int, sunrise: Int, sunset: Int) -> String {
        // Check if it's day or night
        let currentTime = dt
        let isDay = currentTime >= sunrise && currentTime < sunset
        
        // Map condition codes to SF Symbol names
        // Based on OpenWeatherMap condition codes: https://openweathermap.org/weather-conditions
        
        switch id {
        case 200...232: // Thunderstorm
            return "cloud.bolt.rain.fill"
        case 300...321: // Drizzle
            return "cloud.drizzle.fill"
        case 500...504: // Rain
            return "cloud.rain.fill"
        case 511: // Freezing rain
            return "cloud.sleet.fill"
        case 520...531: // Shower rain
            return "cloud.heavyrain.fill"
        case 600...622: // Snow
            return "cloud.snow.fill"
        case 701...781: // Atmosphere (fog, mist, etc.)
            return "cloud.fog.fill"
        case 800: // Clear
            return isDay ? "sun.max.fill" : "moon.stars.fill"
        case 801: // Few clouds
            return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case 802: // Scattered clouds
            return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case 803...804: // Broken clouds and overcast
            return "cloud.fill"
        default:
            return isDay ? "sun.max.fill" : "moon.stars.fill"
        }
    }
}

// MARK: - Forecast Response
struct ForecastResponse: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ForecastItem]
    let city: City
    
    func dailyForecasts() -> [DailyForecast] {
        let forecastsByDay = Dictionary(grouping: list) { item -> String in
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
        
        let sortedDays = forecastsByDay.keys.sorted()
        
        return sortedDays.compactMap { day -> DailyForecast? in
            // Ensure we exclude today's forecast
            _ = DateFormatter().date(from: day)
            guard let forecasts = forecastsByDay[day], !forecasts.isEmpty else { return nil }
            
            // Get middle of day forecast (around noon) if available
            let middayForecast = forecasts.first {
                let forecastDate = Date(timeIntervalSince1970: TimeInterval($0.dt))
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: forecastDate)
                return hour >= 11 && hour <= 14
            } ?? forecasts[0]
            
            // Calculate min/max temp for the day
            let minTemp = forecasts.min { $0.main.temp_min < $1.main.temp_min }?.main.temp_min ?? middayForecast.main.temp_min
            let maxTemp = forecasts.max { $0.main.temp_max < $1.main.temp_max }?.main.temp_max ?? middayForecast.main.temp_max
            
            // Use the representative forecast for weather condition
            let weatherCondition = middayForecast.weather.first ?? WeatherCondition(id: 800, main: "Clear", description: "clear sky", icon: "01d")
            
            return DailyForecast(
                date: Date(timeIntervalSince1970: TimeInterval(middayForecast.dt)),
                minTemp: minTemp,
                maxTemp: maxTemp,
                condition: weatherCondition,
                iconName: mapConditionToIcon(weatherCondition.id, isDay: true)
            )
        }
    }
    
    private func mapConditionToIcon(_ id: Int, isDay: Bool) -> String {
        // Same mapping as above but simplified
        switch id {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...504: return "cloud.rain.fill"
        case 511: return "cloud.sleet.fill"
        case 520...531: return "cloud.heavyrain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "cloud.fog.fill"
        case 800: return isDay ? "sun.max.fill" : "moon.stars.fill"
        case 801: return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case 802: return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case 803...804: return "cloud.fill"
        default: return isDay ? "sun.max.fill" : "moon.stars.fill"
        }
    }
}

// MARK: - Supporting Structures
struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct WeatherCondition: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainWeather: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct ForecastItem: Codable {
    let dt: Int
    let main: MainWeather
    let weather: [WeatherCondition]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let dt_txt: String
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinates
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}

// MARK: - Convenience Models
struct DailyForecast {
    let date: Date
    let minTemp: Double
    let maxTemp: Double
    let condition: WeatherCondition
    let iconName: String
    
    var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).lowercased()
    }
    
    var averageTemp: Int {
        return Int(round((minTemp + maxTemp) / 2))
    }
}
