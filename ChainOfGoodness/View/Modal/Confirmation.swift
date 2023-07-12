//
//  Confirmation.swift
//  ChainOfGoodness
//
//  Created by Raunaq Vyas on 2023-05-24.
//

import SwiftUI

struct ConfirmationView: View {
    enum Field: Hashable {
        case confirmationCode
    }

    @State private var confirmationCode = ""
    @EnvironmentObject var model: Model
    @EnvironmentObject var sessionManager : SessionManager
    let username: String
    @FocusState var focusedField: Field?
    @State var circleY: CGFloat = 0
    @State var confirmationCodeY: CGFloat = 0
    @State var circleColor: Color = .blue
    @State var appear = [false]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Confirmation for \(username)")
                .font(.largeTitle).bold()
                .opacity(appear[0] ? 1 : 0)
                .offset(y: appear[0] ? 0 : 20)
            
            Group {
                TextField("Confirmation Code", text: $confirmationCode)
                    .inputStyle(icon: "key")
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                    .autocapitalization(.none)
                    .focused($focusedField, equals: .confirmationCode)
                    .shadow(color: focusedField == .confirmationCode ? .primary.opacity(0.3) : .clear, radius: 10, x: 0, y: 3)
                    .overlay(geometry)
                    .onPreferenceChange(CirclePreferenceKey.self) { value in
                        confirmationCodeY = value
                        circleY = value
                    }
                
                Button {
                    Task {
                        do {
                            await sessionManager.confirmSignUp(for: username, with: confirmationCode)
                        }
                        sessionManager.selectedModal = .signIn
                    }
                } label: {
                    Text("Confirm")
                        .frame(maxWidth: .infinity)
                }
                .font(.headline)
                .blendMode(.overlay)
                .buttonStyle(.angular)
                .tint(.accentColor)
                .controlSize(.large)
                .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
                
                Divider()
                HStack {
                    Text("Didn't work? Go Back To")
                    Button {
                        sessionManager.selectedModal = .signUp
                    } label: {
                        Text("**Sign up**")
                    }
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .accentColor(.secondary)
            }
            
            .opacity(appear[0] ? 1 : 0)
            .offset(y: appear[0] ? 0 : 20)
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .background(
            Circle().fill(circleColor)
                .frame(width: 68, height: 68)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(y: circleY)
        )
        .coordinateSpace(name: "container")
        .strokeStyle(cornerRadius: 30)
        .onChange(of: focusedField) { value in
            withAnimation {
                if value == .confirmationCode {
                    circleY = confirmationCodeY
                    circleColor = .blue
                }
            }
        }
        .onAppear {
            withAnimation(.spring().delay(0.1)) {
                appear[0] = true
            }
        }
    }

    var geometry: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: CirclePreferenceKey.self, value: proxy.frame(in: .named("container")).minY)
        }
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "kilo loco")
    }
}
