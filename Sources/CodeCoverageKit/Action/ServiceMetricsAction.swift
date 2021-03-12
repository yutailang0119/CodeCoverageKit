//
//  ServiceMetricsAction.swift
//  CodeCoverageKit
//
//  Created by Yutaro Muta on 2021/03/09.
//

import Foundation

public struct ServiceMetricsAction: MackerelAction {
    public let session: URLSession
    public let apiURL: URL
    public let apiKey: String
    public let userAgent: String
    private let serviceName: String
    private let metricName: String
    private let coverage: CodeCov.Coverage

    public init(session: URLSession,
                apiKey: String,
                userAgent: String?,
                apiURL: URL,
                serviceName: String,
                metricName: String,
                coverage: CodeCov.Coverage) {
        self.session = session
        self.apiKey = apiKey
        self.userAgent = userAgent ?? "swiftpm-code-coverage-mackerel"
        self.apiURL = apiURL
        self.serviceName = serviceName
        self.metricName = metricName
        self.coverage = coverage
    }

    public func run(completion: @escaping (Result<String, ActionError>) -> Void) {
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
                let message = """
                Success recording to \(serviceName)/\(metricName)
                - functions: \(coverage.totals.functions.percent)
                - instantiations: \(coverage.totals.instantiations.percent)
                - lines: \(coverage.totals.lines.percent)
                - regions: \(coverage.totals.regions.percent)
                """
                completion(.success(message))
            default:
                let mackarelError = Mackerel.MackerelError(statusCode: httpResponse.statusCode)
                completion(.failure(.mackerel(error: mackarelError)))
            }
        }
        .resume()
    }
}

extension ServiceMetricsAction {
    struct Input: Encodable {
        struct Metric: Encodable {
            let name: String
            let time: Date
            let value: Decimal

            private enum CodingKeys: String, CodingKey {
                case name
                case time
                case value
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(name, forKey: .name)
                try container.encode(time.timeIntervalSince1970, forKey: .time)
                try container.encode(value, forKey: .value)
            }
        }

        let metrics: [Metric]

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(metrics)
        }
    }

    public var path: String {
        "/api/v0/services/\(serviceName)/tsdb"
    }

    public var queryItems: [URLQueryItem]? {
        nil
    }

    public var httpMethod: String {
        "POST"
    }

    public var headers: [String: String] {
        [
            "X-Api-Key": apiKey,
            "User-Agent": userAgent,
            "Content-Type": "application/json",
        ]
    }

    public var body: Data? {
        let date = Date()
        let input = Input(metrics: [
            .init(name: "\(metricName).functions", time: date, value: Decimal(coverage.totals.functions.percent)),
            .init(name: "\(metricName).instantiations", time: date, value: Decimal(coverage.totals.instantiations.percent)),
            .init(name: "\(metricName).lines", time: date, value: Decimal(coverage.totals.lines.percent)),
            .init(name: "\(metricName).regions", time: date, value: Decimal(coverage.totals.regions.percent)),
        ])
        return try? JSONEncoder().encode(input)
    }

    public var request: URLRequest {
        var components = URLComponents(url: apiURL,
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
