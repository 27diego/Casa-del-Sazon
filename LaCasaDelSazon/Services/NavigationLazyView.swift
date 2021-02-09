//
//  NavigationLazyView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/8/21.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
