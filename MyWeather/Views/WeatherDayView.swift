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
    var weatherDegree: String
    
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
            Text("\(weatherDegree)°")
                .bold()
                .foregroundStyle(.white)
        }
    }
}

//#Preview {
//    WeatherDayView(
//        mode: .day,
//        weatherTitle: "TUE",
//        weatherIamge:Image(systemName: "cloud.sun.fill"),
//        weatherDegree: "25",
//    )
//}
