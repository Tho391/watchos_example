import Combine

class BatteryMetricsViewModel: ObservableObject {
    @Published var temperature: Double = 70.0       // Temperature in Celsius
    @Published var soc: Double = 75.0                // State of Charge in percentage
    @Published var soh: Double = 25.0                // State of Health in percentage
    @Published var lastCharge: String = "2 days ago" // Last charge time
    @Published var batteryLife: String = "300 days"  // Battery life
    @Published var batteryPercentage: Double = 75.0   // Battery percentage

    // Initializer or any other methods can be added here if needed
}
