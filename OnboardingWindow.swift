/* Dependencies
These are required for PassGuard to function correctly and are not programmed by me. They are external tools used to make development easier. */

import SwiftUI
import SwiftData

/* Window View
This is the structure of the window that appears when the OnboardingWindow view is called*/

struct OnboardingWindow: View {
    
    /* Variables
    These are values which change in this specfic view before any major changes are pushed to the backend. The @State makes the variable non-static in SwiftUI*/
    
    @State private var fullName = ""
    @State private var masterPassword = ""
    @State private var confirmMasterPassword = ""
    @State private var registrationSuccessful = false
    @State var strengthColour = Color.gray
    let inputBoxColor = Color(red: 72 / 255, green: 74 / 255, blue: 78 / 255)
    
    /* Information
    This part of the UI contains elements that describe to the user what the window's purpose is*/
    
    
}
