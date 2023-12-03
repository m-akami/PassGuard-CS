/* Dependencies
These are required for PassGuard to function correctly and are not programmed by me. They are external tools used to make development easier. */

import SwiftUI
import Foundation

struct LoginWindow: View {
    
    /* Variables
     These are values which change in this specfic view before any major changes are pushed to the backend. The @State makes the variable non-static in SwiftUI*/
    
    @State public var loginMasterPassword = ""
    let inputBoxColor = Color(red: 72 / 255, green: 74 / 255, blue: 78 / 255)
    @State private var attempts = 3
    @State private var incorrectPassword = false
    @State private var forgotPassword = false
    @State private var showingAlert = false
    @State private var locked = PassGuardLocked()
    @State private var alertType: AlertType?
    let username = GetUsername()
    
    /* Window View
     This is the structure of the window that appears when the LoginWindow view is called*/
    
    var body: some View {
        VStack {
            
            /* Encryption Check
            If the application backend is encrypted, the user will be presented with the login window. If not, the user can continue to the Main Window.*/
            
            if locked {
                
                /* Information
                 This part of the UI contains elements that describe to the user what the window's purpose is*/
                
                Image(systemName: "person.2.badge.key.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.teal)
                    .padding(.vertical, 3)
                
                Text("Enter Master Password")
                    .font(.system(size:20))
                    .bold()
                
                HStack {
                    Text(username + "  •")
                        .font(.system(size:15))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 17.5)
                        .padding(.leading, 20)
                        .padding(.trailing, 0)
                        .padding(.top, 8.5)
                    
                    Text("Forgot Password")
                        .onTapGesture {
                            self.alertType = .forgotPassword
                            self.showingAlert = true
                        }
                        .font(.system(size:15))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 17.5)
                        .padding(.leading, 0)
                        .padding(.trailing, 20)
                        .padding(.top, 8.5)
                        
                }
                
                /* Inputs
                 This part of the UI contains elements that allow the user to input information*/
                
                SecureField("Master Password", text: $loginMasterPassword)
                    .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 47, idealHeight: 47, maxHeight: 47, alignment: .center)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 14)
                    .disableAutocorrection(true)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(inputBoxColor)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(attempts == 0 ? Color.red : Color.teal, lineWidth: 3.5)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 5)
                    .padding(.top, 8.5)
                
                if attempts == 0 {
                    Text("Your PassGuard account has been temporarily disabled.")
                        .font(.system(size: 13))
                        .padding(.top, 0)
                        .padding(.bottom, 1)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.red)
                }
                
                Button("Unlock PassGuard") {
                    if ValidateCredentials(Password: loginMasterPassword) {
                        if UnlockPassGuard(Password: loginMasterPassword) == 1 {
                            locked = false
                            pushBufferMasterPassword(input: loginMasterPassword)
                        }
                        else {
                            locked = true
                            self.alertType = .unlockError
                            self.showingAlert = true
                        }
                        
                    }
                    else {
                        attempts = attempts - 1
                        self.alertType = .incorrectPassword
                        self.showingAlert = true
                    }
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 115)
                .padding(.vertical, 10)
                .background(attempts == 0 ? Color.gray : Color.teal)
                .foregroundColor(.black)
                .bold()
                .cornerRadius(30)
                .frame(width: 50000)
                .disabled(attempts == 0)
            }
            
            else {
                
                // This section presents the MainWindow to the user
                MainWindow()
            }
            
        }

        // Inputs - Error Popups
        
        .alert(isPresented: $showingAlert) {
            switch alertType {
                
            case .incorrectPassword:
                return Alert(
                    title: Text("Incorrect Password"),
                    message: Text("The password you have entered is incorrect. You have " + String(attempts) + " remaining until PassGuard is temporarily disabled."),
                    dismissButton: .default(Text("OK")) {
                        showingAlert = false
                    }
                )
                
            case .unlockError:
                return Alert(
                    title: Text("Error"),
                    message: Text("An error occurred unlocking your PassGuard Account. Please check all the relevant permissions are granted to this app, and if the issue persists restart your Mac."),
                    dismissButton: .default(Text("OK")) {
                        showingAlert = false
                    }
                )
                
            case .forgotPassword:
                return Alert(
                    title: Text("Forgotten Password"),
                    message: Text("As all data in PassGuard is encrypted, your master password cannot be reset, and your data cannot be recovered. To use PassGuard again, your account must be deleted."),
                    primaryButton: .destructive(Text("Delete Account")) {
                        let _ = DeleteAccount()
                    },
                    secondaryButton: .cancel() {
                            showingAlert = false
                    }
                )
                
            case .none:
                return Alert(title: Text("No Error"))
            }
        }
        
        .padding()
    }
    
    /* Local Algorithms
     This part of the application contains algorithms that control the functions of just this window*/
    
    // Local Algorithms - Alert Logic
    
    enum AlertType {
        case forgotPassword
        case incorrectPassword
        case unlockError
    }
    
}

/* Launch View
This is the entry point for PassGuard. If there has not been a registration form completed, this will be the first window to open.*/

struct LoginWindowApp: App {
    var body: some Scene {
        WindowGroup {
            LoginWindow()
                .frame(minWidth: 450, minHeight: 600, maxHeight: .infinity)
                .background(Color(red: 23/255, green: 23/255, blue: 23/255))
        }
    }
}
