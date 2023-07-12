//
//  ThreadView.swift
//  ChainOfGoodness
//
//  Created by Raunaq Vyas on 2023-06-07.
//

import SwiftUI

struct ThreadView: View {
    var namespace: Namespace.ID
    var thread: Thread
    @Binding var show: Bool
    @State var appear = [false, false, false]
    @State var viewState: CGSize = .zero
    @State var isDraggable = true
    @EnvironmentObject var model : Model
    
    let colorPalette: [Color] = [
        Color(hex: "#c5aae7"),
        Color(hex: "#7896f0"),
        Color(hex: "#94a6f2"),
        Color(hex: "#dc94db"),
        Color(hex: "#a8aff0"),
        Color(hex: "#dd9ee0"),
        Color(hex: "#7db4f4"),
        Color(hex: "#ccc4e9"),
        Color(hex: "#c4a5d2"),
    ]

    var body: some View {
        ZStack {
            
            ScrollView {
                cover
                content
            
                    .offset(y: 120)
                    .padding(.bottom, 200)
                    .opacity(appear[2] ? 1 : 0)
            }
            .coordinateSpace(name: "scroll")
            .background(Color("Background"))
            .mask(RoundedRectangle(cornerRadius: viewState.width / 3, style: .continuous))
            .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 10)
            .scaleEffect(viewState.width / -500 + 1)
            .background(.black.opacity(viewState.width / 500))
            .background(.ultraThinMaterial)
            .gesture(isDraggable ? drag : nil)
            .ignoresSafeArea()
            button
        }
        .onAppear {
            fadeIn()
        }
        .onChange(of: show) { newValue in
            fadeOut()
        }
    }
    // ... (remaining similar to ChainView)
    
    var cover: some View {
        GeometryReader { proxy in
            let scrollY = proxy.frame(in:.named("scroll")).minY
            VStack {
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: scrollY > 0 ? 500 + scrollY : 500)
            .foregroundStyle(.black)
            .background(
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                    .frame(maxWidth: 500)
                    .matchedGeometryEffect(id: "image\(thread.id)", in: namespace)
                    .offset(y: scrollY > 0 ? scrollY * -0.8 : 0)
            )
            .background(
                Rectangle()
                    .fill(colorPalette.randomElement() ?? Color.white)
                    .matchedGeometryEffect(id: "background\(thread.id)", in: namespace)
                    .matchedGeometryEffect(id: "background\(thread.id)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0 )
                    .blur(radius:scrollY/10)
                )
            .mask(
                RoundedRectangle(cornerRadius:  appear[0] ? 0 : 30, style: .continuous)
                    .matchedGeometryEffect(id: "mask", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
            )
            .overlay(
                overlayContent
                    .offset(y: scrollY > 0 ? scrollY * -0.6 : 0)
        )
        }
        .frame(height: 500)
    }
    
    
    var button: some View {
        Button {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                show.toggle()
                model.showDetail.toggle()
                
            }
        } label: {
            Image(systemName: "xmark")
                .font(.body.weight(.bold))
                .foregroundColor(.secondary)
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(20)
    }
    
    var overlayContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(thread.title)
            
                .font(.largeTitle.weight(.bold))
                .matchedGeometryEffect(id: "title\(thread.id)", in: namespace)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(thread.createdBy.uppercased())
                .font(.footnote.weight(.semibold))
                .matchedGeometryEffect(id: "subtitle\(thread.id)", in: namespace)
            Text(thread.description)
                .font(.footnote)
                .matchedGeometryEffect(id: "text\(thread.id)", in: namespace)
            Divider()
                .opacity(appear[0] ? 1 : 0)
            HStack {
                Image("Avatar Default")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .cornerRadius(10)
                    .padding(8)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .strokeStyle(cornerRadius: 18)
                Text("Created by Raunaq Vyas")
                    .font(.footnote)
            }
            .opacity(appear[1] ? 1 : 0)
        }
            .padding(20)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .matchedGeometryEffect(id: "blur\(thread.id)", in: namespace)
            )
            .offset(y: 250)
            .padding(2)
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
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 30, coordinateSpace: .local)
        .onChanged{ value in
            guard value.translation.width > 0 else {return}
            if value.startLocation.x < 100 {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    viewState = value.translation
                }
                
            }
            
            if viewState.width > 120 {
                close()
            }
        }
        .onEnded{ value in
            if viewState.width > 80 {
                close()
                
            } else {
                withAnimation(.easeOut){
                    viewState = .zero
                    }
            }
        
            }
    }
    
    func fadeIn() {
        withAnimation(.easeOut.delay(0.3)) {
            appear[0] = true
        }
        withAnimation(.easeOut.delay(0.4)) {
            appear[1] = true
        }
        withAnimation(.easeOut.delay(0.5)) {
            appear[2] = true
        }
    }
    
    func fadeOut() {
        appear[0] = false
        appear[1] = false
        appear[2] = false
    }
    
    func close() {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                show.toggle()
                model.showDetail.toggle()
            }
        
        withAnimation(.easeOut){
            viewState = .zero
            }
        isDraggable = false
        }
   
}

struct ThreadView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        ThreadView(namespace: namespace, thread: Thread(id: "1", title: "Sample", description: "Sample Description", content: [], link: "Sample Link", createdBy: "Sample Creator", createdAt: "2023-06-06T19:57:40.707Z", updatedAt: "2023-06-06T23:40:25.625Z", likes: []), show: .constant(true))
    }
}
