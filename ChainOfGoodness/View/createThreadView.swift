//
//  createThreadView.swift
//  ChainOfGoodness
//
//  Created by Raunaq Vyas on 2023-07-19.
//

//
//  ChainView.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-04-30.
//

import SwiftUI

struct createThreadView: View {
    var namespace: Namespace.ID
    var chain : Chain = chains[0]
    @Binding var show: Bool
    @State var showThread = false
    @State private var showAlert = false
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String = ""
    @State var appear = [false, false, false]
    @EnvironmentObject var model : Model
    @EnvironmentObject var threadService : ThreadService
    @State var viewState : CGSize = .zero
    @State var isDraggable = true
    @State var threadTitle: String = ""
    @State var threadDescription: String = ""
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    @State var threadContent: [ThreadContent] = []
    @FocusState var showKeyboard: Bool
    
    
    var body: some View {
        ZStack {
            ScrollView {
                cover
                
                content
                    .offset(y: 60)
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
            
            // Iterating Thread Content...
            ForEach(Array(threadContent.indices), id: \.self) { index in
                HStack {
                    TextView(text: $threadContent[index].content, height: $threadContent[index].height, fontSize: getFontSize(type: threadContent[index].type))
                        .focused($showKeyboard)
                        .frame(height: threadContent[index].height == 0 ? getFontSize(type: threadContent[index].type) * 2 : threadContent[index].height)
                        .background(
                            Text(threadContent[index].type)
                                .font(.system(size: getFontSize(type: threadContent[index].type)))
                                .foregroundColor(.gray)
                                .opacity(threadContent[index].content == "" ? 0.7 : 0)
                                .padding(.leading, 5),
                            alignment: .leading
                        )
                    
                    // Delete button
                    Button(action: {
                        withAnimation {
                            let itemToRemove = threadContent[index]
                            threadContent = threadContent.filter { $0.id != itemToRemove.id }
                        }
                    }) {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.red)
                    }

                }
            }

            
            // Menu Button to insert Thread Content...
            Menu {
                Button("Header") {
                    withAnimation {
                        threadContent.append(ThreadContent(content: "", type: "heading"))
                    }
                }

                Button("SubHeading") {
                    withAnimation {
                        threadContent.append(ThreadContent(content: "", type: "subheading"))
                    }
                }

                Button("Paragraph") {
                    withAnimation {
                        threadContent.append(ThreadContent(content: "", type: "paragraph"))
                    }
                }

            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(25)
    }

    // Dynamic height...
    func getFontSize(type: String) -> CGFloat {
        switch type {
        case "heading":
            return 24
        case "subheading":
            return 22
        case "paragraph":
            return 18
        default:
            return 18
        }
    }

    
    var button: some View {
        
        HStack {
            Button {
            // Cancel action
            showAlert.toggle()
        } label: {
            Text("Cancel")
                .font(.body.weight(.bold))
                .foregroundColor(.secondary)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Are you sure?"), message: Text("Do you want to cancel?"), primaryButton: .default(Text("Yes"), action: {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    show.toggle()
                }
            }), secondaryButton: .cancel())
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(20)
            
            
            Button {
                postThread()
            } label: {
                Text("Post")
                    .font(.body.weight(.bold))
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(20)
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("Okay")))
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(title: Text("Success"), message: Text("Thread created successfully!"), dismissButton: .default(Text("Okay")) {
                    show.toggle()
                })
            }


            
        }
        
    }
    
    var overlayContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Enter thread title...", text: $threadTitle)
                .font(.largeTitle.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
    
            TextField("Enter a thread description...",text: $threadDescription)
                .font(.footnote)
                .foregroundColor(.black)
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
    
    func postThread() {
        // Creating a ThreadCredentials object from the view's state
        let threadDetails = ThreadCredentials(title: threadTitle, description: threadDescription, content: threadContent, link: "" )
        
        // Call the createThread function
        threadService.createThread(thread: threadDetails) { result in
            switch result {
            case .success(let thread):
                print("Thread created successfully: \(thread)")
                showSuccessAlert.toggle()
            case .failure(let error):
                print("Error creating thread: \(error)")
                showErrorAlert.toggle()
                
            }
        }
    }

    }

struct createThreadView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        createThreadView(namespace: namespace, show: .constant(true))
            .environmentObject(Model())
        
    }
}
