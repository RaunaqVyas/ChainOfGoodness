//
//  ChainView.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-04-30.
//

import SwiftUI

struct ChainView: View {
    var namespace: Namespace.ID
    var chain : Chain = chains[0]
    @Binding var show: Bool
    @State var appear = [false, false, false]
    @EnvironmentObject var model : Model
    @State var viewState : CGSize = .zero
    @State var isDraggable = true
   
    
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
            .onAppear { model.showDetail = true}
            .onDisappear{model.showDetail = false}
            .background(Color("Background"))
            .mask(RoundedRectangle(cornerRadius: viewState.width / 3 , style: .continuous))
            .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 10)
            .scaleEffect(viewState.width / -500 + 1)
            .background(.black.opacity(viewState.width / 500))
            .background(.ultraThinMaterial)
            .gesture( isDraggable ? drag : nil )
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
                Image(chain.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                    .frame(maxWidth: 500)
                    .matchedGeometryEffect(id: "image\(chain.id)", in: namespace)
                    .offset(y: scrollY > 0 ? scrollY * -0.8 : 0)
            )
            .background(
                Image(chain.background)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .matchedGeometryEffect(id: "background\(chain.id)", in: namespace)
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
    
    var content: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Chain of goodness is hands-down the best way for youth to take a first step into International Development and find a peice of kindness.")
                .font(.title3).fontWeight(.medium)
            Text("Who we are")
                .font(.title).bold()
            Text("CHAIN OF GOODNESS is a personal journey of me (Neetu Vyas),my husband (Raj Vyas) and our twins (Raunaq Vyas and Navya Vyas). I worked for United Nations (WHO) in Suriname (South America) for more then a decade. Working with communities where Governments, UN and many International agencies bring social reforms, I noticed a small sect of selfless people called “Volunteers” This App made by my son Raunaq is an effort to try and further motivate youth to become “Volunteers”.")
            Text("Be a cog")
                .font(.title).bold()
            Text("This app along with the blogs found on chainofgoodness.org are our efforts to motivate youth to volunteer and pursue careers in International Development. ")
        }
        .padding(20)
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
            Text(chain.title)
                .font(.largeTitle.weight(.bold))
                .matchedGeometryEffect(id: "title\(chain.id)", in: namespace)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(chain.subtitle.uppercased())
                .font(.footnote.weight(.semibold))
                .matchedGeometryEffect(id: "subtitle\(chain.id)", in: namespace)
            Text(chain.text)
                .font(.footnote)
                .matchedGeometryEffect(id: "text\(chain.id)", in: namespace)
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
                    .matchedGeometryEffect(id: "blur\(chain.id)", in: namespace)
            )
            .offset(y: 250)
            .padding(2)
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

struct CourseView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        ChainView(namespace: namespace, show: .constant(true))
            .environmentObject(Model())
        
    }
}
