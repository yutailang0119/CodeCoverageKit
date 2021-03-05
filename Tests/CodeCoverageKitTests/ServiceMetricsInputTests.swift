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

        let json = try JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
        XCTAssertNotNil(json as? [Any])
    }
}
