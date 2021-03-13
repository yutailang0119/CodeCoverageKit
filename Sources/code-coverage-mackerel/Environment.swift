import Foundation

struct Environment {
    let apiURL: URL?
    let apiKey: String
    let userAgent: String?
    let serviceName: String
    let metricName: String
    let codecovFilePath: String

    init() {
        guard let apiKey = ProcessInfo.processInfo.environment["MACKEREL_API_KEY"],
              let serviceName = ProcessInfo.processInfo.environment["MACKEREL_SERVICE_NAME"],
              let metricName = ProcessInfo.processInfo.environment["MACKEREL_METRIC_NAME"],
              let codecovFilePath = ProcessInfo.processInfo.environment["CODECOV_FILE_PATH"] else {
            fatalError("Please set environment variables")
        }

        self.apiURL = ProcessInfo.processInfo.environment["MACKEREL_API_URL"].flatMap(URL.init(string:))
        self.apiKey = apiKey
        self.userAgent = ProcessInfo.processInfo.environment["MACKEREL_USER_AGENT"]
        self.serviceName = serviceName
        self.metricName = metricName
        self.codecovFilePath = codecovFilePath
    }
}
