# PassGuard-CS
PassGuard-CS is a proof-of-concept Password Manager application built using SwiftUI and SQLite.swift. This implementation is designed for educational purposes and may not provide the same level of security as professional-grade password managers as it is part of my A-Level Computer Science assignment, aimed at exploring the logic behind algorithms and expanding my personal knowledge of SwiftUI.

## Images

<img width="602" alt="Screenshot 2024-03-14 at 12 09 50" src="https://github.com/m-akami/PassGuard-CS/assets/123811425/f3c40de8-510a-42c0-8e69-cc79db1a4b4b">


<img width="1012" alt="image" src="https://github.com/m-akami/PassGuard-CS/assets/123811425/0bc3157b-1932-4a69-8006-d6632b3aaec1">

<img width="1019" alt="Screenshot 2024-03-14 at 12 10 07" src="https://github.com/m-akami/PassGuard-CS/assets/123811425/5e7683c8-bdd0-426b-ac16-63fedb3cc92d">

<img width="1078" alt="Screenshot 2024-03-14 at 12 13 32" src="https://github.com/m-akami/PassGuard-CS/assets/123811425/f82e5a31-cea7-42fd-bcd3-e8541a811ad1">


## Honourable Mentions
Even though this is a small project for educational purposes, I believe the people that (indirectly) contributed to this project must be mentioned.
SQLite.swift - Massive thanks to everyone building SQLite.swift, couldn't have done most of the database operations easily without this wrapper (https://github.com/stephencelis/SQLite.swift)
Swift - The language that powers this application. Also really nice to program in, thanks Apple! (https://github.com/apple/swift)

## Features
- Simple UI: The PassGuard user interface is designed to be modern and simple.
- Information Grouping: Credentials of the same type are grouped together.
- Responsive Design: PassGuard is able to scale to multiple display sizes.
- Secure Notes: You can create Secure Notes, which will be encrypted and displayed alongside your credentials.
- AutoFill Functionality: PassGuard can autofill passwords using a Safari Extension.
- Password Generation: PassGuard can create secure passwords.
- Password Rating: PassGuard can grade credential security and check for reused passwords across sites.
- Compromised Account Notifications: Using HIBP's API, credentials are securely sent to check if they are compromised using HTTPS.
- Inactivity Notifications: If a credential has not been used in a while, PassGuard will reccomend that the online account be deleted.

## Security Considerations
I have personally designed the security backend for this application: PassCrypt and PassHash, used for encryption and hashing respectively, to protect items stored in this app. As this is an educational project, I have no baseline to judge on how secure and how reliable my code is, so production usage would be discouraged.

## Project Purpose
I have tried to include multiple concepts in this app, and have open-sourced it as others may be able to learn from it. I have used the following concepts in this project:
- User Interface Design with SwiftUI
- Data Storage and Retrieval with SQLite and SwiftData for secret management
- Password Strength Evaluation
- Basic Encryption Principles
- Error Handling and Validation
- Usage of APIs

## Important Note
PassGuard-CS is not intended for real-world, secure password management. For actual password management, I recommended you use vetted password manager applications that prioritize security and privacy.
