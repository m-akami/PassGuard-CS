/* Dependencies
These are required for PassGuard to function correctly and are not programmed by me. They are external tools used to make development easier. */

import SwiftUI
import SwiftData

struct OnboardingWindow: View {
    
    /* Variables
     These are values which change in this specfic view before any major changes are pushed to the backend. The @State makes the variable non-static in SwiftUI*/

    @State private var fullName = ""
    @State private var masterPassword = ""
    @State private var confirmMasterPassword = ""
    @State private var registrationSuccessful = false
    @State var strengthColour = Color.gray
    let inputBoxColor = Color(red: 72 / 255, green: 74 / 255, blue: 78 / 255)
    
    /* Window View
    This is the structure of the window that appears when the OnboardingWindow view is called*/
    
    var body: some View {
        VStack {
            
            /* Information
             This part of the UI contains elements that describe to the user what the window's purpose is*/
            
            Text("Welcome to PassGuard")
                .font(.system(size:20))
                .bold()
                .padding(.vertical, 1)
            
            Text("Before you get started, there are a few things you need to fill out first. Ensure all information entered is correct, as it cannot be changed later")
                .font(.system(size:15))
                .multilineTextAlignment(.center)
                .padding(.bottom, 17.5)
                .padding(.horizontal, 20)
            
            /* Inputs
             This part of the UI contains elements that allow the user to input personal information*/
            
            // Inputs - Name
            
            Text("Name")
                .font(.system(size: 16))
                .bold()
                .padding(.top, 1)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Enter your full name", text: $fullName)
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
                        .stroke(Color.teal, lineWidth: 3.5)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 15)
            
            // Inputs - Master Password
            
            Text("Master Password")
                .font(.system(size: 16))
                .bold()
                .padding(.top, 1)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SecureField("Create a strong Master Password", text: $masterPassword)
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
                        .stroke(Color.teal, lineWidth: 3.5)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 0)
                .onChange(of: masterPassword) { masterPassword in
                    strengthColour = updateStrength(masterPassword)
                }
            
            // Inputs - Strength Meter
            
            HStack {
                Text("Strength")
                    .foregroundColor(.white)
                    .padding(.vertical, 2)
                    .padding(.leading, 20)
                    .padding(.trailing, 6.5)
                
                Rectangle()
                    .frame(height: 12)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(strengthColour)
                    .cornerRadius(7.5)
                    .padding(.vertical, 2)
                    .padding(.trailing, 20)
            }
            
            // Inputs - Master Password Confirmation
            
            SecureField("Confirm Master Password", text: $confirmMasterPassword)
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
                    .stroke(passwordsMatch() ? Color.teal : Color.red, lineWidth: 3.5)
                )
                .padding(.horizontal, 20)
                .padding(.top, 1)
                .padding(.bottom, 5)
            
            // Inputs - Error Message
            
            if !passwordsMatch() {
                Text("Passwords don't match. Try again.")
                    .font(.system(size: 13))
                    .padding(.top, 0)
                    .padding(.bottom, 1)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.red)
            }
            
            // Inputs - Disclaimer Text
            
            Text("\nYour Master Password protects all objects stored in your manager. If you forget this, your data cannot be recovered.")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            
            // Inputs - Confirm Registration Button
            
            Button("Create Account") {
                
            }
                .buttonStyle(.plain)
                .padding(.horizontal, 85)
                .padding(.vertical, 8)
                .background(Color.teal)
                .foregroundColor(.black)
                .bold()
                .cornerRadius(30)
                .frame(width: 50000)
        }
        .padding()
    }
    
    /* Local Algorithms
     This part of the application contains algorithms that control the functions of just this window*/
    
    // Local Algorithms - Strength Meter Logic
    
    func updateStrength(_ masterPassword: String) -> Color {
        let score = PasswordComplexity(masterPassword)
        
        switch score {
        case 1:
            return Color.red
        case 2:
            return Color.orange
        case 3:
            return Color.yellow
        case 4:
            return Color.green
        case 5:
            return Color.blue
        default:
            return Color.gray
        }
    }
    
    // Local Algorithms - Passwords Matching Logic
    
    func passwordsMatch() -> Bool {
        return masterPassword == confirmMasterPassword
    }
}

/* Launch View
This is the entry point for PassGuard. If there has not been a registration form completed, this will be the first window to open.*/

@main
struct OnboardingWidnowApp: App {
    var body: some Scene {
        WindowGroup {
            OnboardingWindow()
                .frame(minWidth: 450, minHeight: 600)
                .background(Color(red: 23/255, green: 23/255, blue: 23/255))
        }
    }
}