import SwiftUI

struct SliderControlView: View {
    // State variables for the values controlled by sliders
    @State private var temperature: Double = 70.0 // Temperature in Celsius
    @State private var soc: Double = 75.0          // State of Charge in percentage
    @State private var soh: Double = 25.0          // State of Health in percentage
    @State private var batteryPercentage: Double = 75.0 // New variable for battery percentage
    @State private var lastCharge: String = "2 days ago"
    @State private var batteryLife: String = "300 days"

    var body: some View {
        VStack {
            // Slider for Temperature
            VStack {
                Text("Temperature: \(Int(temperature))°C")
                Slider(value: $temperature, in: 0...100, step: 1) { _ in
                    sendValues()
                }
                .padding()
            }

            // Slider for SoC
            VStack {
                Text("State of Charge (SoC): \(Int(soc))%")
                Slider(value: $soc, in: 0...100, step: 1) { _ in
                    sendValues()
                }
                .padding()
            }

            // Slider for SoH
            VStack {
                Text("State of Health (SoH): \(Int(soh))%")
                Slider(value: $soh, in: 0...100, step: 1) { _ in
                    sendValues()
                }
                .padding()
            }

            // Slider for Battery Percentage
            VStack {
                Text("Battery Percentage: \(Int(batteryPercentage))%")
                Slider(value: $batteryPercentage, in: 0...100, step: 1) { _ in
                    sendValues()
                }
                .padding()
            }

            // Slider for Last Charge (days)
            VStack {
                Text("Last Charge: \(lastCharge)")
                Slider(value: Binding(
                    get: { Double(lastCharge.prefix(1)) ?? 0 },
                    set: { newValue in lastCharge = "\(Int(newValue)) days ago" }
                ), in: 0...30, step: 1) { _ in
                    sendValues()
                }
                .padding()
            }

            // Slider for Battery Life (days)
            VStack {
                Text("Battery Life: \(batteryLife)")
                Slider(value: Binding(
                    get: { Double(batteryLife.prefix(3)) ?? 0 },
                    set: { newValue in batteryLife = "\(Int(newValue)) days" }
                ), in: 0...365, step: 1) { _ in
                    sendValues()
                }
                .padding()
            }
        }
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
    
    // Function to send values to the ConnectivityProvider
    // In SliderControlView
    private func sendValues() {
        print("Sending values - Temperature: \(temperature), SoC: \(soc), SoH: \(soh), Battery Percentage: \(batteryPercentage), Last Charge: \(lastCharge), Battery Life: \(batteryLife)")
        ConnectivityProvider.shared.sendValues(
            temperature: temperature,
            soc: soc,
            soh: soh,
            batteryPercentage: batteryPercentage,
            lastCharge: lastCharge,
            batteryLife: batteryLife
        )
    }
}

#Preview {
    SliderControlView()
}
