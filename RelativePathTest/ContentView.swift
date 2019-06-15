
import SwiftUI

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        RelativePath(elements: [
            .move(to: CGPoint(x: 0, y: 0)),
            .line(to: CGPoint(x: 1, y: 1)),
            .line(to: CGPoint(x: 1, y: 0)),
            .closeSubpath
        ])
        .fill(Color.orange)
        .frame(width: 400, height: 200, alignment: .bottom)
    }
}
#endif
