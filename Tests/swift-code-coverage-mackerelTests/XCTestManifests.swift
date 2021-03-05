import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(swift_code_coverage_mackerelTests.allTests),
    ]
}
#endif
