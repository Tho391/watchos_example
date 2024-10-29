import SwiftUI

struct BatteryMetricsView: View {
    @StateObject private var viewModel: BatteryMetricsViewModel // Accept viewModel as a parameter
    
    init(viewModel: BatteryMetricsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel) // Initialize the StateObject
        
        // Set up observers for notifications
        NotificationCenter.default.addObserver(forName: .temperatureUpdated, object: nil, queue: .main) { notification in
            if let newTemperature = notification.object as? Double {
                viewModel.temperature = newTemperature
                print("Updated Temperature: \(newTemperature)") // Debugging line
            }
        }
        
        NotificationCenter.default.addObserver(forName: .socUpdated, object: nil, queue: .main) { notification in
            if let newSoc = notification.object as? Double {
                viewModel.soc = newSoc
                print("Updated SoC: \(newSoc)") // Debugging line
            }
        }
        
        NotificationCenter.default.addObserver(forName: .sohUpdated, object: nil, queue: .main) { notification in
            if let newSoh = notification.object as? Double {
                viewModel.soh = newSoh
                print("Updated SoH: \(newSoh)") // Debugging line
            }
        }
        
        NotificationCenter.default.addObserver(forName: .lastChargeUpdated, object: nil, queue: .main) { notification in
            if let newLastCharge = notification.object as? String {
                viewModel.lastCharge = newLastCharge
                print("Updated Last Charge: \(newLastCharge)") // Debugging line
            }
        }
        
        NotificationCenter.default.addObserver(forName: .batteryLifeUpdated, object: nil, queue: .main) { notification in
            if let newBatteryLife = notification.object as? String {
                viewModel.batteryLife = newBatteryLife
                print("Updated Battery Life: \(newBatteryLife)") // Debugging line
            }
        }
        
        NotificationCenter.default.addObserver(forName: .batteryPercentageUpdated, object: nil, queue: .main) { notification in
            if let newBatteryPercentage = notification.object as? Double {
                viewModel.batteryPercentage = newBatteryPercentage
                print("Updated Battery Percentage: \(newBatteryPercentage)") // Debugging line
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                // Temperature Display
                CircularProgressView(value: viewModel.temperature, label: "Temp",isTemperature: true,isColorful: true, color: Color.green)
                
                // SOC Display
                CircularProgressView(value: viewModel.soc, label: "SoC", color: Color.green)
                
                // SOH Display
                CircularProgressView(value: viewModel.soh, label: "SoH", color: Color.green)
            }.padding()
                .frame(maxWidth:.infinity)
            
            Divider()
            
            // Battery Status with Icon
            HStack {
                Image(systemName: batteryImage(for: viewModel.batteryPercentage))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                
                VStack(alignment: .leading) {
                    Text("Battery is low")
                        .font(.system(size: 12.0))
                        .foregroundColor(.red)
                    Text("Please charge")
                        .font(.system(size: 12.0))
                    Text("Last charge: \(viewModel.lastCharge)")
                        .font(.system(size: 10.0))
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            
            Divider()
            
            // Battery Life
            HStack(spacing: 10) {
                // Timer Icon and Text
                VStack {
                    Image(systemName: "timer")
                    
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    
                    Text("Battery Life")
                        .font(.system(size: 12.0))
                        .foregroundColor(.white)
                }
                .multilineTextAlignment(.center) // Center the text
                
                // Right Vertical Line
                Rectangle()
                    .frame(width: 1, height: 30)
                    .foregroundColor(.gray)
                
                // Right Side: Battery Life Text
                VStack {
                    Text(viewModel.batteryLife)
                        .font(.system(size: 12.0))
                        .foregroundColor(.white)
                        .padding()
                }
                .multilineTextAlignment(.center) // Center the text
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
    
    // Function to determine the appropriate battery image based on the percentage
    private func batteryImage(for percentage: Double) -> String {
        switch percentage {
        case 0..<20:
            return "battery.0"
        case 20..<40:
            return "battery.25"
        case 40..<60:
            return "battery.50"
        case 60..<80:
            return "battery.75"
        case 80...100:
            return "battery.100"
        default:
            return "battery.100" // Fallback image
        }
    }
    
    private func CircularProgressView(value: Double, label: String, isTemperature: Bool = false, isColorful: Bool = false, color: Color = .green) -> some View {
        VStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.green)
            
            ZStack {
                // Circle with gradient border
                if isColorful && isTemperature {
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "#5AC8FA"), // 0 degrees
                                    Color(hex: "#04DE71"), // 39.49 degrees
                                    Color(hex: "#FFE620"), // 68.9 degrees
                                    Color(hex: "#FF9500"), // 103.65 degrees
                                    Color(hex: "#FA114F"), // 152.76 degrees
                                    Color(hex: "#AA00FF"), // 180.58 degrees
                                    Color(hex: "#5AC8FA"),  // 360 degrees
                                    Color(hex: "#000000"),
                                    Color(hex: "#000000"),
                                ]),
                                center: .center,
                                angle: .degrees(0)
                            ),
                            style: StrokeStyle(lineWidth: 6.0, lineCap: .butt)
                        )
                        .rotationEffect(.degrees(145))
                        .frame(width: 40, height: 40)
                    
                    Circle()
                        .trim(from: 0, to: 0.001) // Dot trimmed to 10%
                        .stroke(Color.gray, style: StrokeStyle(lineWidth: 7.0, lineCap: .round))
                        .rotationEffect(.degrees(Double((145 + CGFloat(100.0 / 252 * 100).rounded()))))
                        .frame(width: 40, height: 40)
//                        .offset(y: -20) // Pos
                } else {
                    // Gray circle below the current circle for non-colorful and non-temperature case
                    // Circle with trimmed stroke
                    Circle()
                        .trim(from: 0.0, to: 0.70)
                        .stroke(Color.gray, style: StrokeStyle(lineWidth: 6.0, lineCap: .butt)) // Green color
                        .rotationEffect(.degrees(145)) // Rotate to start from the top
                        .frame(width: 40, height: 40)
                    
                    // Current value circle
                    Circle()
                        .trim(from: 0, to: CGFloat(value / 145))
                        .stroke(color, style: StrokeStyle(lineWidth: 6.0, lineCap: .butt)) // Solid color stroke with rounded line cap
                        .rotationEffect(.degrees(145))
                        .frame(width: 40, height: 40)
                }
                
                // Inner Circle (solid color)
                Circle()
                    .fill(Color.clear) // Keep the inner part clear or use a specific color if needed
                    .frame(width: 40, height: 40)
                
                // Display the value with unit
                Text("\(value, specifier: "%.0f")\(isTemperature ? "°" : "%")") // Use ° for temperature
                    .font(.system(size: 12))
                    .fontWeight(.bold)
            }
        }
    }
    
    
    
    
    
    
}

#Preview {
    let viewModel = BatteryMetricsViewModel()
    BatteryMetricsView(viewModel: viewModel)
}
