//
//  DailyForecastItemView.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 21/05/2023.
//

import SwiftUI

struct DailyForecastItemView: View {

    let forecastViewModel: SpecifiedDayForecastViewModel?

    var body: some View {
        HStack {
            Text(forecastViewModel?.date ?? "")
                .font(.callout)
                .padding(.vertical, 10)
                .frame(maxWidth: 100, alignment: .leading)
                .background(.white)
            Spacer()
            Image(systemName: forecastViewModel?.weatherStateIconName ?? "")
                .font(.title2)
            Spacer()

            let temperatureStr = (forecastViewModel?.temperatureMin ?? "")
            + " / " + (forecastViewModel?.temperatureMax ?? "")
            Text(temperatureStr)
                .frame(maxWidth: 120, alignment: .trailing)
                .background(.white)
        }
    }
}
