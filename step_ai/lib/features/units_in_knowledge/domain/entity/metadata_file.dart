import 'package:step_ai/features/units_in_knowledge/domain/entity/metadata_in_unit.dart';

class MetadataFile extends MetadataInUnit {
  final String name;
  final String mimeType;

  const MetadataFile({
    required this.name,
    required this.mimeType,
  }) : super(type: 'local_file');

  // @override
  // Map<String, dynamic> toJson() => {
  //   'type': type,
  //   'name': name,
  //   'mimetype': mimeType,
  // };

  factory MetadataFile.fromJson(Map<String, dynamic> json) {
    return MetadataFile(
      name: json['name'] as String,
      mimeType: json['mimetype'] as String,
    );
  }
  
  @override
  String getTypeName() {
    // TODO: implement getTypeName
    return "Local file";
  }
  
  @override
  String getIconPath() {
    // TODO: implement getIconPath
    return 'lib/core/assets/source_unit_images/file.jpg';
  }
}
