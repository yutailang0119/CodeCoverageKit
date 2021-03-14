//
//  ServiceMetricsAction.swift
//  MackerelKit
//
//  Created by Yutaro Muta on 2021/03/09.
//

import Foundation

public struct ServiceMetricsAction: MackerelAction {
    public struct Input: Encodable {
        public struct Metric: Encodable {
            let name: String
            let time: Date
            let value: Decimal

            private enum CodingKeys: String, CodingKey {
                case name
                case time
                case value
            }

            public init(name: String, time: Date, value: Decimal) {
                self.name = name
                self.time = time
                self.value = value
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(name, forKey: .name)
                try container.encode(time.timeIntervalSince1970, forKey: .time)
                try container.encode(value, forKey: .value)
            }
        }

        let metrics: [Metric]

        public init(metrics: [Metric]) {
            self.metrics = metrics
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(metrics)
        }
    }

    public let session: URLSession
    public let apiURL: URL?
    public let apiKey: String
    public let userAgent: String?
    public let body: Data?
    private let serviceName: String
    private let metricName: String

    public init(session: URLSession,
                apiURL: URL?,
                apiKey: String,
                userAgent: String?,
                serviceName: String,
                metricName: String,
                body: Data?) {
        self.session = session
        self.apiURL = apiURL
        self.apiKey = apiKey
        self.userAgent = userAgent
        self.serviceName = serviceName
        self.metricName = metricName
        self.body = body
    }
}

extension ServiceMetricsAction {
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
            "User-Agent": userAgent ?? _userAgent,
            "Content-Type": "application/json",
        ]
    }

    public var request: URLRequest {
        var components = URLComponents(url: apiURL ?? _apiURL,
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
