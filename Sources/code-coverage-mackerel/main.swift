import Foundation
import CodeCoverageKit

let environment = Environment()
guard let data = FileManager.default.contents(atPath: environment.codecovFilePath) else {
    fatalError("")
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
                                      serverURL: environment.serverURL,
                                      serviceName: environment.serviceName,
                                      graphName: environment.graphName,
                                      coverage: coverage)
    action.run { result in
        switch result {
        case .success:
            print("Success")
        case .failure(let error):
            print(error)
        }
    }
} catch {
    print(error)
}
