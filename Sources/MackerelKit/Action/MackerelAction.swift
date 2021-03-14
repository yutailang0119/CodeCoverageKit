//
//  MackerelAction.swift
//  MackerelKit
//
//  Created by Yutaro Muta on 2021/03/05.
//

import Foundation

public protocol MackerelAction {
    var session: URLSession { get }
    var apiURL: URL? { get }
    var apiKey: String { get }
    var userAgent: String? { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var httpMethod: String { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var request: URLRequest { get }
}

extension MackerelAction {
    var _apiURL: URL {
        URL(string: "https://api.mackerelio.com/")!
    }

    var _userAgent: String {
        "swiftpm-code-coverage-mackerel"
    }
}

extension MackerelAction {
    public func run(completion: @escaping (Result<Void, ActionError>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error: error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noHTTPResponse))
                return
            }
            switch httpResponse.statusCode {
            case 200..<300:
                completion(.success(()))
            default:
                let mackarelError = MackerelError(statusCode: httpResponse.statusCode)
                completion(.failure(.mackerel(error: mackarelError)))
            }
        }
        .resume()
    }
}
