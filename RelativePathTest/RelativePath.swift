
import SwiftUI

struct RelativePath: Shape {

    private let relativePath: Path

    init(_ callback: (inout Path) -> ()) {
        var path = Path()
        callback(&path)
        relativePath = path
    }

    init(elements: [Path.Element]) {
        relativePath = Path(elements: elements)
    }

    func path(in rect: CGRect) -> Path {

        // Return a path with absolute points relative to the given rect.
        relativePath.map { element in

            element.map { point in

                CGPoint(x: rect.origin.x + point.x * rect.size.width,
                        y: rect.origin.y + point.y * rect.size.height)
            }
        }
    }
}

// MARK: - Path Extensions

extension Path {

    /// Creates a path using an array of Path.Element.
    ///
    /// - Parameter elements: An array of elements.
    init(elements: [Element]) {
        self.init { path in
            elements.forEach { path.append($0) }
        }
    }

    /// Append the element to the path.
    ///
    /// - Parameter element: The element to append.
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

    /// Transform the path's elements.
    ///
    /// - Parameter transform: The function to use to transform each element.
    func map(_ transform: (Element) -> Element) -> Path {
        Path { path in
            forEach { element in
                path.append(transform(element))
            }
        }
    }
}

extension Path.Element {

    /// Transform each point in each element.
    ///
    /// - Parameter transform: The function to use to transform each point.
    func map(_ transform: (CGPoint) -> CGPoint) -> Path.Element {

        switch self {

        case let .move(to):
            return .move(to: transform(to))

        case let .line(to):
            return .line(to: transform(to))

        case let .quadCurve(to, control):
            return .quadCurve(to: transform(to),
                              control: transform(control))

        case let .curve(to, control1, control2):
            return .curve(to: transform(to),
                          control1: transform(control1),
                          control2: transform(control2))

        case .closeSubpath:
            return .closeSubpath

        @unknown default:
            fatalError()
        }
    }
}
