/* Dependencies
These are required for PassGuard to function correctly and are not programmed by me. They are external tools used to make development easier. */

import SwiftUI

/* Password Complexity
When a user enters a password into PassGuard’s database, this algorithm should run to check for complexity and tag potentially weaker credentials that should be replaced.*/

func PasswordComplexity(_ password: String) -> Int {
    var complexityScore = 0
    
    // Checks the length of the password, with a minimum of 8, and extra points for a password greater than 13 characters long.
    if password.count >= 14 {
        complexityScore += 2
    } else if password.count >= 8 {
        complexityScore += 1
    }
    
    // Checks if the password has upper and lowercase characters using regexp.
    if password.range(of: #"(?=.*[A-Z])(?=.*[a-z])"#, options: .regularExpression) != nil {
        complexityScore += 1
    }
    
    // Checks if the password has numbers using regexp.
    if password.range(of: #".*[0-9].*"#, options: .regularExpression) != nil {
        complexityScore += 1
    }
    
    // Checks if the password has special characters using regexp.
    if password.range(of: #".*[^A-Za-z0-9].*"#, options: .regularExpression) != nil {
        complexityScore += 1
    }
    
    // Returnes a score out of five.
    return complexityScore
}

/* Password Complexity Colour
A sub-algorithm of the PasswordComplextiy() feature, which assigns colours instead of a numeric score.*/

func PasswordComplexityColour(_ masterPassword: String) -> Color {
    let score = PasswordComplexity(masterPassword)
    
    // For each case, a colour is assigned from scores 1 to 5, one being the weakest and logically associated with red.
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
