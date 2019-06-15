
import SwiftUI

extension Path {

    mutating func append(_ element: Element) {

        switch element {

        case let .move(to):
            move(to: to)

        case let .line(to):
            addLine(to: to)

        case let .quadCurve(to, control):
            addQuadCurve(to: to, control: control)

        case let .curve(to, control1, control2):
            addCurve(to: to, control1: control1, control2: control2)

        case .closeSubpath:
            closeSubpath()

        @unknown default:
            break
        }
    }

    func map(_ transform: (Element) -> Element) -> Path {
        Path { path in
            forEach { element in
                path.append(transform(element))
            }
        }
    }
}

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

        return relative.map { element in

            switch element {
            case let .move(to):
                return .move(to: convert(to))

            case let .line(to):
                return .line(to: convert(to))

            case let .quadCurve(to, control):
                return .quadCurve(to: convert(to),
                                  control: convert(control))

            case let .curve(to, control1, control2):
                return .curve(to: convert(to),
                              control1: convert(control1),
                              control2: convert(control2))

            case .closeSubpath:
                return .closeSubpath

            @unknown default:
                fatalError()
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
