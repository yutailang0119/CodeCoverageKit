//
//  ActionError.swift
//  MackerelKit
//
//  Created by Yutaro Muta on 2021/03/09.
//

import Foundation

public enum ActionError: Error {
    case mackerel(error: MackerelError)
    case noHTTPResponse
    case unknown(error: Error)
}
