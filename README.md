 # GitHub OAuth for Flutter

 `github_oauth` is a Flutter package that simplifies the process of integrating GitHub OAuth authentication into your app. With this package, you can provide a seamless GitHub sign-in experience, handle token exchanges, and authenticate users securely.

 ## Features

 - **Complete OAuth2 Flow**: Handles the entire GitHub OAuth process, from user login to token retrieval.
 - **Customizable UI**: Customize the sign-in page title and WebView configuration to match your app's branding.
 - **WebView Integration**: Provides a native WebView for a smooth sign-in experience.
 - **Secure Token Handling**: Retrieve and manage GitHub access tokens securely.
 - **Comprehensive Error Handling**: Manage errors throughout the OAuth process.

 ## Installation

 Add `github_oauth` to your `pubspec.yaml`:

 ```yaml
 dependencies:
   github_oauth: latest_version
 ```

 Then run `flutter pub get` to install the package.

 ## Usage

 ### 1. Setup GitHub OAuth App

 To use GitHub OAuth, you need to set up an OAuth app on GitHub. Follow these steps:

 1. Go to [GitHub Developer Settings](https://github.com/settings/developers).
 2. Register a new OAuth application.
 3. Set your app's redirect URI (e.g., `yourapp://callback`).

 ### 2. Configure GitHubSignIn

 Import the package and initialize `GitHubSignIn` with your GitHub OAuth credentials. Use the `dotenv` package to manage sensitive information:

 ```dart
 import 'package:flutter_dotenv/flutter_dotenv.dart';
 import 'package:github_oauth/github_oauth.dart';

 final gitHubSignIn = GitHubSignIn(
   clientId: dotenv.env['GITHUB_CLIENT_ID']!,
   clientSecret: dotenv.env['GITHUB_CLIENT_SECRET']!,
   redirectUrl: dotenv.env['GITHUB_REDIRECT_URL']!,
 );
 ```

 ### 3. Sign In with GitHub

 Call the `signIn` method to trigger the OAuth flow:

 ```dart
 void _signInWithGitHub(BuildContext context) async {
   final result = await gitHubSignIn.signIn(context);

   if (result.status == GitHubSignInResultStatus.ok) {
     // Successfully signed in
     print("Access Token: ${result.token}");
     print("User Profile: ${result.userProfile}");
   } else {
     // Handle error
     print("Sign In Failed: ${result.errorMessage}");
   }
 }
 ```

 ### 4. Customize WebView

 You can customize the WebView used during the sign-in process by passing additional parameters to `GitHubSignInPage`:

 ```dart
 GitHubSignInPage(
   url: 'authorization-url',
   redirectUrl: 'redirect-url',
   title: 'Sign in with GitHub',
   userAgent: 'Custom User Agent',
   clearCache: true,
 );
 ```

 ## Example

 Here's a complete example of how to use the `github_oauth` package:

 ```dart
 import 'package:flutter/material.dart';
 import 'package:github_oauth/github_oauth.dart';
 import 'package:flutter_dotenv/flutter_dotenv.dart';

 void main() async {
   await dotenv.load();
   runApp(MyApp());
 }

 class MyApp extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       home: SignInPage(),
     );
   }
 }

 class SignInPage extends StatelessWidget {
   final GitHubSignIn githubSignIn = GitHubSignIn(
     clientId: dotenv.env['GITHUB_CLIENT_ID']!,
     clientSecret: dotenv.env['GITHUB_CLIENT_SECRET']!,
     redirectUrl: dotenv.env['GITHUB_REDIRECT_URL']!,
   );

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: Text('GitHub OAuth Example')),
       body: Center(
         child: ElevatedButton(
           onPressed: () async {
             final result = await githubSignIn.signIn(context);

             if (result.status == GitHubSignInResultStatus.ok) {
               // Successfully signed in
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('Token: ${result.token}')),
               );
             } else {
               // Error handling
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('Error: ${result.errorMessage}')),
               );
             }
           },
           child: Text('Sign in with GitHub'),
         ),
       ),
     );
   }
 }
 ```

 ## Error Handling

 The `GitHubSignInResult` includes status and error messages, which can help you handle various scenarios:

 ```dart
 if (result.status == GitHubSignInResultStatus.ok) {
   // Successfully signed in
 } else if (result.status == GitHubSignInResultStatus.cancelled) {
   // User cancelled the sign-in process
 } else {
   // Sign-in failed
   print('Error: ${result.errorMessage}');
 }
 ```

 ## Contribution

 Contributions are welcome! If you find a bug or have an idea for a new feature, feel free to open an issue or submit a pull request.

 ## License

 This package is licensed under the MIT License. See the LICENSE file for more details.
