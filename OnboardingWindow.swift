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
                
        }
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
