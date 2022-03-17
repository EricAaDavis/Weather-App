//
//  APIRequest.swift
//  Weather App
//
//  Created by Eric Davis on 16/03/2022.
//

import Foundation

protocol APIRequest {
    associatedtype Response

    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var request: URLRequest { get }
}

extension APIRequest {
    var host: String { "api.openweathermap.org" }
}

extension APIRequest {
    var request: URLRequest {
        var components = URLComponents()

        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems

        let request = URLRequest(url: components.url!)
        return request
    }

}

extension APIRequest where Response: Decodable {
    func send(completion: @escaping (Result<Response, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            do {
                if let data = data {
                    let decoded = try JSONDecoder().decode(Response.self, from: data)
                    completion(.success(decoded))
                } else if let error = error {
                    print(error)
                    completion(.failure(error))
                }
            } catch {
                print("Catch")
            }
        }.resume()
    }
}
