class SlackValidateParam{
  final String botToken;
  final String clientId;
  final String clientSecret;
  final String signingSecret;

  SlackValidateParam({
    required this.botToken,
    required this.clientId,
    required this.clientSecret,
    required this.signingSecret});

}