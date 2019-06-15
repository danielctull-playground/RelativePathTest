
import SwiftUI

struct RelativePath: Shape {

    private let relative: Path
    public init(_ callback: (inout Path) -> ()) {
        var path = Path ()
        callback(&path)
        relative = path
    }

    func path(in rect: CGRect) -> Path {

        func convert(_ point: CGPoint) -> CGPoint {
            CGPoint(x: rect.origin.x + point.x * rect.size.width,
                    y: rect.origin.y + point.y * rect.size.height)
        }

        return Path { absolute in

            relative.forEach { element in

                switch element {
                case let .move(to):
                    absolute.move(to: convert(to))

                case let .line(to):
                    absolute.addLine(to: convert(to))

                case let .quadCurve(to, control):
                    absolute.addQuadCurve(to: convert(to),
                                          control: convert(control))

                case let .curve(to, control1, control2):
                    absolute.addCurve(to: convert(to),
                                      control1: convert(control1),
                                      control2: convert(control2))

                case .closeSubpath:
                    absolute.closeSubpath()

                @unknown default:
                    break
                }
            }

        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        RelativePath { path in
            path.move(to: .init(x: 0, y: 0))
            path.addLine(to: .init(x: 1, y: 1))
            path.addLine(to: .init(x: 1, y: 0))
            path.closeSubpath()
        }
        .fill(Color.orange)
        .frame(width: 400, height: 200, alignment: .bottom)
    }
}
#endif
