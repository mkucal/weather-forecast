//
//  Array+Utils.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 20/05/2023.
//

import Foundation

extension Array {

    subscript (safe index: Index) -> Element? {
        return 0 <= index && index < count ? self[index] : nil
    }
}
