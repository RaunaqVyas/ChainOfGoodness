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
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $show) {
                ChainView(namespace: namespace,  chain: chains[selectedIndex] , show: $show)
            }
        }
    }
    
    var content: some View {
        ForEach(Array(chains.enumerated()), id : \.offset) { index , item in
            if item.title.contains(text) || text == "" {
                if index != 0 {
                    Divider()
                }
                Button {
                    show = true
                    selectedIndex = index
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        Image(item.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 44, height: 44)
                            .background(Color("Background"))
                            .mask(Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title).bold()
                                .foregroundColor(.primary)
                            Text(item.text)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.vertical, 4)
                    .listRowSeparator(.hidden)
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
