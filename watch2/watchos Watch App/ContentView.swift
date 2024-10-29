import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BatteryMetricsViewModel()

    var body: some View {
        BatteryMetricsView(viewModel: viewModel)
            .onAppear {
                _ = ConnectivityProvider.shared // Ensure the provider is initialized
            }
    }
}

#Preview {
    ContentView()
}
