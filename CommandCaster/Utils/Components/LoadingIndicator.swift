import SwiftUICore

struct LoadingIndicator: View {
    
    @State var alternar: Bool = false
    
    private let height: CGFloat = 3
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.blue.opacity(0.2))
                .frame(height: height)

            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width / 3, height: height)
                    .offset(x: alternar ? geometry.size.width - geometry.size.width / 3 : 0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: alternar)
            }
        }
        .frame(height: height)
        .onAppear { alternar = true }
        .onDisappear { alternar = false }
    }
}
