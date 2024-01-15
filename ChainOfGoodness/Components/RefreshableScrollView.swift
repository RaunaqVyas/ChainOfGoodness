//
//  RefreshableScrollView.swift
//  ChainOfGoodness
//
//  Created by Raunaq Vyas on 2024-01-15.
//

import SwiftUI

struct RefreshableScrollView<Content: View>: View {
    var content: Content
    var onRefresh: () -> Void

    @State private var isRefreshing = false

    init(@ViewBuilder content: () -> Content, onRefresh: @escaping () -> Void) {
        self.content = content()
        self.onRefresh = onRefresh
    }

    var body: some View {
        ScrollView {
            VStack {
                if isRefreshing {
                    ProgressView()
                        .padding()
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                }

                GeometryReader { geometry in
                    Color.clear.preference(key: ViewOffsetKey.self, value: geometry.frame(in: .global).minY)
                }
                .frame(width: 0, height: 0)

                content
            }
        }
        .onPreferenceChange(ViewOffsetKey.self) { value in
            if value > 1 && !isRefreshing { // adjust pull down distance if needed
                isRefreshing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.onRefresh()
                    self.isRefreshing = false
                }
            }
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
