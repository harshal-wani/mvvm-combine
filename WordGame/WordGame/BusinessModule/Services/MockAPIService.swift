//
//  MockAPIService.swift
//  WordGame
//
//  Created by Harshal Wani on 29/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation
import Combine

final class MockAPIService: APIServiceProtocol {
    func fetch<T>(_ endPoint: EndPoint) -> AnyPublisher<T, APIError> where T: Decodable {

        fetch(endPoint)
        .decode(type: T.self, decoder: JSONDecoder())
        .mapError { error in
            if let err = error as? DecodingError {
                return APIError(rawValue: APIError.parseDecodingError(err))!
            } else {
                return APIError.unknownError
            }
        }
        .eraseToAnyPublisher()
    }

    private func fetch(_ endPoint: EndPoint) -> AnyPublisher<Data, APIError> {

        return Future<Data, APIError> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let url = Bundle.main.url(forResource: "words", withExtension: "json")!
                do {
                    let data = try Data(contentsOf: url)
                    promise(.success(data))
                } catch {
                    promise(.failure(APIError.decodeError))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
