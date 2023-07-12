////
////  ConfirmationView.swift
////  ChainOfGoodness
////
////  Created by Raunaq Vyas on 2023-05-24.
////
//
//import SwiftUI
//
//struct ConfirmationView: View {
//    @State private var confirmationCode = ""
//    @EnvironmentObject var model: Model
//    let username: String
//
//    var body: some View {
//        VStack {
//            Text("Username: \(username)")
//            TextField("Confirmation Code", text: $confirmationCode)
//                .padding()
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//
//            Button("Confirm", action: {
//                // Add your confirmation code logic here
//            })
//            .padding()
//        }
//        .padding()
//    }
//}
//
//struct ConfirmationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmationView(username: "kilo loco")
//    }
//}
