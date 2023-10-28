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
        // Returns a dark green.
        return Color(red: 0.0, green: 0.5, blue: 0.0)
    default:
        return Color.gray
    }
}

/* PassGuard Cryptography
Multiple modules that are responsible for the protection of data have been created here, as a proof-of-concept, rather than using CryptoKit.*/

/* PassGuard Hashing - PassHash
A proof-of-concept hashing algorithm designed to obfuscate data during operations, one way.*/

func PassHash(_ input: String) -> UInt32 {
    
    // The hash function is intialised with a prime number, before any extra data is added.
    var hash: UInt32 = 5381

    // It converts the input to UTF, so the characters can be read as numbers.
    for char in input.utf8 {
        
        // Multiple prime numbers are initialised to use as hashes, as they are only divisable by one and themselves, which makes reverse-engineering more difficult.
        let prime1: UInt32 = 15485863
        let prime2: UInt32 = 982451653
        let prime3: UInt32 = 314159
        let prime4: UInt32 = 2718281829
        let prime5: UInt32 = 7154629

        // Multiple shift operations are used, using the AND operator so they don't overflow 32 bits.
        let shift1 = 2 * (hash & 0x0F)
        let shift2 = 3 * (hash & 0x1F)
        let shift3 = 5 * (hash & 0x3F)
        let shift4 = 7 * (hash & 0x7F)
        let shift5 = 11 * (hash & 0xFF)

        // This part of the logic has multiple different operations based on what the hash is, which means different hash values will undergo different shifting. This makes the ONE-WAY logic of the hashing more secure.
        
        // This part left-shifts the bits by shift one, and then right-shifts the bits by shift two, then an AND operator is used with overflow protection.
        hash = (hash << shift1) &+ (hash >> shift2)
        // This part XORs it with the 1st prime number, then multiplies by the second.
        hash = (hash ^ prime1) &* prime2
        // Then this part XORs it with the third prime number and subtracts the fourth.
        hash = (hash ^ prime3) &- prime4
        // The fifth prime number is added then the input is combined with the current character value in 32 bits.
        hash = (hash + prime5) &+ UInt32(char)
        // Then left-shifts are executed by shift3, shift4, and shift5 and then they are combined with the hash.
        hash = (hash << shift3) &+ (hash << shift4) &- (hash << shift5)
    }

    // The hash gets outputted.
    return hash
}

/* PassGuard Encrypt - PassCrypt
A proof-of-concept encryption algorithm designed to obfuscate data stored in the master table.*/
