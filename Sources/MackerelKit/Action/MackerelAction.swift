//
//  MackerelAction.swift
//  MackerelKit
//
//  Created by Yutaro Muta on 2021/03/05.
//

import Foundation

public protocol MackerelAction {
    var session: URLSession { get }
    var apiURL: URL? { get }
    var apiKey: String { get }
    var userAgent: String? { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var httpMethod: String { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var request: URLRequest { get }
}

extension MackerelAction {
    var _apiURL: URL {
        URL(string: "https://api.mackerelio.com/")!
    }

    var _userAgent: String {
        "swiftpm-code-coverage-mackerel"
    }
}