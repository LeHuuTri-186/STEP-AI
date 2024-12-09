import 'package:step_ai/features/units_in_knowledge/domain/entity/metadata_file.dart';
import 'package:step_ai/features/units_in_knowledge/domain/entity/metadata_slack.dart';
import 'package:step_ai/features/units_in_knowledge/domain/entity/metadata_web_url.dart';

abstract class MetadataInUnit {
  final String type;
  
  const MetadataInUnit({required this.type});

  factory MetadataInUnit.fromJson(Map<String, dynamic> json, String type) {
    switch (type) {
      case 'web':
        return MetadataWebUrl.fromJson(json);
      case 'local_file':
        return MetadataFile.fromJson(json);
      case 'slack':
        return MetadataSlack.fromJson(json);
      default:
        throw Exception('Unknown metadata type: $type');
    }
  }
  String getTypeName();
  String getIconPath();
}
