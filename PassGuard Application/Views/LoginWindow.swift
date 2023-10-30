/* Dependencies
These are required for PassGuard to function correctly and are not programmed by me. They are external tools used to make development easier. */

import SwiftUI

struct LoginWindow: View {
    
    /* Variables
     These are values which change in this specfic view before any major changes are pushed to the backend. The @State makes the variable non-static in SwiftUI*/
    
    @State private var masterPassword = ""
    let inputBoxColor = Color(red: 72 / 255, green: 74 / 255, blue: 78 / 255)
    
    /* Window View
    This is the structure of the window that appears when the LoginWindow view is called*/
    
    var body: some View {
        VStack {
            
            /* Information
             This part of the UI contains elements that describe to the user what the window's purpose is*/
            
            Image(systemName: "person.2.badge.key.fill")
                .font(.system(size: 100))
                .foregroundColor(.teal)
                .padding(.vertical, 3)
            
            Text("Enter Master Password")
                .font(.system(size:20))
                .bold()
            
            Text("John Doe • PassGuard")
                .font(.system(size:15))
                .multilineTextAlignment(.center)
                .padding(.bottom, 17.5)
                .padding(.horizontal, 20)
                .padding(.top, 8.5)
            
            /* Inputs
             This part of the UI contains elements that allow the user to input information*/
            
            SecureField("Master Password", text: $masterPassword)
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
                .padding(.bottom, 5)
                .padding(.top, 8.5)
            
            Button("Unlock PassGuard") {
                
            }
                .buttonStyle(.plain)
                .padding(.horizontal, 131)
                .padding(.vertical, 10)
                .background(Color.teal)
                .foregroundColor(.black)
                .bold()
                .cornerRadius(30)
                .frame(width: 50000)
        }
        .padding()
    }
}

/* Launch View
This is where a window is created when the LoginWindow() is called.*/

struct LoginWindowApp: App {
    var body: some Scene {
        WindowGroup {
            LoginWindow()
                .frame(minWidth: 450, minHeight: 600, maxHeight: .infinity)
                .background(Color(red: 23/255, green: 23/255, blue: 23/255))
        }
    }
}
