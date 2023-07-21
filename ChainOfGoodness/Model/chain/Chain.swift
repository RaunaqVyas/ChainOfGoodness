//
//  Chain.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-04-09.
//

import SwiftUI

struct Chain: Identifiable {
    let id = UUID()
    var title: String
    var subtitle: String
    var text: String
    var image: String
    var background: String
    var logo: String
}

var featuredChains = [
    Chain(title: "Who we are", subtitle: "", text: "Learn more about our company and our goals ...", image: "Illustration 5", background: "Background 5", logo: "person.2.fill"),
    Chain(title: "Why we do this", subtitle: "Insight on the why", text: "Chain of goodness is a company that... ", image: "Illustration 3", background: "Background 4", logo: "person.2.fill"),
    Chain(title: "This App", subtitle: "What this app is", text: "The goal of this app is to inspire..", image: "Illustration 1", background: "Background 1", logo: "person.2.fill")
]

var chains = [
    Chain(title: "SwiftUI for iOS 15", subtitle: "20 sections - 3 hours", text: "Build an iOS app for iOS 15 with custom layouts, animations and ...", image: "Illustration 9", background: "Background 5", logo: "Logo 2"),
    Chain(title: "React Hooks Advanced", subtitle: "20 sections - 3 hours", text: "Learn how to build a website with Typescript, Hooks, Contentful and Gatsby Cloud", image: "Illustration 2", background: "Background 3", logo: "Logo 3"),
    Chain(title: "UI Design for iOS 15", subtitle: "20 sections - 3 hours", text: "Design an iOS app for iOS 15 with custom layouts, animations and ...", image: "Illustration 3", background: "Background 4", logo: "Logo 4"),
    Chain(title: "Flutter for designers", subtitle: "20 sections - 3 hours", text: "Flutter is a relatively new toolkit that makes it easy to build cross-platform apps that look gorgeous and is easy to use.", image: "Illustration 1", background: "Background 1", logo: "Logo 1"),
]
