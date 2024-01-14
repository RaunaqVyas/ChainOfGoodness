//
//  SignUpView.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-04-29.
//

import SwiftUI

struct SignUpView: View {
    enum Field: Hashable {
        case username
        case email
        case password
        
    }
    @State var email = ""
    @State var password = ""
    @State var username = ""
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    @FocusState var focusedField: Field?
    @State var circleY: CGFloat = 0
    @State var usernameY : CGFloat = 0
    @State var emailY: CGFloat = 0
    @State var passwordY: CGFloat = 0
    @State var circleColor: Color = .blue
    @State var appear = [false, false, false]
    @EnvironmentObject var model : Model
    @EnvironmentObject var sessionManager : SessionManager
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Sign up")
                .font(.largeTitle).bold()
                .opacity(appear[0] ? 1 : 0)
                .offset(y: appear[0] ? 0 : 20)
            Text("Meet those with the same affinity for kindness as you")
                .font(.headline)
                .opacity(appear[1] ? 1 : 0)
                .offset(y: appear[1] ? 0 : 20)
            VStack(alignment: .center) {
                Button(action: {
                    self.showPicker.toggle()
                }) {
                    if let croppedImage {
                        Image(uiImage: croppedImage)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .symbolVariant(.circle.fill)
                            .font(.system(size: 50))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color("blue"), Color("blue").opacity(0.3))
                            .padding()
                            .background(Circle().fill(.ultraThinMaterial))
                    } else {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .symbolVariant(.circle.fill)
                            .font(.system(size: 50))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color("blue"), Color("blue").opacity(0.3))
                            .padding()
                            .background(Circle().fill(.ultraThinMaterial))
                    }
                }
            }
                .cropImagePicker(options: [.edit], show: $showPicker, croppedImage: $croppedImage)
                
                TextField("Username", text: $username)
                    .inputStyle(icon: "person.circle")
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .username)
                    .shadow(color: focusedField == .username ? .primary.opacity(0.3) : .clear, radius: 10, x: 0, y: 3)
                    .overlay(geometry)
                    .onPreferenceChange(CirclePreferenceKey.self) { value in
                        usernameY = value
                        circleY = value
                    }
                TextField("Email", text: $email)
                    .inputStyle(icon: "mail")
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .email)
                    .shadow(color: focusedField == .email ? .primary.opacity(0.3) : .clear, radius: 10, x: 0)
                    .overlay(geometry)
                    .onPreferenceChange(CirclePreferenceKey.self) { value in
                        emailY = value
                }
                SecureField("Password", text: $password)
                .inputStyle(icon: "lock")
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .shadow(color: focusedField == .password ? .primary.opacity(0.3) : .clear, radius: 10, x: 0, y: 3)
                .overlay(geometry)
                .onPreferenceChange(CirclePreferenceKey.self) { value in
                passwordY =  value
            }
            Button {
                Task {
                    do {
                        await sessionManager.signUp(username: email,password: password, email: email, pictureUrl: "person.circle", preferredUsername: username)
                    }
                    sessionManager.selectedModal = .confirmation
                }
            } label: {
                Text("Create an account")
                    .frame(maxWidth: .infinity)
            }

            .font(.headline)
            .blendMode(.overlay)
            .buttonStyle(.angular)
            .tint(.accentColor)
            .controlSize(.large)
            .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
            
            Group {
                Text("By clicking on ")
                + Text("_Create an account_").foregroundColor(.primary.opacity(0.7))
                + Text(", you agree to our **Terms of Service** and **[Privacy Policy](https://designcode.io)**")
                
                Divider()
                
                HStack {
                    Text("Already have an account?")
                    Button {
                        sessionManager.selectedModal = .signIn
                    } label: {
                        Text("**Sign in**")
                    }
                }
            }
            .font(.footnote)
            .foregroundColor(.secondary)
            .accentColor(.secondary)
        }
        .opacity(appear[2] ? 1 : 0)
        .offset(y: appear[2] ? 0 : 20)
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .background(
            Circle().fill(.blue)
                .frame(width: 68, height: 68)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(y: circleY)
        )
        .coordinateSpace(name: "container")
        .strokeStyle(cornerRadius: 30)
        .onChange(of: focusedField) { value in
            withAnimation {
                if value == .username {
                    circleY = usernameY
                } else if value == .email {
                    circleY = emailY
                }  else if value == .password {
                    circleY = passwordY
                }
            }
        }
        .onAppear {
            withAnimation(.spring().delay(0.1)) {
                appear[0] = true
            }
            withAnimation(.spring().delay(0.2)) {
                appear[1] = true
            }
            withAnimation(.spring().delay(0.3)) {
                appear[2] = true
            }
        }
   
    }

var geometry: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: CirclePreferenceKey.self, value: proxy.frame(in: .named("container")).minY)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SignUpView()
                .preferredColorScheme(.light)
                .environmentObject(Model())
        }
    }
}

