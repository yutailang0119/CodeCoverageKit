//
//  MackerelAction.swift
//  CodeCoverageKit
//
//  Created by Yutaro Muta on 2021/03/05.
//

import Foundation

public struct MackerelAction {
    public enum ActionError: Error {
        case mackerel(error: Mackerel.MackerelError)
        case noHTTPResponse
        case unknown(error: Error)
    }

    private let session: URLSession
    private let apiKey: String
    private let userAgent: String
    private let serverURL: URL
    private let serviceName: String
    private let graphName: String
    private let coverage: CodeCov.Coverage

    public init(session: URLSession,
                apiKey: String,
                userAgent: String?,
                serverURL: URL,
                serviceName: String,
                graphName: String,
                coverage: CodeCov.Coverage) {
        self.session = session
        self.apiKey = apiKey
        self.userAgent = userAgent ?? "swiftpm-code-coverage-mackerel"
        self.serverURL = serverURL
        self.serviceName = serviceName
        self.graphName = graphName
        self.coverage = coverage
    }

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
                let mackarelError = Mackerel.MackerelError(statusCode: httpResponse.statusCode)
                completion(.failure(.mackerel(error: mackarelError)))
            }
        }
    }
}

extension MackerelAction {
    private var path: String {
        "/api/v0/services/\(serviceName)/tsdb"
    }

    private var queryItems: [URLQueryItem]? {
        nil
    }

    private var httpMethod: String {
        "POST"
    }

    private var headers: [String: String] {
        [
            "X-Api-Key": apiKey,
            "User-Agent": userAgent,
            "Content-Type": "application/json",
        ]
    }

    private var body: Data? {
        let date = Date()
        let input = Mackerel.ServiceMetricsInput(metrics: [
            .init(name: "\(graphName).functions", time: date, value: Decimal(coverage.totals.functions.percent)),
            .init(name: "\(graphName).instantiations", time: date, value: Decimal(coverage.totals.instantiations.percent)),
            .init(name: "\(graphName).lines", time: date, value: Decimal(coverage.totals.lines.percent)),
            .init(name: "\(graphName).regions", time: date, value: Decimal(coverage.totals.regions.percent)),
        ])
        return try? JSONEncoder().encode(input)
    }
    
    private var request: URLRequest {
        var components = URLComponents(url: serverURL,
                                       resolvingAgainstBaseURL: false)
        components?.path = path
        components?.queryItems = nil
        guard let url = components?.url else {
            fatalError("Invalid request URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
