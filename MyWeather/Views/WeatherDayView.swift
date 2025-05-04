//
//  WeatherDayView.swift
//  MyWeather
//
//  Created by Abiodun Osagie on 04/05/2025.
//

import SwiftUI

struct WeatherDayView: View {
    // MARK: - PROPERTIES
    var mode: DayTimeMode
    var weatherTitle: String
    var weatherIamge: Image
    var temperature: Int
    
    var body: some View {
        
        VStack {
            Text(weatherTitle.uppercased())
                .font(.caption)
                .foregroundStyle(.white)
                .bold()
            weatherIamge
                .font(.system(size: 30))
                .foregroundStyle(.white)
                .frame(width: 50, height: 50)
            Text("\(temperature)°")
                .bold()
                .foregroundStyle(.white)
        }
    }
}

