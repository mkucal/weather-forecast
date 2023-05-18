//
//  Parameters.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 18/05/2023.
//

import Foundation

enum HttpEncoding {
    case json
    case url
}

struct Parameters {
    let encoding: HttpEncoding

    private var internalStorage = [String: Any]()
    private var urlParameters = [String: String]()

    init(encoding: HttpEncoding) {
        self.encoding = encoding
    }

    subscript(key: String) -> Any? {
        get { return internalStorage[key] }
        set(value) { internalStorage[key] = value }
    }

    mutating func setParameters(params: [String: Any]?) {
        internalStorage = params ?? [String: Any]()
    }

    mutating func setHeaderParameter(key: String, value: String) {
        internalStorage[key] = value
    }

    mutating func setUrlParameter(key: String, value: String) {
        urlParameters[key] = value
    }
}

extension Parameters {

    var queryItems: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        if encoding == .url {
            queryItems.append(contentsOf: internalStorage.map { (key: String, value: Any) -> URLQueryItem in
                return URLQueryItem(name: key, value: value as? String ?? "")
            })
        }

        if !urlParameters.isEmpty {
            queryItems.append(contentsOf: urlParameters.map { (key: String, value: String) -> URLQueryItem in
                return URLQueryItem(name: key, value: value)
            })
        }

        return queryItems
    }
}

extension Parameters {

    var body: Data? {
        guard encoding == .json && JSONSerialization.isValidJSONObject(internalStorage) else { return nil }
        return try? JSONSerialization.data(withJSONObject: internalStorage, options: .prettyPrinted)
    }
}
