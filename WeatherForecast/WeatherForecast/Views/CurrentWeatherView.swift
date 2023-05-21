//
//  CurrentWeatherView.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 21/05/2023.
//

import SwiftUI

struct CurrentWeatherView: View {

    let address: String
    let weatherViewModel: CurrentWeatherViewModel?

    var body: some View {
        VStack(spacing: 10) {
            Text(address)
                .font(.title2)
            Text(weatherViewModel?.temperature ?? "")
                .font(.system(size: 50))
            Image(systemName: weatherViewModel?.weatherStateIconName ?? "")
                .font(.title2)
            Text(weatherViewModel?.weatherStateDesc ?? "")
                .font(.callout)
        }
    }
}
