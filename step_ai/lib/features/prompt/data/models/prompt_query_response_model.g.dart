// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_query_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PromptQueryResponseImpl _$$PromptQueryResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PromptQueryResponseImpl(
      hasNext: json['hasNext'] as bool,
      items: (json['items'] as List<dynamic>)
          .map((e) => PromptModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$$PromptQueryResponseImplToJson(
        _$PromptQueryResponseImpl instance) =>
    <String, dynamic>{
      'hasNext': instance.hasNext,
      'items': instance.items,
      'limit': instance.limit,
      'offset': instance.offset,
      'total': instance.total,
    };
