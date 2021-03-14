import Foundation
import CodeCoverageKit

let environment = Environment()
guard let data = FileManager.default.contents(atPath: environment.codecovFilePath) else {
    print("Can not read file")
    exit(1)
}

do {
    let codecov = try JSONDecoder().decode(CodeCov.self, from: data)
    guard let coverage = codecov.data.first else {
        print("Not Found to code coverage")
        exit(1)
    }
    let mackerel = Tracker.Mackerel(apiURL: environment.apiURL,
                                    apiKey: environment.apiKey,
                                    userAgent: environment.userAgent,
                                    serviceName: environment.serviceName,
                                    metricName: environment.metricName)
    let action = Action(coverage: coverage, tracker: .mackerel(mackerel))
    let semaphore = DispatchSemaphore(value: 0)
    action.run { result in
        switch result {
        case .success:
            let message = """
            Success recording to \(environment.serviceName)/\(environment.metricName)
            - functions: \(coverage.totals.functions.percent)
            - instantiations: \(coverage.totals.instantiations.percent)
            - lines: \(coverage.totals.lines.percent)
            - regions: \(coverage.totals.regions.percent)
            """
            print(message)
        case .failure(let error):
            print(error)
            exit(1)
        }
        semaphore.signal()
    }
    semaphore.wait()
} catch {
    print(error)
    exit(1)
}
