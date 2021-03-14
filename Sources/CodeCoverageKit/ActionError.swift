//
//  ActionError.swift
//  CodeCoverageKit
//
//  Created by Yutaro Muta on 2021/03/14.
//

import Foundation
import enum MackerelKit.ActionError

public enum ActionError: Error {
    case tracker(error: Error)
    case noHTTPResponse
    case unknown(error: Error)
}

extension ActionError {
    init(error: MackerelKit.ActionError) {
        switch error {
        case .mackerel(let error):
            self = .tracker(error: error)
        case .noHTTPResponse:
            self = .noHTTPResponse
        case .unknown(let error):
            self = .unknown(error: error)
        }
    }
}
