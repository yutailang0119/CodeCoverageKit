//
//  MackerelError.swift
//  MackerelKit
//
//  Created by Yutaro Muta on 2021/03/05.
//

import Foundation

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
