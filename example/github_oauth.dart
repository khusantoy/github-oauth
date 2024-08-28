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

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub OAuth Example')),
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
          child: const Text('Sign in with GitHub'),
        ),
      ),
    );
  }
}