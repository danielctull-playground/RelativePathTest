//
//  ContentView.swift
//  PathShapeTest
//
//  Created by Daniel Tull on 15/06/2019.
//  Copyright © 2019 Daniel Tull. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        Text("Hello World")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
