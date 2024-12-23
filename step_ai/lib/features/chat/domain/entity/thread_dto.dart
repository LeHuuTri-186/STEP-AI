///ThreadResDto
class ThreadDto {
  String assistantId;
  DateTime createdAt;
  String? createdBy;
  String id;
  String openAiThreadId;
  String threadName;
  DateTime? updatedAt;
  String? updatedBy;

  ThreadDto({
    required this.assistantId,
    required this.createdAt,
    this.createdBy,
    required this.id,
    required this.openAiThreadId,
    required this.threadName,
    this.updatedAt,
    this.updatedBy,
  });
  factory ThreadDto.fromJson(Map<String, dynamic> json) {
    return ThreadDto(
      assistantId: json['assistantId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String?,
      id: json['id'] as String,
      openAiThreadId: json['openAiThreadId'] as String,
      threadName: json['threadName'] as String,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      updatedBy: json['updatedBy'] as String?,
    );
  }
}
