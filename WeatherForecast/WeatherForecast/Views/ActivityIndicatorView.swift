//
//  ActivityIndicatorView.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 21/05/2023.
//

import SwiftUI

struct ActivityIndicatorView: View {

    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .frame(width: 120, height: 120)
            .background(Color.gray.brightness(0.3))
            .cornerRadius(8)
    }
}
