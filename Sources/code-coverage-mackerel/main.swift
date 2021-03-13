import Foundation
import CodeCoverageMackerelKit

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
    let action = ServiceMetricsAction(session: URLSession.shared,
                                      apiKey: environment.apiKey,
                                      userAgent: environment.userAgent,
                                      apiURL: environment.apiURL,
                                      serviceName: environment.serviceName,
                                      metricName: environment.metricName,
                                      coverage: coverage)
    let semaphore = DispatchSemaphore(value: 0)
    action.run { result in
        switch result {
        case .success(let value):
            print(value)
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
