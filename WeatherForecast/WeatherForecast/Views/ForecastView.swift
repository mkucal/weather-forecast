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

            let title = String(format: NSLocalizedString("%d day forecast", comment: ""), data.count)

            Section(title) {
                ForEach(0..<data.count, id: \.self) { index in
                    DailyForecastItemView(forecastViewModel: data[index])
                }
            }
        }
    }
}
