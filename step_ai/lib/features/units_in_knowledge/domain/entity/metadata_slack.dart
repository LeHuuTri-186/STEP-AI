import 'package:step_ai/config/constants.dart';
import 'package:step_ai/features/units_in_knowledge/domain/entity/metadata_in_unit.dart';

class MetadataSlack extends MetadataInUnit {
  final String slackBotToken;
  final String slackWorkspace;

  const MetadataSlack({
    required this.slackBotToken,
    required this.slackWorkspace,
  }) : super(type: 'slack');

  // @override
  // Map<String, dynamic> toJson() => {
  //   'type': type,
  //   'name': name,
  //   'mimetype': mimeType,
  // };

  factory MetadataSlack.fromJson(Map<String, dynamic> json) {
    return MetadataSlack(
      slackBotToken: json['slack_bot_token'] as String,
      slackWorkspace: json['slack_workspace'] as String,
    );
  }

  @override
  String getTypeName() {
    return "Slack";
  }
  
  @override
  String getIconPath() {
    return Constant.slackImagePath;
  }
}
