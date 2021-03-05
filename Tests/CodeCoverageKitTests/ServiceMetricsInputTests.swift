//
//  ServiceMetricsInputTests.swift
//  CodeCocerageKitTests
//
//  Created by Yutaro Muta on 2021/03/05.
//

import XCTest
@testable import CodeCoverageKit

final class ServiceMetricsInputTests: XCTestCase {
    func testEncodeAsArray() throws {
        let date = Date()
        let metrics: [Mackerel.ServiceMetricsInput.Metric] = [
            .init(name: "foo", time: date, value: 10),
            .init(name: "bar", time: Date(timeInterval: -60 * 60, since: date), value: 0.1),
            .init(name: "baz", time: Date(timeInterval: -60 * 60 * 60, since: date), value: 11.11),
        ]
        let input = Mackerel.ServiceMetricsInput(metrics: metrics)
        let encoded = try JSONEncoder().encode(input)

        let json = String(data: encoded, encoding: .utf8)
        XCTAssertEqual(json, input.json)
    }
}

private extension Mackerel.ServiceMetricsInput {
    var json: String {
        "[\(metrics.map(\.json).joined(separator: ","))]"
    }
}

private extension Mackerel.ServiceMetricsInput.Metric {
    var json: String {
        "{\"name\":\"\(name)\",\"time\":\(time.timeIntervalSince1970),\"value\":\(value)}"
    }
}
