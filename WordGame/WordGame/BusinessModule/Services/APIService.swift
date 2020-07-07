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
    func getDataFromURL(_ endPoint: EndPoint) -> AnyPublisher<Data, APIError>
}

final class APIService: APIServiceProtocol {

    func getDataFromURL(_ endPoint: EndPoint) -> AnyPublisher<Data, APIError> {

        var dataTask: URLSessionDataTask?

        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }

        return Future<Data, APIError> { promise in

            guard let url = endPoint.url else {
                return promise(.failure(APIError.invalidURL))
            }
            /// Check is internet available
            if !Utilities.isInternetAvailable() {
                promise(.failure(APIError.noNetwork))
                return
            }
            /// Set URLRequest and type
            var request = URLRequest(url: url)
            request.httpMethod = endPoint.method.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let data = endPoint.data {
                request.httpBody = data
            }

            dataTask = URLSession.shared.dataTask(with: request) { (data, response, _) in

                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    promise(.failure(APIError.checkErrorCode((response as? HTTPURLResponse)!.statusCode)))
                    return
                }
                guard data != nil else {
                    promise(.failure(APIError.noData))
                    return
                }

                promise(.success(data!))
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
