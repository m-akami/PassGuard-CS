# PassGuard-CS
PassGuard-CS is a proof-of-concept Password Manager application built using SwiftUI and SwiftData. This implementation is designed for educational purposes and may not provide the same level of security as professional-grade password managers as it is part of my assignment, aimed at exploring the logic behind algorithms and expanding my personal knowledge of SwiftUI.

## Images

OnboardingWindow.swift:
<img width="562" alt="image" src="https://github.com/m-akami/PassGuard-CS/assets/123811425/31e4f644-6c19-4946-b59b-7952ad90dfc6">

LoginWindow.swift
<img width="562" alt="Screenshot 2023-11-26 at 16 39 43" src="https://github.com/m-akami/PassGuard-CS/assets/123811425/0f98f227-4dad-43b1-a184-72258778af17">

## Features
PassGuard is a feature rich application that manages a range of data.
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
While PassGuard-CS is a functional prototype, you must acknowledge its limitations, especially around security:
- Encryption Level: The encryption and security mechanisms implemented in this assignment may not be secure, as they have been created by me.
- Security Auditing: PassGuard-CS has not undergone a comprehensive security audit, which is important for mitigating vulnerabilities.
- Safe Usage: Be cautious when using PassGuard-CS to store sensitive information, as it may not be reliable.

## Project Purpose
The primary purpose of PassGuard-CS is to serve as a practical assignment for educational purposes. I have tried to include multiple concepts in this app, and have open-sourced it as others may be able to learn from it. I have used the following concepts in this project:
- User Interface Design with SwiftUI
- Data Storage and Retrieval with SQLite and SwiftData for secret management
- Password Strength Evaluation
- Basic Encryption Principles
- Error Handling and Validation
- Usage of APIs

## Important Note
PassGuard-CS is not intended for real-world, secure password management. For actual password management, I recommended you use vetted password manager applications that prioritize security and privacy.
