import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/preview/presentation/notifier/preview_chat_notifier.dart';
import 'package:step_ai/features/publish/domain/params/messenger_validate_param.dart';
import 'package:step_ai/features/publish/domain/params/slack_validate_param.dart';
import 'package:step_ai/features/publish/domain/params/telegram_param.dart';
import 'package:step_ai/features/publish/presentation/notifier/publish_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/styles/colors.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  //Slack controllers:
  final _tokenSlackController = TextEditingController();
  final _clientIdSlackController = TextEditingController();
  final _clientSecretSlackController = TextEditingController();
  final _signingSecretSlackController = TextEditingController();

  //Telegram controllers:
  final _tokenTelegramController = TextEditingController();

  //Messenger controllers:
  final _tokenMessengerController = TextEditingController();
  final _pageIdMessengerController = TextEditingController();
  final _appSecretMessengerController = TextEditingController();

  //Notifier:
  late PublishNotifier _publishNotifier;
  late PreviewChatNotifier _previewChatNotifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _previewChatNotifier =
          Provider.of<PreviewChatNotifier>(context, listen: false);
      _publishNotifier = Provider.of<PublishNotifier>(context, listen: false);

      if (_publishNotifier.currentAssistant == null) {
        _publishNotifier.setAssistant(_previewChatNotifier.currentAssistant!);
      }
      await _publishNotifier.getPublishedList();
    });
  }

  //Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Publish Configuration'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: Navigator.of(context).pop),
        ),
        body: Consumer<PublishNotifier>(builder: (context, notifier, child) {
          return notifier.isLoading
              ? Center(child: _twistingDotsLoadIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "By publishing your bot on the following platforms, you fully understand and agree to abide by Terms of service for each publishing channel (including, but not limited to, any privacy policy, community guidelines, data processing agreement, etc.).",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),
                        //Slack: -----------------------------------------------------------
                        _buildSlackConfigureCard(notifier),
                        //Telegram:--------------------------------------------------------
                        _buildTelegramConfigureCard(notifier),
                        //Messenger:--------------------------------------------------------
                        _buildMessengerConfigureCard(notifier),
                      ]),
                );
        }));
  }

  Widget _buildSlackConfigureDialog(String id) {
    return AlertDialog(
      backgroundColor: TColor.doctorWhite,
      title: const Text('Configure Slack Bot'),
      content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connect to Slack Bots and chat with this bot in Slack App',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                Text(
                  'How to obtain Slack configurations?',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue),
                ),
                SizedBox(height: 20),
                const Text(
                  '1. Slack copy link\n'
                  'Copy the following content to your Slack app configuration page.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                const Text('OAuth2 Redirect URLs'),
                _buildUrlLink(
                    'https://knowledge-api.jarvis.cx/kb-core/v1/bot-integration/slack/auth/$id'),
                SizedBox(height: 10),
                Text('Event Request URL'),
                _buildUrlLink(
                    'https://knowledge-api.jarvis.cx/kb-core/v1/hook/slack/$id'),
                SizedBox(height: 10),
                Text('Slash Request URL'),
                _buildUrlLink(
                    'https://knowledge-api.jarvis.cx/kb-core/v1/hook/slack/slash/$id'),
                SizedBox(height: 20),
                const Text(
                  '2. Slack information',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _tokenSlackController,
                  decoration: InputDecoration(
                    labelText: 'Token',
                    hintText: 'Enter Bot Token',
                    labelStyle: TextStyle(fontSize: 12, color: TColor.petRock),
                    hintStyle: const TextStyle(fontSize: 12),
                    // errorText: _tokenSlackController.text.isEmpty ? 'This field is required' : null,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: _clientIdSlackController,
                  decoration: InputDecoration(
                    labelText: 'Client ID',
                    labelStyle: TextStyle(fontSize: 12, color: TColor.petRock),
                    hintText: 'Enter Client ID',
                    hintStyle: const TextStyle(fontSize: 8),
                    // errorText: _clientIdSlackController.text.isEmpty ? 'This field is required' : null,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _clientSecretSlackController,
                  decoration: InputDecoration(
                    labelText: 'Client Secret',
                    labelStyle: TextStyle(fontSize: 12, color: TColor.petRock),
                    hintText: 'Enter Client Secret',
                    hintStyle: const TextStyle(fontSize: 12),
                    // errorText: _clientSecretSlackController.text.isEmpty ? 'This field is required' : null,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _signingSecretSlackController,
                  decoration: InputDecoration(
                    labelText: 'Signing Secret',
                    labelStyle: TextStyle(fontSize: 12, color: TColor.petRock),
                    hintText: 'Enter Signing Secret',
                    hintStyle: const TextStyle(fontSize: 12),
                    // errorText: _signingSecretSlackController.text.isEmpty ? 'This field is required' : null,
                  ),
                ),
              ],
            ),
          )),
      actions: [
        TextButton(
          onPressed: () async {
            try {
              Navigator.of(context).pop();
              SlackValidateParam param = SlackValidateParam(
                  botToken: _tokenSlackController.text,
                  clientId: _clientIdSlackController.text,
                  clientSecret: _clientSecretSlackController.text,
                  signingSecret: _signingSecretSlackController.text);
              bool val = await _publishNotifier.validateSlack(param);
              if (val) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully verified.'),
                    duration: Duration(seconds: 1),
                  ),
                );
                //call publish here.
                await _publishNotifier.publishSlack(param);
                await _publishNotifier.getPublishedList();
              }
            } catch (e) {
              if (e == 422) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Publish failed: Wrong token.'),
                    duration: Duration(seconds: 1),
                  ),
                );
              } else if (e == 401) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Publish failed: Unauthorized'),
                    duration: Duration(seconds: 1),
                  ),
                );
                //TODO: Logout
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.authenticate,
                  (Route<dynamic> route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Publish failed: Some information are wrong.'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }
          },
          child: Text('OK', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: TColor.tamarama),),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel',style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: TColor.petRock),),
        ),
      ],
    );
  }

  Widget _buildTelegramConfigureDialog(String id) {
    return AlertDialog(
      backgroundColor: TColor.doctorWhite,
      title: const Text('Configure Telegram Bot'),
      content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Connect to Telegram Bots and chat with this bot in Telegram App',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                const Text(
                  'How to obtain Telegram configurations?',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue),
                ),
                const SizedBox(height: 20),
                const Text(
                  '1. Telegram information',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _tokenTelegramController,
                  decoration: InputDecoration(
                    labelText: 'Token',
                    labelStyle: TextStyle(fontSize: 12, color: TColor.petRock),
                    hintText: 'Enter Bot Token',
                    hintStyle: const TextStyle(fontSize: 12),
                    // errorText: _tokenSlackController.text.isEmpty ? 'This field is required' : null,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          )),
      actions: [
        TextButton(
          onPressed: () async {
            try {
              Navigator.of(context).pop();
              bool val = await _publishNotifier.validateTelegram(
                  TelegramParam(_tokenTelegramController.text));
              if (val) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully verified.'),
                    duration: Duration(seconds: 1),
                  ),
                );
                //call publish here.
                await _publishNotifier
                    .publishTelegram(_tokenTelegramController.text);
                await _publishNotifier.getPublishedList();
              }
            } catch (e) {
              if (e == 422) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Publish failed: Wrong token.'),
                    duration: Duration(seconds: 1),
                  ),
                );
              } else if (e == 401) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Publish failed: Unauthorized'),
                    duration: Duration(seconds: 1),
                  ),
                );
                //TODO: Logout
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.authenticate,
                  (Route<dynamic> route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Publish failed: Unknown error'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }
          },
          child: Text('OK', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: TColor.tamarama),),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: TColor.petRock),),
        ),
      ],
    );
  }

  Widget _buildMessengerConfigureDialog(String id) {
    return AlertDialog(
      backgroundColor: TColor.doctorWhite,
      title: const Text('Configure Messenger Bot'),
      content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Connect to Messenger Bots and chat with this bot in Messenger App',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                const Text(
                  'How to obtain Slack configurations?',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue),
                ),
                SizedBox(height: 20),
                const Text(
                  '1. Message copy link\n'
                  'Copy the following content to your Slack app configuration page.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                const Text('Callback URL'),
                _buildUrlLink(
                    'https://knowledge-api.jarvis.cx/kb-core/v1/hook/messenger/$id'),
                const SizedBox(height: 10),
                const Text('Verify Token'),
                _buildUrlLink('knowledge'),
                const SizedBox(height: 10),
                const Text(
                  '2. Messenger information',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _tokenMessengerController,
                  decoration: InputDecoration(
                    labelText: 'Messenger Bot Token',
                    labelStyle: TextStyle(fontSize: 12, color: TColor.petRock),
                    hintText: 'Enter Bot Token',
                    hintStyle: TextStyle(fontSize: 12),
                    // errorText: _tokenSlackController.text.isEmpty ? 'This field is required' : null,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _pageIdMessengerController,
                  decoration: InputDecoration(
                    labelText: 'Messenger Bot Page ID',
                    labelStyle: TextStyle(fontSize: 12, color: TColor.petRock),
                    hintText: 'Enter Page ID',
                    hintStyle: TextStyle(fontSize: 12),
                    // errorText: _clientIdSlackController.text.isEmpty ? 'This field is required' : null,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _appSecretMessengerController,
                  decoration: InputDecoration(
                    labelText: 'Messenger Bot App Secret',
                    labelStyle: TextStyle(fontSize: 12, color: TColor.petRock),
                    hintText: 'Enter App Secret',
                    hintStyle: TextStyle(fontSize: 12),
                    // errorText: _clientSecretSlackController.text.isEmpty ? 'This field is required' : null,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          )),
      actions: [
        TextButton(
          onPressed: () async {
            try {
              Navigator.of(context).pop();
              MessengerValidateParam param = MessengerValidateParam(
                  botToken: _tokenMessengerController.text,
                  pageId: _pageIdMessengerController.text,
                  appSecret: _appSecretMessengerController.text);
              bool val = await _publishNotifier.validateMessenger(param);
              if (val) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully verified.'),
                    duration: Duration(seconds: 1),
                  ),
                );
                //call publish here.
                await _publishNotifier.publishMessenger(param);
                await _publishNotifier.getPublishedList();
              }
            } catch (e) {
              if (e == 422) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Publish failed: Wrong token.'),
                    duration: Duration(seconds: 1),
                  ),
                );
              } else if (e == 401) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Publish failed: Unauthorized'),
                    duration: Duration(seconds: 1),
                  ),
                );
                //TODO: Logout
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.authenticate,
                  (Route<dynamic> route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Publish failed: Some information are wrong.'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }
          },
          child: Text('OK', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: TColor.tamarama),),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: TColor.petRock),),
        ),
      ],
    );
  }

  Widget _buildUrlLink(String url) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: url));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied to clipboard'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Text(
        url,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _twistingDotsLoadIndicator() {
    return LoadingAnimationWidget.twistingDots(
      size: 50,
      leftDotColor: TColor.tamarama,
      rightDotColor: TColor.daJuice,
    );
  }

  Widget _buildSlackConfigureCard(PublishNotifier notifier) {
    return Card(
      elevation: 5,
      color: TColor.doctorWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "lib/core/assets/imgs/slack.png",
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () async {
                    if (notifier.slackUrl == null || notifier.slackUrl!.isEmpty)
                      return;
                    final Uri url = Uri.parse(notifier.slackUrl!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    "Slack",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: TColor.tamarama,
                        fontSize: 18,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                notifier.isConfiguredSlack
                    ? Text(
                        "Published",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w800,
                    color: TColor.tamarama,
                  ),
                      )
                    : Text(
                        "Not Configured",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w800,
                    color: TColor.poppySurprise,
                  ),
                      ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () async {
                    if (notifier.isConfiguredSlack) {
                      try {
                        await notifier.disconnect('slack');
                        await notifier.getPublishedList();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Disconnected Slack.'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } catch (e) {
                        if (e == 401) {
                          //TODO: reset & logout
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.authenticate,
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Disconnect failed: Unknown error.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      }
                      return;
                    }
                    //else
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildSlackConfigureDialog(
                              notifier.currentAssistant!.id!);
                        });
                  },
                  child: notifier.isConfiguredSlack
                      ? Text(
                          "Disconnect",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w800,
                      color: TColor.poppySurprise,
                    ),
                        )
                      : Text(
                          "Publish",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w800,
                      color: TColor.tamarama,
                    ),
                        ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelegramConfigureCard(PublishNotifier notifier) {
    return Card(
      elevation: 5,
      color: TColor.doctorWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "lib/core/assets/imgs/telegram.png",
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () async {
                    if (notifier.telegramUrl == null ||
                        notifier.telegramUrl!.isEmpty) return;
                    final Uri url = Uri.parse(notifier.telegramUrl!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    "Telegram",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: TColor.tamarama,
                        fontSize: 18,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                notifier.isConfiguredTelegram
                    ? Text(
                        "Published",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: TColor.slate,
                    fontWeight: FontWeight.w800
                  ),
                      )
                    : Text(
                        "Not Configured",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: TColor.poppySurprise,
                    fontWeight: FontWeight.w800
                  ),
                      ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () async {
                    if (notifier.isConfiguredTelegram) {
                      try {
                        await notifier.disconnect('telegram');
                        await notifier.getPublishedList();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Disconnected Telegram.'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } catch (e) {
                        if (e == 401) {
                          //TODO: reset & logout
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.authenticate,
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Disconnect failed: Unknown error.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      }
                      return;
                    }
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildTelegramConfigureDialog(
                              notifier.currentAssistant!.id!);
                        });
                  },
                  child: notifier.isConfiguredTelegram
                      ? Text(
                          "Disconnect",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: TColor.poppySurprise,
                      fontWeight: FontWeight.w800
                    ),
                        )
                      : Text(
                          "Publish",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: TColor.tamarama,
                      fontWeight: FontWeight.w800
                    ),
                        ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessengerConfigureCard(PublishNotifier notifier) {
    return Card(
      elevation: 5,
      color: TColor.doctorWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "lib/core/assets/imgs/messenger.png",
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () async {
                    if (notifier.messengerUrl == null ||
                        notifier.messengerUrl!.isEmpty) return;
                    final Uri url = Uri.parse(notifier.messengerUrl!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    "Messenger",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: TColor.tamarama,
                        fontSize: 18,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                notifier.isConfiguredMessenger
                    ? Text(
                        "Published",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w800,
                              color: TColor.tamarama,
                            ),
                      )
                    : Text(
                        "Not Configured",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: TColor.poppySurprise,
                          fontWeight: FontWeight.w800
                            ),
                      ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () async {
                    if (notifier.isConfiguredMessenger) {
                      try {
                        await notifier.disconnect('messenger');
                        await notifier.getPublishedList();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Disconnected Messenger.'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } catch (e) {
                        if (e == 401) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.authenticate,
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Disconnect failed: Unknown error.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      }
                      return;
                    }
                    //else
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildMessengerConfigureDialog(
                              notifier.currentAssistant!.id!);
                        });
                  },
                  child: notifier.isConfiguredMessenger
                      ? Text(
                          "Disconnect",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                        color: TColor.poppySurprise,
                      ),
                        )
                      : Text(
                          "Publish",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w800,
                      color: TColor.tamarama,
                    ),
                        ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
