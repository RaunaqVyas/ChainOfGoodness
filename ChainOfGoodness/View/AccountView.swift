//
//  AccountView.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-03-19.
//

import SwiftUI

struct AccountView: View {
    @State var isDeleted = false
    @State var isPinned = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionManager : SessionManager
    var threadService = ThreadService()
    
    
    var body: some View {
        NavigationView {
            List {
                profile
                menu
                links
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Account")
            .navigationBarItems(trailing: Button { presentationMode.wrappedValue.dismiss() } label: { Text("Done").bold() })
            .background(Color("Background"))
        }
    }
    
    var profile: some View {
        VStack(spacing: 8) {
            Image(systemName: "location")
                .symbolVariant(.circle.fill)
                .font(.system(size: 32))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color("blue"), Color("blue").opacity(0.3))
                .padding()
                .background(Circle().fill(.ultraThinMaterial))
                .background(
                    HexagonView()
                        .offset(x: -50, y: -100)
                )
                .background(){
                    BlobView()
                        .offset(x:250,y:50)
                        .scaleEffect(0.5)
                }
            Text("Raunaq Vyas")
                .font(.title.weight(.semibold))
            HStack {
                Image(systemName: "location")
                    .imageScale(.large)
                Text("Canada")
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    var menu: some View{
        Section {
            NavigationLink {
                Button {
                    Task {
                        do {
                            await sessionManager.signOutLocally()
                        }
                    }

                }
                label: {
                    HStack{
                        Text("Log Out")
                        Image(systemName: "arrowshape.backward.fill")
                    }
                }
            } label: {
                Label("Settings", systemImage: "gear")
            }
            NavigationLink {
                Button {
                    Task {
                        do {
                           print("")
                        }
                    }

                }
                label: {
                    HStack{
                        Text("Get threads")
                        Image(systemName: "arrowshape.backward.fill")
                    }
                }
            } label: {
                Label("About us", systemImage: "person.3.sequence.fill")
            }
            NavigationLink {
                Text("Help")
            } label: {
                Label("Help", systemImage: "questionmark")
            }
        }
        .listRowSeparatorTint(.blue)
        .listRowSeparator(.hidden)
        .tint(.primary)
    }
    
    var links: some View{
        Section {
            Link(destination: URL(string: "https://apple.com")!) {
                HStack {
                    Label("Website", systemImage: "house")
                        .tint(.primary)
                    Spacer()
                    Image(systemName: "link")
                        .foregroundColor(.secondary)
                }
            }

            Link(destination: URL(string: "https://apple.com")!) {
                HStack {
                    Label("Instagram", systemImage: "camera")
                        .tint(.primary)
                    Spacer()
                    Image(systemName: "link")
                        .foregroundColor(.secondary)
                }
            }
        }
        .tint(.secondary)
        .listRowSeparator(.hidden)
    }
    
    
    var deleteButton: some View{
        Button(action: {isDeleted = true}){
            Label("Delete",systemImage: "trash")
        }
        .tint(.red)
    }
    
    var pinButton: some View{
        Button {isPinned.toggle()} label: {
            if isPinned{
                Label("Unpin",systemImage: "pin.slash")
            } else {
                Label("Pin",systemImage: "pin")
            }
        }
        .tint(isPinned ? .gray : .yellow)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
