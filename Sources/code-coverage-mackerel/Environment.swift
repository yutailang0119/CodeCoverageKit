import Foundation

struct Environment {
    let apiURL: URL
    let apiKey: String
    let userAgent: String?
    let serviceName: String
    let metricName: String
    let codecovFilePath: String

    init() {
        let mackerelAPIURL = ProcessInfo.processInfo.environment[""] ?? "https://api.mackerelio.com/"
        guard let apiURL = URL(string: mackerelAPIURL),
              let apiKey = ProcessInfo.processInfo.environment[""],
              let serviceName = ProcessInfo.processInfo.environment[""],
              let metricName = ProcessInfo.processInfo.environment[""],
              let codecovFilePath = ProcessInfo.processInfo.environment[""] else {
            fatalError()
        }

        self.apiURL = apiURL
        self.apiKey = apiKey
        self.userAgent = ProcessInfo.processInfo.environment[""]
        self.serviceName = serviceName
        self.metricName = metricName
        self.codecovFilePath = codecovFilePath
    }
}
