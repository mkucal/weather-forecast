//
//  HourlyForecastView.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 21/05/2023.
//

import SwiftUI

struct HourlyForecastView: View {

    let forecastViewModel: HourlyForecastViewModel?

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                let data = forecastViewModel?.data ?? []
                ForEach(0..<data.count, id: \.self) { index in
                    HourlyForecastItemView(forecastViewModel: data[index])
                }
            }
        }
    }
}
