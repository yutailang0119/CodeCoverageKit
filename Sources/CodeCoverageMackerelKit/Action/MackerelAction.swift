//
//  MackerelAction.swift
//  CodeCoverageMackerelKit
//
//  Created by Yutaro Muta on 2021/03/05.
//

import Foundation

public protocol MackerelAction {
    var session: URLSession { get }
    var apiURL: URL { get }
    var apiKey: String { get }
    var userAgent: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var httpMethod: String { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var request: URLRequest { get }
}
