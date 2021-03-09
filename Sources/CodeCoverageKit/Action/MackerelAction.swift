//
//  MackerelAction.swift
//  CodeCoverageKit
//
//  Created by Yutaro Muta on 2021/03/05.
//

import Foundation

public protocol MackerelAction {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var httpMethod: String { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var request: URLRequest { get }
}
