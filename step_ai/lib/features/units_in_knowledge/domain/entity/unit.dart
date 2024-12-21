import 'package:step_ai/features/units_in_knowledge/domain/entity/metadata_in_unit.dart';

class Unit {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;
  final DateTime deletedAt;
  final String id;
  final String name;
  final String type;
  final int size;
  final bool status;
  final String userId;
  final String knowledgeId;
  final List<String> openAiFileIds;
  bool isDisplay = true;
  final MetadataInUnit metadata;

  Unit({
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deletedAt,
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.status,
    required this.userId,
    required this.knowledgeId,
    required this.openAiFileIds,
    required this.metadata,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: json['createdBy'] ?? "",
      updatedBy: json['updatedBy'] ?? "",
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : DateTime.now(),
      id: json['id'],
      name: json['name'],
      type: json['type'],
      size: json['size'],
      status: json['status'],
      userId: json['userId'],
      knowledgeId: json['knowledgeId'],
      openAiFileIds: List<String>.from(json['openAiFileIds']),
      metadata: MetadataInUnit.fromJson(json['metadata'], json['type']),
    );
  }

  // Map<String, dynamic> toJson() => {
  //   'created_at': createdAt.toIso8601String(),
  //   'updated_at': updatedAt.toIso8601String(),
  //   'created_by': createdBy,
  //   'updated_by': updatedBy,
  //   'deleted_at': deletedAt?.toIso8601String(),
  //   'id': id,
  //   'name': name,
  //   'type': type,
  //   'size': size,
  //   'status': status,
  //   'user_id': userId,
  //   'knowledge_id': knowledgeId,
  //   'open_ai_file_ids': openAiFileIds,
  //   'metadata': metadata.toJson(),
  // };
}
