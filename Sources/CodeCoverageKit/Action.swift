//
//  Action.swift
//  CodeCoverageKit
//
//  Created by Yutaro Muta on 2021/03/14.
//

import Foundation
import MackerelKit

public struct Action {
    private let coverage: CodeCov.Coverage
    private let tracker: Tracker

    public init(coverage: CodeCov.Coverage, tracker: Tracker) {
        self.coverage = coverage
        self.tracker = tracker
    }

    public func run(completion: @escaping (Result<Void, ActionError>) -> Void) {
        switch tracker {
        case .mackerel(let mackerel):
            let action = ServiceMetricsAction(session: URLSession.shared,
                                              apiURL: mackerel.apiURL,
                                              apiKey: mackerel.apiKey,
                                              userAgent: mackerel.userAgent,
                                              serviceName: mackerel.serviceName,
                                              metricName: mackerel.metricName,
                                              body: mackerel.data(coverage))
            action.run { result in
                completion(result.mapError(ActionError.init(error:)))
            }

        }
    }
}
