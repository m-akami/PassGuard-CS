/* Dependencies
These are required for PassGuard to function correctly and are not programmed by me. They are external tools used to make development easier. */

import SwiftUI
import SQLite
import Foundation

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

        // This part of the logic has multiple different operations based on what the hash is, which means different hash values will undergo different shifting. This makes the ONE-WAY logic of the hashing more secure. I've split the possible 2^32 range of the hash values in 32 bits into 10 groups. Depending which group the data falls into, a different combination of mathematics will be applied. I have then randomly arranged the different mathematical hashes from each of the ten combinations (with no logic whatsoever) to create a somewhat secure hash function. Each of the ten blocks have four mathmatical functions to hash the data.
        
        if hash >= 0x0 && hash <= 0x19999999 {
            // This part left-shifts the bits by shift1, XORs and then right-shifts the bits by shift2
            hash = (hash << shift1) ^ (hash >> shift2)
            
            // This part left shifts the hash by shift1, then XORs it with the NOT result of the right shift by shift2
            hash = (hash << shift1) ^ ~(hash >> shift2)
            
            // This part left-shifts by shift1, then adds it to the left-shift by shift2, then ANDs the result with the left shift of shift3
            hash = (hash << shift1) &+ (hash << shift2) & (hash << shift3)
            
            // This part left shifts the hash by shift1, XORs the result by the right shift of shift2, then multiplies it by the left shift of the hash by shift3
            hash = (hash << shift1) ^ (hash >> shift2) &* (hash << shift3)
        }
        else if hash >= 0x19999999 && hash <= 0x33333332 {
            // This part left-shifts the bits by shift1, adds then right-shifts by shift2, then subtracts the left shift of the hash by shift three
            hash = (hash << shift1) &+ (hash >> shift2) - (hash << shift3)
            
            // This part left-shifts the hash by shift1, then multiplies it with the right shift by shift2. Because of the mathematical order of execution, the left-shift by shift3 is finally added
            hash = (hash << shift1) &* (hash >> shift2) &+ (hash << shift3)
            
            // This part left-shifts by shift1, then adds it to the left-shift by shift2, then ANDs the result with the left shift of shift3
            hash = (hash << shift1) &+ (hash << shift2) & (hash << shift3)
            
            // This part left shifts the hash by shift1, XORs the result by the right shift of shift2, then multiplies it by the left shift of the hash by shift3
            hash = (hash << shift1) ^ (hash >> shift2) &* (hash << shift3)
        }
        else if hash >= 0x33333332 && hash <= 0x4CCCCCCB {
            // This part left-shifts the bits by shift1, then uses an AND gate with the right shift of the hash, then combines it with an OR of the left-shift of shift3, then XORs it with the right-shift of the hash by shift4
            hash = (hash << shift1) & (hash >> shift2) | (hash << shift3) ^ (hash >> shift4)
            
            // This part left shifts the hash by shift1, XORs the result by the right shift of shift2, then multiplies it by the left shift of the hash by shift3
            hash = (hash << shift1) ^ (hash >> shift2) &* (hash << shift3)
            
            // This part left shifts the hash by shift1, XORs the result by the right shift of shift2, then multiplies it by the left shift of the hash by shift3
            hash = (hash << shift1) ^ (hash >> shift2) &* (hash << shift3)
            
            // This part left shifts the hash by shift1, then XORs it with the NOT result of the right shift by shift2
            hash = (hash << shift1) ^ ~(hash >> shift2)
        }
        else if hash >= 0x4CCCCCCB && hash <= 0x66666664 {
            // This part left shifts the hash by shift1, then XORs it with the NOT result of the right shift by shift2
            hash = (hash << shift1) ^ ~(hash >> shift2)
            
            // This part left-shifts the hash by shift1, then multiplies it with the right shift by shift2. Because of the mathematical order of execution, the left-shift by shift3 is finally added
            hash = (hash << shift1) &* (hash >> shift2) &+ (hash << shift3)
            
            // This part left-shifts the bits by shift1, then uses an AND gate with the right shift of the hash, then combines it with an OR of the left-shift of shift3, then XORs it with the right-shift of the hash by shift4
            hash = (hash << shift1) & (hash >> shift2) | (hash << shift3) ^ (hash >> shift4)
            
            // This part left shifts the hash by shift1, XORs the result by the right shift of shift2, then multiplies it by the left shift of the hash by shift3
            hash = (hash << shift1) ^ (hash >> shift2) &* (hash << shift3)
        }
        else if hash >= 0x66666664 && hash <= 0x7FFFFFFD {
            // This part left-shifts the hash by shift1, then multiplies it with the right shift by shift2. Because of the mathematical order of execution, the left-shift by shift3 is finally added
            hash = (hash << shift1) &* (hash >> shift2) &+ (hash << shift3)
            
            // This part left-shifts the hash by shift1, then multiplies it with the right shift by shift2. Because of the mathematical order of execution, the left-shift by shift3 is finally added
            hash = (hash << shift1) &* (hash >> shift2) &+ (hash << shift3)
            
            // This part left-shifts by shift1, then adds it to the left-shift by shift2, then ANDs the result with the left shift of shift3
            hash = (hash << shift1) &+ (hash << shift2) & (hash << shift3)
            
            // This part left-shifts by shift1, then adds it to the left-shift by shift2, then ANDs the result with the left shift of shift3
            hash = (hash << shift1) &+ (hash << shift2) & (hash << shift3)
        }
        else if hash >= 0x7FFFFFFD && hash <= 0x99999996 {
            // This part left-shifts by shift1, then uses an OR gate with the right shift with shift2, then uses an XOR with the left shift of shift3
            hash = (hash << shift1) | (hash >> shift2) ^ (hash << shift3)
            
            // This part left-shifts by shift1, ORs the result by the right-shift of the hash by shift2, then adds the result with the left shift by shift3
            hash = (hash << shift1) | (hash >> shift2) &+ (hash << shift3)
            
            // This part left-shifts by shift1, then adds it to the left-shift by shift2, then ANDs the result with the left shift of shift3
            hash = (hash << shift1) &+ (hash << shift2) & (hash << shift3)
            
            // This part left-shifts the hash by shift1, ANDs the result by the left shift by shift2, then adds it with the rightshift by shift3
            hash = (hash << shift1) & (hash << shift2) &+ (hash >> shift3)
        }
        else if hash >= 0x99999996 && hash <= 0xB333332F {
            // This part left-shifts by shift1, then adds it to the left-shift by shift2, then ANDs the result with the left shift of shift3
            hash = (hash << shift1) &+ (hash << shift2) & (hash << shift3)
            
            // This part left-shifts by shift1, ORs the result by the right-shift of the hash by shift2, then adds the result with the left shift by shift3
            hash = (hash << shift1) | (hash >> shift2) &+ (hash << shift3)
            
            // This part left-shifts by shift1, then uses an OR gate with the right shift with shift2, then uses an XOR with the left shift of shift3
            hash = (hash << shift1) | (hash >> shift2) ^ (hash << shift3)
            
            // This part left shifts the hash by shift1, XORs the result by the right shift of shift2, then multiplies it by the left shift of the hash by shift3
            hash = (hash << shift1) ^ (hash >> shift2) &* (hash << shift3)
        }
        else if hash >= 0xB333332F && hash <= 0xCCCCCCC8 {
            // This part left-shifts by shift1, ORs the result by the right-shift of the hash by shift2, then adds the result with the left shift by shift3
            hash = (hash << shift1) | (hash >> shift2) &+ (hash << shift3)
            
            // This part left-shifts the bits by shift1, then uses an AND gate with the right shift of the hash, then combines it with an OR of the left-shift of shift3, then XORs it with the right-shift of the hash by shift4
            hash = (hash << shift1) & (hash >> shift2) | (hash << shift3) ^ (hash >> shift4)
            
            // This part left shifts the hash by shift1, XORs the result by the right shift of shift2, then multiplies it by the left shift of the hash by shift3
            hash = (hash << shift1) ^ (hash >> shift2) &* (hash << shift3)
            
            // This part left shifts the hash by shift1, XORs the result by the right shift of shift2, then multiplies it by the left shift of the hash by shift3
            hash = (hash << shift1) ^ (hash >> shift2) &* (hash << shift3)
        }
        else if hash >= 0xCCCCCCC8 && hash <= 0x6666661 {
            // This part left shifts the hash by shift1, XORs the result by the right shift of shift2, then multiplies it by the left shift of the hash by shift3
            hash = (hash << shift1) ^ (hash >> shift2) &* (hash << shift3)
            
            // This part left-shifts the hash by shift1, ANDs the result by the left shift by shift2, then adds it with the rightshift by shift3
            hash = (hash << shift1) & (hash << shift2) &+ (hash >> shift3)
            
            // This part left-shifts the hash by shift1, then multiplies it with the right shift by shift2. Because of the mathematical order of execution, the left-shift by shift3 is finally added
            hash = (hash << shift1) &* (hash >> shift2) &+ (hash << shift3)
            
            // This part left-shifts the bits by shift1, then uses an AND gate with the right shift of the hash, then combines it with an OR of the left-shift of shift3, then XORs it with the right-shift of the hash by shift4
            hash = (hash << shift1) & (hash >> shift2) | (hash << shift3) ^ (hash >> shift4)
        }
        else if hash >= 0x6666661 && hash <= 0xFFFFFFFF {
            // This part left-shifts the hash by shift1, ANDs the result by the left shift by shift2, then adds it with the rightshift by shift3
            hash = (hash << shift1) & (hash << shift2) &+ (hash >> shift3)
            
            // This part left-shifts by shift1, ORs the result by the right-shift of the hash by shift2, then adds the result with the left shift by shift3
            hash = (hash << shift1) | (hash >> shift2) &+ (hash << shift3)
            
            // This part left-shifts the bits by shift1, then uses an AND gate with the right shift of the hash, then combines it with an OR of the left-shift of shift3, then XORs it with the right-shift of the hash by shift4
            hash = (hash << shift1) & (hash >> shift2) | (hash << shift3) ^ (hash >> shift4)
            
            // This part left-shifts by shift1, ORs the result by the right-shift of the hash by shift2, then adds the result with the left shift by shift3
            hash = (hash << shift1) | (hash >> shift2) &+ (hash << shift3)
        }
        
        // This part applies to all hash values, further complicating the process.
        
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
    
    // This part makes sure that the hash value doesn't equal zero, and if it does, the original data is retrieved and a subset of functions
    if hash == 0 {
        
        // It converts the input to UTF, so the characters can be read as numbers.
        for char in input.utf8 {
            
            // safeHash is declared, which starts with a prime addition to prevent a null return
            var safeHash: UInt32 = 0
            
            // Multiple prime numbers are initialised to use as hashes, as they are only divisable by one and themselves, which makes reverse-engineering more difficult.
            let prime1: UInt32 = 15485863
            let prime2: UInt32 = 982451653
            let prime3: UInt32 = 314159
            let prime4: UInt32 = 2718281829

            // Multiple shift operations are used, using the AND operator so they don't overflow 32 bits.
            let shift1 = 2 * (hash & 0x0F)
            let shift2 = 3 * (hash & 0x1F)
            let shift3 = 5 * (hash & 0x3F)
            let shift4 = 7 * (hash & 0x7F)
            let shift5 = 11 * (hash & 0xFF)
            
            // The fifth prime number (7154629) is added then the input is combined with the current character value in 32 bits.
            safeHash = (safeHash + 7154629) &+ UInt32(char)
            
            // This part left-shifts the bits by shift one, and then right-shifts the bits by shift two, then an AND operator is used with overflow protection.
            safeHash = (safeHash << shift1) &+ (safeHash >> shift2)
            
            // This part XORs it with the 1st prime number, then multiplies by the second.
            safeHash = (safeHash ^ prime1) &* prime2
            
            // Then this part XORs it with the third prime number and subtracts the fourth.
            safeHash = (hash ^ prime3) &- prime4
            
            // The hash gets outputted as a numerical value instead of the null hash.
            return safeHash
        }
    }
        
    // The hash gets outputted as a numerical value.
    return hash
}

/* PassGuard Encrypt - PassCrypt
A proof-of-concept encryption algorithm designed to obfuscate data stored in the master table.*/

func PassCrypt(Data: String, Password: String, Mode: Bool) -> String {
    
    /* Variables
     This section of code declares variables and some immutable values to be used in encryption handling, such as values used for XOR constants that will be used in key expansion.*/
    
    // This will store the current encryption state
    
    var state: Int = 0
    
    // This section initialises prime numbers to produce secure and reversible transformations that can be combined with the five round keys generated
    
    let prime1: Int = 15485863
    let prime2: Int = 982451653
    let prime3: Int = 314159
    let prime4: Int = 2718281829
    let prime5: Int = 7154629
    
    // This section declases the five round keys, and sets them all to zero, later replaced with an encoded version of the password
    
    var key1: Int = 0
    var key2: Int = 0
    var key3: Int = 0
    var key4: Int = 0
    var key5: Int = 0
    
    // This section declares the shifting box arrays and the inverse shifts
    
    /* Operations
     This section performs operations to encrypt and decrypt the inputted data, along with safely encoding the bytes.*/
    
    // This section sets the state to an encoded version of the data string
    
    state = encodeString(text: Data)
    
    // keys should be set to the encoded string value
    
    // Data should be encoded to a BigInt Value
    
    // IF mode is true, perform enctryption steps
    
    // ELSE perform inverse functions like revsbox etc
    
    /* Functions
     This section outlines Rijndael style operations to be carried out on data.*/
    
    /* Inverse Functions
     This section outlines Rijndael style inverse operations to be carried out on data.*/
    
    /* Data Processing
     This section outlines Unicode data processing algorithms to allow the conversion between string and integer.*/
    
    // This section encodes strings
    
    func encodeString(text: String) -> Int {
        let encodedArray = text.unicodeScalars.map { Int($0.value) }
        let combinedValue = encodedArray.reduce(0) { result, value in
            return result * 10 + value // Adjust the base as needed
        }
        return combinedValue
    }
    
    // This section decodes integers
    
    func decodeString(encoded: Int) -> String {
        var remainingValue = Int(encoded)
        var decodedArray: [Int] = []

        while remainingValue > 0 {
            let digit = remainingValue % 10
            decodedArray.insert(digit, at: 0)
            remainingValue /= 10
        }

        let characters = decodedArray.map { UnicodeScalar($0 + 48)! }
        return String(String.UnicodeScalarView(characters))
    }
    
    let output = decodeString(encoded: state)
    return output
}

/* Comprimised Account Notifications - SecurityCheck
An algorithm powered by the HIBP API to return the sites which have the breached account in*/

func SecurityCheck(account: String, siteName: String, apiKey: String) -> (Int, String) {
    
    // This section declares variables which will be used throught the function.
    let apiUrl = "https://haveibeenpwned.com/api/v3/breachedaccount/\(account)?truncateResponse=false"
    var isBreachDetected = false
    var breachDescription = ""
    let semaphore = DispatchSemaphore(value: 0)
    
    // The SecurityCheck function will give a returnCode 1 if another failure occured, a returnCode 2 if the API can't authenticate, a returnCode of 3 if a breach was located and a returnCode of 4 if the account is secure.
    var returnCode = 0
    
    // The API Rqeuest that was formed with the user's account will be used here to open a HTTP connection
    if let url = URL(string: apiUrl) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // The API key will be sent in the relevant header
        request.setValue(apiKey, forHTTPHeaderField: "hibp-api-key")
        
        // This part of the logic will parse the JSON response from the HIBP API
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let breaches = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        for breach in breaches {
                            
                            // If the Name response from the API matches the siteName passed through, then a breach will be marked as detected
                            if let name = breach["Name"] as? String, name == siteName {
                                isBreachDetected = true
                                
                                // The returnCode will be set to 3 to match this change, and the description will be located and passed through
                                returnCode = 3
                                if let description = breach["Description"] as? String {
                                    breachDescription = description
                                }
                                break
                            }
                        }
                    }
                } catch {
                    
                    // This part of the logic covers an unknown error in the API handling, or if the device is offline
                    returnCode = 1
                }
            } else {
                
                // This part of the logic covers an error in the API's authentication
                returnCode = 2
            }
            semaphore.signal()
        }
        task.resume()
    } else {
        
        // If it can't get the URL, the semaphore sends a signal to continue the task
        semaphore.signal()
    }

    semaphore.wait()
    
    // This will remove HTML features from the returned breachDescription using regex
    breachDescription = breachDescription.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    
    // This will check if the account is secure (returnCode = 4) only if no breach was detected
    if !isBreachDetected {
        returnCode = 4
    }
    
    return (returnCode, breachDescription)
}

/* Secure Password Generation - PasswordGenerator
An algorithm that can create passwords, with a random character set, a word dictionary, or a letter only system. If the Type is 1, the word generation system is used. If the Type is 2 the character generation system is used, and if the Type is 3 the character generation system is used, but special characters are excluded.*/

func PasswordGenerator(Type: Int, Complexity: Int) -> String {
    
    // This section declares the Password string
    var password = ""
    
    // This section is the array of random words to use when generating a password, and the characters to use
    let wordDictionary = ["apple", "banana", "chocolate", "dolphin", "elephant", "firefly", "giraffe", "happiness", "icecream", "jazz", "kiwi", "lighthouse", "mango", "notebook", "ocean", "parrot", "quasar", "rainbow", "sunset", "tiger", "umbrella", "violin", "waterfall", "xylophone", "yellow", "zebra", "astronomy", "butterfly", "carousel", "daffodil", "eagle", "flamingo", "guitar", "harmony", "island", "jupiter", "koala", "lullaby", "moonlight", "nutmeg", "octopus", "penguin", "quilt", "rattlesnake", "sunflower", "trampoline", "unity", "vibrant", "whisper", "xylograph", "yoga", "zephyr", "acoustic", "blossom", "cinnamon", "dreamcatcher", "enigma", "fantasy", "gondola", "hologram", "inspiration", "journey", "kaleidoscope", "labyrinth", "mermaid", "nirvana", "orchid", "pyramid", "quasar", "rhapsody", "sapphire", "tornado", "utopia", "volcano", "wilderness", "xanadu", "yearning", "zenith", "alchemy", "bliss", "crescendo", "divinity", "effervescence", "fandango", "galaxy", "halcyon", "illumination", "jubilee", "kismet", "luminescence", "mellifluous", "nirvana", "opulence", "panorama", "quintessence", "radiance", "serendipity", "tranquility", "utopia", "vivacity", "wanderlust", "xenial", "yearning", "zenith", "abundance", "blissful", "catalyst", "delightful", "ephemeral", "felicity", "gratitude", "harmonious", "inspiration", "jubilant", "kaleidoscopic", "luminous", "magnificent", "nurturing", "optimistic", "pacific", "quixotic", "radiant", "serene", "tranquil", "uplifting", "vibrant", "whimsical", "xanadu", "youthful", "zealous", "alluring", "breathtaking", "captivating", "dazzling", "enchanting", "fascinating", "gorgeous", "hypnotic", "intriguing", "jovial", "kaleidoscopic", "luscious", "mesmerizing", "nurturing", "opulent", "picturesque", "quaint", "resplendent", "scintillating", "tantalizing", "unforgettable", "voluptuous", "winsome", "exquisite", "youthful", "zesty", "affectionate", "brilliant", "charming", "daring", "ethereal", "fearless", "graceful", "honest", "innovative", "joyful", "kindhearted", "loyal", "magnanimous", "noble", "optimistic", "passionate", "quiet", "resilient", "sincere", "tenacious", "uplifting", "versatile", "witty", "xenial", "yielding", "zealous", "adventurous", "bold", "creative", "determined", "enthusiastic", "fearless", "gregarious", "hopeful", "intelligent", "jovial", "kind", "lively", "motivated", "nonchalant", "open-minded", "playful", "quirky", "resilient", "sociable", "thoughtful", "unbiased", "vibrant", "warmhearted", "xenial", "youthful", "zesty", "amazing", "brilliant", "charismatic", "dazzling", "effervescent", "flawless", "graceful", "heartwarming", "inspiring", "jubilant", "kaleidoscopic", "luminous", "mesmerizing", "nurturing", "optimistic", "passionate", "quixotic", "radiant", "serene", "tenacious", "uplifting", "vivacious", "winsome", "xenial", "yearning", "zealous", "abundant", "blissful", "candid", "delightful", "effervescent", "fanciful", "grateful", "harmonious", "innocent", "joyful", "kaleidoscopic", "lighthearted", "mirthful", "naive", "optimistic", "playful", "quaint", "radiant", "serendipitous", "tranquil", "unassuming", "vibrant", "whimsical", "xenial", "youthful", "zealous", "apple", "banana", "chocolate", "dolphin", "elephant", "firefly", "giraffe", "happiness", "icecream", "jazz", "bread", "christmas", "craig", "apple"]
    // This section allows the character dictionary to switch between special and standard depending on type
    let characters = (Type == 3) ? "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-=_+[]{}|;:'\",.<>/?": "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    // This chooses a random word from the dictionary
    func PasswordGeneratorGenerateWord() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(wordDictionary.count)))
        return wordDictionary[randomIndex]
    }

    // This chooses a random character in the string
    func PasswordGeneratorGenerateCharacter() -> Character {
        let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
        return characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
    }

    if Type == 1 {
        
        // This section of the logic generates words, and concatenates them with a dash to seperate them
        for _ in 1...Complexity {
            password += PasswordGeneratorGenerateWord() + "-"
        }
        
        // The extra dash added to the last word is removed here
        password = String(password.dropLast())
        
    } else if Type == 2 || Type == 3 {
        
        // This part will make sure that an extra random selection is added until it reaches the length passed through as Complexity
        for _ in 1...Complexity {
            password.append(PasswordGeneratorGenerateCharacter())
        }
    }

    return password
}

/* PassGuard Onboarding Initialiser - OnboardingInitialiser
An algorithm that initialises the application with all the user's data, and creates the relevant dependencies. If the system initialisation fails, then the system will return 0, if it succeeds then 1 is returned.*/

func OnboardingInitialiser(Name: String, Password: String) -> Int {
    
    let hashedPassword = String(PassHash(Password))
    
    // This section initialises the database with the computed values
    
    do {
        
        // This section finds the user's home directory and creates a new subpath called PassGuard
        let passGuardPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("PassGuard")
        
        // This adds PassGuardDatabase.sqlite3 onto the end of the path, which allows a database to be created here
        let dbPath = passGuardPath.appendingPathComponent("PassGuardDatabase.sqlite3")
        
        // This checks if the directory already exists, and fails safe with an error code
        if FileManager.default.fileExists(atPath: dbPath.path) {
            return 0
        }
        
        // This creates the PassGuard folder to store the database in
        try FileManager.default.createDirectory(at: passGuardPath, withIntermediateDirectories: true, attributes: nil)

        // This connects to that database file
        let db = try Connection(dbPath.path)

        // The CredentialTable is created here
        try db.run("""
            CREATE TABLE IF NOT EXISTS CredentialTable (
                ObjectID INTEGER PRIMARY KEY,
                DateAccessed DATETIME,
                Tag TEXT,
                ObjectType TEXT CHECK (ObjectType IN ('Card', 'Note', 'Password')),
                Username TEXT,
                Password TEXT,
                Webpage TEXT,
                CardNumber TEXT,
                Expiry TEXT,
                CVV TEXT,
                Notes TEXT
            )
        """)

        // The TrashTable is created here
        try db.run("""
            CREATE TABLE IF NOT EXISTS TrashTable (
                ObjectID INTEGER PRIMARY KEY,
                TrashedDate DATETIME,
                FOREIGN KEY (ObjectID) REFERENCES CredentialTable(ObjectID)
            )
        """)

        // The SecurityTable is created here
        try db.run("""
            CREATE TABLE IF NOT EXISTS SecurityTable (
                ObjectID INTEGER PRIMARY KEY,
                Complexity INTEGER,
                Compromised INTEGER CHECK (Compromised IN (0, 1)),
                FOREIGN KEY (ObjectID) REFERENCES CredentialTable(ObjectID)
            )
        """)
        
        // This adds Account.sqlite3 onto the end of the path, which allows a database to be created here
        let accountPath = passGuardPath.appendingPathComponent("Account.sqlite3")
        
        // This checks if the directory already exists, and fails safe with an error code
        if FileManager.default.fileExists(atPath: accountPath.path) {
            return 0
        }

        // This connects to that database file
        let account = try Connection(accountPath.path)

        // The AccountTable is created here
        try account.run("""
            CREATE TABLE IF NOT EXISTS AccountTable (
                Name TEXT PRIMARY KEY,
                Password TEXT
            )
        """)

        // This inserts the passed through values into the AccountTable
        try account.run("INSERT OR REPLACE INTO AccountTable (Name, Password) VALUES (?, ?)", Name, hashedPassword)
        return 1
    } catch {
        print("PassGuard Internal Error: \(error)")
        return 0
    }
}

func ValidateCredentials(Password: String) -> Bool {
    
    let hashedPassword = String(PassHash(Password))
    let accountTable = Table("AccountTable")
    @State var nameColumn = Expression<String>("Name")
    let passwordColumn = Expression<String>("Password")
    
    do {
    
        // This section finds the user's home directory
        let passGuardPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("PassGuard")
        
        // This adds PassGuardDatabase.sqlite3 onto the end of the path, which allows a database to be created here
        let dbPath = passGuardPath.appendingPathComponent("Account.sqlite3")
        
        // This connects to that database file
        let db = try Connection(dbPath.path)
        
        // This gets the first record in the table
        if let firstAccount = try db.pluck(accountTable) {
            let storedHashedMasterPassword = try firstAccount.get(passwordColumn)
            
            // This part checks if the hashed Master Password is equal to the hashed Master Password stored
            if storedHashedMasterPassword == hashedPassword {
                return true
            } else {
                return false
            }
        }
        
    } catch {
        print("PassGuard Internal Error: \(error)")
        return false
    }
    
    return false
}

func AccountExists() -> Bool {
    
    do {
        // This section finds the user's home directory
        let passGuardPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("PassGuard")
        
        // This adds PassGuardDatabase.sqlite3 onto the end of the path, which allows the database file to be found
        let dbPath = passGuardPath.appendingPathComponent("Account.sqlite3")
        
        // This checks if a file is found at the location, if it is it's returned as true, else false
        if FileManager.default.fileExists(atPath: dbPath.path) {
            return true
        }
        else {
            return false
        }
    } catch {
        print("PassGuard Internal Error")
        return false
    }
}

func DeleteAccount() -> Bool {
    
    do {
        // This section finds the user's home directory
        let passGuardPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("PassGuard")
        
        // This adds PassGuardDatabase.sqlite3 onto the end of the path, which allows the database file to be found
        let dbPath = passGuardPath.appendingPathComponent("PassGuardDatabase.sqlite3")
        let accountPath = passGuardPath.appendingPathComponent("Account.sqlite3")
        
        // This section deletes the database
        try FileManager.default.removeItem(at: dbPath)
        try FileManager.default.removeItem(at: accountPath)
        
        // This checks if the database still exists, if it does false is returned, if not true is returned
        if FileManager.default.fileExists(atPath: dbPath.path) {
            return false
        }
        // This checks if the account still exists, if it does false is returned, if not true is returned
        else if FileManager.default.fileExists(atPath: accountPath.path) {
            return false
        }
        else {
            return true
        }
    } catch {
        print("PassGuard Internal Error")
        return false
    }
}

func GetUsername() -> String {
    
    let accountTable = Table("AccountTable")
    @State var nameColumn = Expression<String>("Name")
    
    do {
    
        // This section finds the user's home directory
        let passGuardPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("PassGuard")
        
        // This adds PassGuardDatabase.sqlite3 onto the end of the path, which allows a database to be created here
        let dbPath = passGuardPath.appendingPathComponent("Account.sqlite3")
        
        // This connects to that database file
        let db = try Connection(dbPath.path)
        
        // This gets the first record in the table
        if let firstAccount = try db.pluck(accountTable) {
            let username = try firstAccount.get(nameColumn)
        
        // This returns the username
        return username
        }
        
    } catch {
        return "PassGuard Internal Error: \(error)"
    }
    
    return "PassGuard Internal Error"
}

func UnlockPassGuard() -> Bool {
    // not finished yet
    return true
}
