import WatchConnectivity

class ConnectivityProvider: NSObject, WCSessionDelegate {
    static let shared = ConnectivityProvider()

    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Error activating session: \(error.localizedDescription)")
        } else {
            print("Session activated with state: \(activationState)")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive.")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate. Activating again...")
        // Re-activate the session
        WCSession.default.activate()
    }

    func sendValues(temperature: Double, soc: Double, soh: Double, batteryPercentage: Double, lastCharge: String, batteryLife: String) {
        let values: [String: Any] = [
            "temperature": temperature,
            "soc": soc,
            "soh": soh,
            "batteryPercentage": batteryPercentage,
            "lastCharge": lastCharge,
            "batteryLife": batteryLife,
        ]

        do {
            let data = try JSONSerialization.data(withJSONObject: values, options: [])
            WCSession.default.sendMessage(["values": data], replyHandler: nil, errorHandler: { error in
                print("Error sending message: \(error.localizedDescription)")
            })
        } catch {
            print("Error serializing values: \(error.localizedDescription)")
        }
    }
}
