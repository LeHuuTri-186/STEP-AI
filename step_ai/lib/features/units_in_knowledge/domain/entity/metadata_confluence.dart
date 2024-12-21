import 'package:step_ai/config/constants.dart';
import 'package:step_ai/features/units_in_knowledge/domain/entity/metadata_in_unit.dart';

class MetadataConfluence extends MetadataInUnit {
  final String wikiPageUrl;
  final String confluenceUserName;
  final String confluenceAccessToken;

  const MetadataConfluence({
    required this.wikiPageUrl,
    required this.confluenceUserName,
    required this.confluenceAccessToken,
  }) : super(type: 'confluence');

  // @override
  // Map<String, dynamic> toJson() => {
  //   'type': type,
  //   'web_url': webUrl,
  // };

  factory MetadataConfluence.fromJson(Map<String, dynamic> json) {
    return MetadataConfluence(
      wikiPageUrl: json['wiki_page_url'],
      confluenceUserName: json['confluence_username'],
      confluenceAccessToken: json['confluence_access_token'],
    );
  }
  
  @override
  String getTypeName() {
    return "Confluence";
  }
    @override
  String getIconPath() {
    return Constant.confluenceImagePath;
  }
}
