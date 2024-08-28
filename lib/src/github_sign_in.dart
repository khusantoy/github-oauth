import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'github_sign_in_page.dart';
import 'github_sign_in_result.dart';

class GitHubSignIn {
  final String clientId;
  final String clientSecret;
  final String redirectUrl;
  final String scope;
  final String title;
  final bool? centerTitle;
  final bool allowSignUp;
  final bool clearCache;
  final String? userAgent;

  final Dio _dio;

  final String _githubAuthorizedUrl = "https://github.com/login/oauth/authorize";
  final String _githubAccessTokenUrl = "https://github.com/login/oauth/access_token";

  GitHubSignIn({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUrl,
    this.scope = "user,gist,user:email",
    this.title = "",
    this.centerTitle,
    this.allowSignUp = true,
    this.clearCache = true,
    this.userAgent,
    Dio? dio,
  }) : _dio = dio ?? Dio();

  Future<GitHubSignInResult> signIn(BuildContext context) async {
    var authorizedResult;

    if (kIsWeb) {
      authorizedResult = await launchUrl(
        Uri.parse(_generateAuthorizedUrl()),
        webOnlyWindowName: '_self',
      );
      // Push data into authorized result somehow (if applicable)
    } else {
      authorizedResult = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GitHubSignInPage(
            url: _generateAuthorizedUrl(),
            redirectUrl: redirectUrl,
            userAgent: userAgent,
            clearCache: clearCache,
            title: title,
            centerTitle: centerTitle,
          ),
        ),
      );
    }

    if (authorizedResult == null ||
        authorizedResult.toString().contains('access_denied')) {
      return GitHubSignInResult(
        GitHubSignInResultStatus.cancelled,
        errorMessage: "Sign In attempt has been cancelled.",
      );
    } else if (authorizedResult is Exception) {
      return GitHubSignInResult(
        GitHubSignInResultStatus.failed,
        errorMessage: authorizedResult.toString(),
      );
    }

    // Exchange authorization code for access token
    return await _getAccessToken(authorizedResult);
  }

  Future<GitHubSignInResult> _getAccessToken(String code) async {
    try {
      var response = await _dio.post(
        _githubAccessTokenUrl,
        data: {
          "client_id": clientId,
          "client_secret": clientSecret,
          "code": code,
          "redirect_uri": redirectUrl,
        },
        options: Options(
          headers: {"Accept": "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        var body = response.data;
        return GitHubSignInResult(
          GitHubSignInResultStatus.ok,
          token: body["access_token"],
        );
      } else {
        return GitHubSignInResult(
          GitHubSignInResultStatus.failed,
          errorMessage: "Unable to obtain token. Received: ${response.statusCode}",
        );
      }
    } catch (e) {
      return GitHubSignInResult(
        GitHubSignInResultStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }

  String _generateAuthorizedUrl() {
    return "$_githubAuthorizedUrl?client_id=$clientId&redirect_uri=$redirectUrl&scope=$scope&allow_signup=$allowSignUp";
  }
}
