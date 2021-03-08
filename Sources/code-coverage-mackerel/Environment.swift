import Foundation

struct Environment {
    let serverURL: URL
    let apiKey: String
    let userAgent: String?
    let serviceName: String
    let graphName: String
    let codecovFilePath: String

    init() {
        let mackerelServerURL = ProcessInfo.processInfo.environment[""] ?? "https://api.mackerelio.com/"
        guard let serverURL = URL(string: mackerelServerURL),
              let apiKey = ProcessInfo.processInfo.environment[""],
              let serviceName = ProcessInfo.processInfo.environment[""],
              let graphName = ProcessInfo.processInfo.environment[""],
              let codecovFilePath = ProcessInfo.processInfo.environment[""] else {
            fatalError()
        }

        self.serverURL = serverURL
        self.apiKey = apiKey
        self.userAgent = ProcessInfo.processInfo.environment[""]
        self.serviceName = serviceName
        self.graphName = graphName
        self.codecovFilePath = codecovFilePath
    }
}
