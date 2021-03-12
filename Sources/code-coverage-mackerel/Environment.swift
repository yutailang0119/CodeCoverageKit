import Foundation

struct Environment {
    let apiURL: URL
    let apiKey: String
    let userAgent: String?
    let serviceName: String
    let metricName: String
    let codecovFilePath: String

    init() {
        let mackerelAPIURL = ProcessInfo.processInfo.environment["MACKEREL_API_URL"] ?? "https://api.mackerelio.com/"
        guard let apiURL = URL(string: mackerelAPIURL),
              let apiKey = ProcessInfo.processInfo.environment["MACKEREL_API_KEY"],
              let serviceName = ProcessInfo.processInfo.environment["MACKEREL_SERVICE_NAME"],
              let metricName = ProcessInfo.processInfo.environment["MACKEREL_METRIC_NAME"],
              let codecovFilePath = ProcessInfo.processInfo.environment["CODECOV_FILE_PATH"] else {
            fatalError("Please set environment variables")
        }

        self.apiURL = apiURL
        self.apiKey = apiKey
        self.userAgent = ProcessInfo.processInfo.environment[""]
        self.serviceName = serviceName
        self.metricName = metricName
        self.codecovFilePath = codecovFilePath
    }
}
