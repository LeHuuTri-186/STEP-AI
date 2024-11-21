// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PromptModelImpl _$$PromptModelImplFromJson(Map<String, dynamic> json) =>
    _$PromptModelImpl(
      id: json['_id'] as String? ?? '',
      category: json['category'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool,
      isPublic: json['isPublic'] as bool,
      language: json['language'] as String? ?? '',
      title: json['title'] as String,
      updatedAt: json['updatedAt'] as String? ?? '',
      userId: json['userId'] as String?,
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$$PromptModelImplToJson(_$PromptModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'category': instance.category,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'description': instance.description,
      'isFavorite': instance.isFavorite,
      'isPublic': instance.isPublic,
      'language': instance.language,
      'title': instance.title,
      'updatedAt': instance.updatedAt,
      'userId': instance.userId,
      'userName': instance.userName,
    };
