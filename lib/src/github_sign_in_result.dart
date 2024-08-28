class GitHubSignInResult {
  final String? token;
  final GitHubSignInResultStatus status;
  final String? errorMessage;
  final Map<String, dynamic>? userProfile;

  GitHubSignInResult(
    this.status, {
    this.token,
    this.errorMessage,
    this.userProfile,
  }) : assert(
            (status == GitHubSignInResultStatus.ok && token != null) ||
                (status != GitHubSignInResultStatus.ok && errorMessage != null),
            "Error message must be provided for failed or cancelled statuses, and token must be provided for success.");
}

enum GitHubSignInResultStatus {
  /// The login was successful.
  ok,

  /// The user cancelled the login flow, usually by closing the
  /// login dialog.
  cancelled,

  /// The login completed with an error and the user couldn't log
  /// in for some reason.
  failed,
}
