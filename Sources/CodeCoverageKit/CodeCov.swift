//
//  CodeCov.swift
//  CodeCoverageKit
//
//  Created by Yutaro Muta on 2021/03/05.
//

import Foundation

public struct CodeCov: Decodable {
    public struct Coverage: Decodable {
        public struct Totals: Decodable {
            public struct Value: Decodable {
                public let count: Int
                public let covered: Int
                public let percent: Double

                public var notcovered: Int {
                    count - covered
                }
            }

            public let functions: Value
            public let instantiations: Value
            public let lines: Value
            public let regions: Value
        }

        let totals: Totals
    }

    public let data: [Coverage]
    public let type: String
    public let version: String
}
