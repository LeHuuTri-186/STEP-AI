import 'package:step_ai/features/units_in_knowledge/domain/entity/metadata_in_unit.dart';

class MetadataWebUrl extends MetadataInUnit {
  final String webUrl;

  const MetadataWebUrl({
    required this.webUrl,
  }) : super(type: 'web');

  // @override
  // Map<String, dynamic> toJson() => {
  //   'type': type,
  //   'web_url': webUrl,
  // };

  factory MetadataWebUrl.fromJson(Map<String, dynamic> json) {
    return MetadataWebUrl(
      webUrl: json['web_url'] as String,
    );
  }
  
  @override
  String getTypeName() {
    return "Website";
  }
    @override
  String getIconPath() {
    return "lib/core/assets/source_unit_images/web.png";
  }
}
