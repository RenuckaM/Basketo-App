
import Model
import Routing
import SwiftUI
import DesignSystem

public struct BallPickerView: View {
    @Coordinator var coordinator
    @StateObject var viewModel: BallPickerViewModel

    public init(dependency: BallPickerDependency) {
        self._viewModel = StateObject(wrappedValue: dependency.viewModel)
    }

    var colums: [GridItem] = {
        Array(
            repeating: GridItem(.flexible(), spacing: 20),
            count: 3
        )
    }()

    public var body: some View {
        VStack(spacing: 0) {
            // Custom NavBar with white font and cross icon on the right
            ZStack {
                Text("Basketballs")
                    .font(.custom("Baskerville-Italic", size: 42))
                    .foregroundColor(.white)

                HStack {
                    Spacer() // Push the cross to the right
                    Button(action: {
                        $coordinator.dismiss()
                    }) {
                        Image(systemName: "xmark") // Cross icon
                            .foregroundColor(.white) // White color for cross
                            .font(.system(size: 22, weight: .bold)) // Small size and bold weight
                            .padding(10) // Padding around the icon for better tap area
                            .background(Color.black.opacity(0.6), in: Circle()) // Circle background with opacity
                            .clipShape(Circle()) // Ensure the background is circular
                    }
                    .padding(.trailing, 16) // Add padding to slightly push it to the right
                }
            }
            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: colums, spacing: 20) {
                        ForEach(viewModel.balls) { ball in
                            ballGridView(ball, in: proxy)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                }
            }
        }
        .background {
            Image.loadImage(.doodleArt)
                .renderingMode(.template)
                .foregroundColor(.of(.nonPhotoBlue).opacity(0.5))
        }
        .background(Color.blue, ignoresSafeAreaEdges: .all)
    }

    @ViewBuilder
    private func ballGridView(_ ball: BallStyle, in proxy: GeometryProxy) -> some View {
        let size = proxy.size.width / 3 - 40
        Button {
            viewModel.selectBall(ball)
        } label: {
            Image.loadBall(ball.rawValue)
                .frame(maxWidth: size, minHeight: size)
                .background(Color(red: 233 / 255, green: 236 / 255, blue: 239 / 255))
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(red: 0 / 255, green: 53 / 255, blue: 84 / 255), lineWidth: 4)
                }
        }
        .buttonStyle(.default)
        .disabled(ball == viewModel.selectedBall)
        .overlay(alignment: .bottom) {
            if ball == viewModel.selectedBall {
                Label {
                    Text("Selected")
                } icon: {
                    Image.loadImage(.checkmarkCircleFill)
                }
                .font(.of(.caption2))
                .foregroundColor(.of(.olive))
                .padding(3)
                .background {
                    Capsule()
                        .foregroundColor(.white)
                }
                .offset(y: 10)
                .transition(.scale)
            }
        }
    }
}
