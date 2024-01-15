//
//  ThreadItem.swift
//  ChainOfGoodness
//
//  Created by Raunaq Vyas on 2023-06-07.
//

import SwiftUI

struct ThreadItem: View {
    var namespace: Namespace.ID
    var thread: Thread
    @Binding var show: Bool
    @EnvironmentObject var threadService: ThreadService
    

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: 12) {
                Text(thread.title)
                    .font(.largeTitle.weight(.bold))
                    .matchedGeometryEffect(id: "title\(thread.id)", in: namespace)
                .frame(maxWidth: .infinity, alignment: .leading)
                Text("Created By: \(thread.displayName)")
                    .font(.footnote.weight(.semibold))
                    .matchedGeometryEffect(id: "createdBy\(thread.id)", in: namespace)
                Text(thread.description)
                    .font(.footnote)
                    .matchedGeometryEffect(id: "description\(thread.id)", in: namespace)
            }
            .padding(20)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .blur(radius: 30)
                    .matchedGeometryEffect(id: "blur\(thread.id)", in: namespace)
            )
        }
        .foregroundStyle(.white)
        // Fix s3 uplaod
        // .background(
        //     Image(thread.image)
        //         .resizable()
        //         .aspectRatio(contentMode: .fit)
        //         .padding(20)
        //         .matchedGeometryEffect(id: "image\(thread.id)", in: namespace)
        // )
        // .background(
        //     Image(thread.background)
        //         .resizable()
        //         .aspectRatio(contentMode: .fill)
        //         .matchedGeometryEffect(id: "background\(thread.id)", in: namespace)
        // )
        .background(
            Image(systemName: "")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(20)
                .matchedGeometryEffect(id: "image\(thread.id)", in: namespace)
        )
        .background(
            Rectangle()
                .fill(Color(hex:thread.Colour))
                .matchedGeometryEffect(id: "background\(thread.id)", in: namespace)
        )

        
        .mask(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .matchedGeometryEffect(id: "mask\(thread.id)", in: namespace)
        )
        .frame(height: 300)
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(thread.content, id: \.self) { content in
                switch content.type {
                case "heading":
                    Text(content.content)
                        .font(.title)
                        .bold()
                case "subheading":
                    Text(content.content)
                        .font(.title2)
                        .bold()
                case "paragraph":
                    Text(content.content)
                case "image":
                    // Assuming the content is a URL string to an image
                    if let url = URL(string: content.content) {
                        AsyncImage(url: url)
                    }
                default:
                    // Default case
                    Text(content.content)
                }
            }
        }
        .padding(20)
    }
    
    
}


struct ThreadItem_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        ThreadItem(namespace: namespace, thread: Thread(id: "1", title: "Sample", description: "Sample Description", content: [], link: "Sample Link", createdBy: "Sample Creator", createdAt: "2023-06-06T19:57:40.707Z", updatedAt: "2023-06-06T23:40:25.625Z", likes: [],Colour:"#FFFFFF", displayName: "SAMPLE NAME"), show: .constant(true))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255
        )
    }
}

