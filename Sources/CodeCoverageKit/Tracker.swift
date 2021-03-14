//
//  Tracker.swift
//  CodeCoverageKit
//
//  Created by Yutaro Muta on 2021/03/14.
//

import Foundation
import struct MackerelKit.ServiceMetricsAction

public enum Tracker {
    public struct Mackerel {
        let apiURL: URL?
        let apiKey: String
        let userAgent: String?
        let serviceName: String
        let metricName: String

        public init(apiURL: URL?,
                    apiKey: String,
                    userAgent: String?,
                    serviceName: String,
                    metricName: String) {
            self.apiURL = apiURL
            self.apiKey = apiKey
            self.userAgent = userAgent
            self.serviceName = serviceName
            self.metricName = metricName
        }

        func data(_ coverage: CodeCov.Coverage) -> Data? {
            let date = Date()
            let input = ServiceMetricsAction.Input(metrics: [
                .init(name: "\(metricName).functions", time: date, value: Decimal(coverage.totals.functions.percent)),
                .init(name: "\(metricName).instantiations", time: date, value: Decimal(coverage.totals.instantiations.percent)),
                .init(name: "\(metricName).lines", time: date, value: Decimal(coverage.totals.lines.percent)),
                .init(name: "\(metricName).regions", time: date, value: Decimal(coverage.totals.regions.percent)),
            ])
            return try? JSONEncoder().encode(input)
        }
    }

    case mackerel(Mackerel)
}
