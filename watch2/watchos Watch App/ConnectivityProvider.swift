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

//    func sessionDidBecomeInactive(_ session: WCSession) {
//        print("Session did become inactive.")
//    }
//    
//    func sessionDidDeactivate(_ session: WCSession) {
//        print("Session did deactivate.")
//        // Re-activate the session
//        WCSession.default.activate()
//    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let data = message["values"] as? Data {
            do {
                if let values = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Received values: \(values)") // Add this line to check received values
                    if let temperature = values["temperature"] as? Double {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .temperatureUpdated, object: temperature)
                        }
                    }
                    if let soc = values["soc"] as? Double {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .socUpdated, object: soc)
                        }
                    }
                    if let soh = values["soh"] as? Double {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .sohUpdated, object: soh)
                        }
                    }
                    if let lastCharge = values["lastCharge"] as? String {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .lastChargeUpdated, object: lastCharge)
                        }
                    }
                    if let batteryLife = values["batteryLife"] as? String {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .batteryLifeUpdated, object: batteryLife)
                        }
                    }
                    if let batteryPercentage = values["batteryPercentage"] as? Double {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .batteryPercentageUpdated, object: batteryPercentage)
                        }
                    }
                }
            } catch {
                print("Error deserializing values: \(error.localizedDescription)")
            }
        }
    }
}

extension Notification.Name {
    static let temperatureUpdated = Notification.Name("temperatureUpdated")
    static let socUpdated = Notification.Name("socUpdated")
    static let sohUpdated = Notification.Name("sohUpdated")
    static let lastChargeUpdated = Notification.Name("lastChargeUpdated")
    static let batteryLifeUpdated = Notification.Name("batteryLifeUpdated")
    static let batteryPercentageUpdated = Notification.Name("batteryPercentageUpdated")
}
