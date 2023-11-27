# PassGuard-CS
PassGuard-CS is a proof-of-concept Password Manager application built using SwiftUI and SQLite.swift. This implementation is designed for educational purposes and may not provide the same level of security as professional-grade password managers as it is part of my assignment, aimed at exploring the logic behind algorithms and expanding my personal knowledge of SwiftUI.

## Images

<div>
  <p><strong>OnboardingWindow.swift</strong></p>
  <img width="300" alt="LoginWindow.swift" src="https://github.com/m-akami/PassGuard-CS/assets/123811425/31e4f644-6c19-4946-b59b-7952ad90dfc6">
</div>

<div>
  <p><strong>LoginWindow.swift</strong></p>
  <img width="300" alt="redacted" src="https://github.com/m-akami/PassGuard-CS/assets/123811425/0f98f227-4dad-43b1-a184-72258778af17">
</div>

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
