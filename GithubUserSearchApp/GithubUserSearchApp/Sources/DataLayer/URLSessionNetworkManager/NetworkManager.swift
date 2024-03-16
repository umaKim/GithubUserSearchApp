//
//  NetworkManager.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/24.
//

import Combine
import Foundation

final public class NetworkManager: NetworkService {
    public func fetch(from url: URL?) -> AnyPublisher<Data, URLSessionNetworkServiceError> {
        self.request(url: url)
    }
    
    public init() { }
}

// MARK: - General Request
extension NetworkManager {
    private func request(url: URL?) -> AnyPublisher<Data, URLSessionNetworkServiceError> {
        guard let url else { return Fail(outputType: Data.self, failure: .invalidURLError)
            .eraseToAnyPublisher() }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap {[weak self] data, response in
                guard let self else { throw URLSessionNetworkServiceError.unknownError }
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLSessionNetworkServiceError.timeoutError
                }
                
                guard 200...299 ~= httpResponse.statusCode else {
                    throw configureHTTPError(errorCode: httpResponse.statusCode)
                }
                
                return data
            }
            .mapError { _ in
                return URLSessionNetworkServiceError.unknownError
            }
            .eraseToAnyPublisher()
    }
    
    private func configureHTTPError(errorCode: Int) -> URLSessionNetworkServiceError {
        return URLSessionNetworkServiceError(rawValue: errorCode)
        ?? URLSessionNetworkServiceError.unknownError
    }
}
