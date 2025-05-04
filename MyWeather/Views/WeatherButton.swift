//
//  WeatherButton.swift
//  MyWeather
//
//  Created by Abiodun Osagie on 04/05/2025.
//

import SwiftUI

struct WeatherButton: View {
    var mode: DayTimeMode
    var title: String
    var textColor: Color
    var buttonColor: Color
    var body: some View {
        Text(title)
            .foregroundStyle(textColor)
            .bold()
            .frame(width: 350, height: 50)
            .background(buttonColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    WeatherButton(
        mode: .day,
        title: "Switc to Dark Mode",
        textColor: .blue,
        buttonColor: .white
    )
}
