//
//  ForecastView.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 21/05/2023.
//

import SwiftUI

struct ForecastView: View {

    let forecastViewModel: WeatherForecastViewModel?

    var body: some View {
        List {
            Section(NSLocalizedString("Hourly forecast", comment: "")) {
                HourlyForecastView(forecastViewModel: forecastViewModel?.hourlyForecast)
                    .padding(.vertical, 10)
            }

            let data = forecastViewModel?.dailyForecast?.data ?? []

            Section("\(data.count) day forecast") {
                ForEach(0..<data.count, id: \.self) { index in
                    DailyForecastItemView(forecastViewModel: data[index])
                }
            }
        }
    }
}
