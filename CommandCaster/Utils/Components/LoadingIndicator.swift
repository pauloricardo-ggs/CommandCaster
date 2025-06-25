ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(height: 3)

                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width / 3, height: 3)
                        .offset(x: alternar ? geometry.size.width - geometry.size.width / 3 : 0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: alternar)
                }
            }
            .frame(height: 3)
            .onAppear { alternar = true }
            .onDisappear { alternar = false }