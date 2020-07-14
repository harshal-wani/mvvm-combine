//
//  APIService.swift
//  WordGame
//
//  Created by Harshal Wani on 27/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    func fetch(_ endPoint: EndPoint) -> AnyPublisher<Data, APIError>
}

final class APIService: APIServiceProtocol {

    func fetch(_ endPoint: EndPoint) -> AnyPublisher<Data, APIError> {

        guard let url = endPoint.url else {
            return Fail(error: .invalidURL)
                .eraseToAnyPublisher()
        }
        /// Check is internet available
        if !Utilities.isInternetAvailable() {
            return Fail(error: .noNetwork)
                .eraseToAnyPublisher()
        }
        /// Set URLRequest and type
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let data = endPoint.data {
            request.httpBody = data
        }

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw (APIError.checkErrorCode((response as? HTTPURLResponse)!.statusCode))
                }
                return data
        }
        .mapError { error in
            if let error = error as? APIError {
                return error
            } else {
                return .unknownError
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
