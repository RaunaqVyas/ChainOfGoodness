//
//  HomeView.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-04-04.
//

import SwiftUI

struct HomeView: View {
    @State var hasScrolled = false
    @Namespace var namespace
    @State var show = false
    @State var showThread = false
    @State var showStatusBar = true
    @State var selectedID = UUID()
    @State var showChain = false
    @State var selectedIndex = 0
    @State var selectedThreadID = ""
    @State var userThreads: [Thread] = []
    @EnvironmentObject var model : Model
    @EnvironmentObject var sessionManager : SessionManager
    @EnvironmentObject var threadService : ThreadService
    

    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            RefreshableScrollView {
                scrollDetection
                
                featured
                
                Text("Chains".uppercased())
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 20)],spacing : 20) {
                    if !show {
                        threads
                        
                    } else {
                        ForEach(chains) { chain in
                            Rectangle()
                                .fill(.white)
                                .frame(height: 300)
                                .cornerRadius(30)
                                .shadow(color: Color("Shadow"),radius: 20, x:20,y:10)
                                .opacity(0.3)
                            .padding(.horizontal,30)
                        }
                    }
                }
                .padding(.horizontal,20)
                
            } onRefresh: {
                print("refresh")
            }
            .coordinateSpace(name: "scroll")
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: 70)
            })
            .overlay(
                NavigationBar(title: "Home", hasScrolled: $hasScrolled)
            )
            .overlay(
                Group {
                    if hasScrolled {
                        withAnimation(.easeInOut){
                            plusButton.transition(.scale)
                        }
                        
                    }
                }
            )
            
            if show {
                
                threadDetails
            }
            
            
            if showThread {
                        createThreadView(namespace: namespace, show: $showThread)
                            .environmentObject(model)
                    }
        } .onAppear {
            fetchUserThreads()
            
        }
        
        .statusBar(hidden: !showStatusBar)
        .onChange(of: show) { newValue in
            withAnimation(.closeCard) {
                if newValue {
                    showStatusBar = false
                } else {
                    showStatusBar = true
                }
            }
        }
    }
        
    var scrollDetection: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: ScrollPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollPreferenceKey.self, perform: { value in
            withAnimation(.easeInOut) {
                if value < 0 {
                    hasScrolled = true
                } else {
                    hasScrolled = false
                }
            }
        })
    }
    
    var featured: some View {
        TabView {
            ForEach(Array(featuredChains.enumerated()), id: \.offset) { index, chain in
                GeometryReader { proxy in
                    let minX = proxy.frame(in: .global).minX
                    
                    FeaturedItem(chain: chain)
                        .frame(maxWidth: 500)
                        .frame(maxWidth: 500)
                        .padding(.vertical, 40)
                        .rotation3DEffect(.degrees(minX / -10), axis: (x: 0, y: 1, z: 0))
                        .shadow(color: Color("Shadow").opacity(0.3), radius: 10, x: 0, y: 10)
                        .blur(radius: abs(minX / 40))
                        .overlay(
                            Image(chain.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 230)
                                .offset(x: 32, y: -80)
                                .offset(x: minX / 2)
                        )
                        .onTapGesture {
                            showChain = true
                            selectedIndex = index
                        }
                    
//                    Text("\(proxy.frame(in: .global).minX)")
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 430)
        .background(
            Image("Blob 1")
                .offset(x: 250, y: -100)
        )
        .sheet(isPresented: $showChain) {
            ChainView(namespace: namespace, chain: featuredChains[selectedIndex] , show: $showChain)
        }
    }
    var cards: some View{
        ForEach(chains) { chain in
            ChainItem(namespace: namespace, chain: chain , show: $show)
                .onTapGesture {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        show.toggle()
                        model.showDetail.toggle()
                        showStatusBar = false
                        selectedID = chain.id
                        }
                }
            }
        }
    var details: some View {
        ForEach(chains) { chain in
            if chain.id == selectedID {
                ChainView(namespace: namespace, chain: chain, show: $show)
                    .zIndex(1)
                .transition(.asymmetric(insertion: .opacity.animation(.easeInOut(duration: 0.1)), removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))))
            }
        }
        
    }
    
    var threads: some View{
        ForEach(userThreads) { thread in
            ThreadItem(namespace: namespace, thread: thread, show: $show)
                .onTapGesture {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        show.toggle()
                        model.showDetail.toggle()
                        showStatusBar = false
                        selectedThreadID = thread.id
                        }
                }
            }
        }
    var threadDetails: some View {
        ForEach(userThreads) { thread in
                if thread.id == selectedThreadID {
                    ThreadView(namespace: namespace, thread: thread, show: $show)
                    .zIndex(1)
                .transition(.asymmetric(insertion: .opacity.animation(.easeInOut(duration: 0.1)), removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))))
            }
        }
        
    }
    
    
    var plusButton: some View{
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        showThread.toggle()
                    }
                    
                } label:{
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .frame(width: 65,height: 65)
                        .background(Color("AccentColor"))
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
                .padding()
                .shadow(radius: 2)
            }
        }
    }
    
    func fetchUserThreads() {
        if let userId = sessionManager.currentUser?.userId {
            threadService.getUserThreads(userId: userId) { result in
                switch result {
                case .success(let threads):
                    userThreads = threads
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
            .environmentObject(Model())
            .environmentObject(SessionManager())
    }
}
