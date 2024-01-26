//
//  SearchView.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-05-22.
//

import SwiftUI

struct SearchView: View {
    @State var text = ""
    @State var show = false
    @Namespace var namespace
    @State var selectedIndex = 0
    @State var showDone = true
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedThread: Thread?
    @State private var showThreadView = false
    @StateObject var viewModel = ThreadViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    content
                }
                .padding(20)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                .strokeStyle(cornerRadius: 30)
                .padding(20)
                .background(
                    Rectangle()
                        .fill(.regularMaterial)
                        .frame(height: 200)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .blur(radius: 40)
                        .offset(y: -200)
                )
                .background(
                    Image("Blob 1").offset(x: -100, y: -200)
                )
            }
            .searchable(text: $text, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search Users and chains")) {
                ForEach(suggestions) { suggestion in
                    Button {
                        text = suggestion.text
                    } label: {
                        Text(suggestion.text)
                            .searchCompletion(suggestion.text)
                    }
                }
            }
            .task {
                viewModel.fetchAllThreads()
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showThreadView) {
                if let selectedThread = selectedThread {
                    ThreadView(namespace: namespace, thread: selectedThread, show: $showThreadView)
                }
            }
        }
    }
    
    var content: some View {
           ForEach(viewModel.allUserThreads) { thread in
               if thread.title.contains(text) || text.isEmpty {
                   ThreadListItem(thread: thread) {
                       self.selectedThread = thread
                       self.showThreadView = true
                   }
               }
           }
       }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
