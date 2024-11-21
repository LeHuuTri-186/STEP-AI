import 'package:freezed_annotation/freezed_annotation.dart';
import 'prompt_model.dart';

import 'dart:convert';

part 'prompt_query_response_model.freezed.dart';
part 'prompt_query_response_model.g.dart';

@freezed
class PromptQueryResponse with _$PromptQueryResponse {
  const factory PromptQueryResponse({
    @JsonKey(name: "hasNext")
    required bool hasNext,
    @JsonKey(name: "items")
    required List<PromptModel> items,
    @JsonKey(name: "limit")
    required int limit,
    @JsonKey(name: "offset")
    required int offset,
    @JsonKey(name: "total")
    required int total,
  }) = _PromptQueryResponse;

  factory PromptQueryResponse.fromJson(Map<String, dynamic> json) => _$PromptQueryResponseFromJson(json);
}

