import SwiftUI

struct GradientView: View {
    var body: some View {
        AngularGradient(
            gradient: Gradient(colors: [
                Color(hex: "#5AC8FA"),  // 0 degrees
                Color(hex: "#04DE71"),  // 39.49 degrees
                Color(hex: "#FFE620"),  // 68.9 degrees
                Color(hex: "#FF9500"),  // 103.65 degrees
                Color(hex: "#FA114F"),  // 152.76 degrees
                Color(hex: "#AA00FF"),  // 180.58 degrees
                Color(hex: "#5AC8FA")   // 360 degrees
            ]),
            center: .center,
            angle: .degrees(142.88)  // Starting angle
        )
        .frame(width: 300, height: 300) // Adjust size as needed
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

// Color extension to initialize colors from hex
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        // Skip the '#' character if it exists
        if hex.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.string.startIndex)
        }
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    GradientView()
}
