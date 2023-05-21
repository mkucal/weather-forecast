//
//  HourlyForecastItemView.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 21/05/2023.
//

import SwiftUI

struct HourlyForecastItemView: View {

    let forecastViewModel: SpecifiedHourForecastViewModel?

    var body: some View {
        VStack(spacing: 4) {
            Text(forecastViewModel?.time ?? "")
            Image(systemName: forecastViewModel?.weatherStateIconName ?? "")
                .font(.title2)
            Text(forecastViewModel?.temperature ?? "")
        }
        .padding(.vertical, 10)
        .frame(width: 90)
        .background(Color.gray.brightness(0.3))
        .cornerRadius(8)
    }
}
