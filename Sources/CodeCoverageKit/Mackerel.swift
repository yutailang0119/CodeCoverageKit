//
//  Mackerel.swift
//  CodeCoverageKit
//
//  Created by Yutaro Muta on 2021/03/05.
//

import Foundation

public enum Mackerel {
    public enum MackerelError: Error {
        case forbidden
        case tooManyRequests
        case any

        init(statusCode: Int) {
            switch statusCode {
            case 403:
                self = .forbidden
            case 429:
                self = .tooManyRequests
            default:
                self = .any
            }
        }
    }
}

extension Mackerel {
    struct ServiceMetricsInput: Encodable {
        struct Metric: Encodable {
            let name: String
            let time: Date
            let value: Double

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
}
