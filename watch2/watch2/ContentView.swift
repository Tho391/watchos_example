
import SwiftUI

struct ContentView: View {
    var body: some View {
        SliderControlView()
            .onAppear {
            _ = ConnectivityProvider.shared // Ensure the provider is initialized
        }
    }
}

#Preview {
    ContentView()
}
