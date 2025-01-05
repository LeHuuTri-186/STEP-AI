
import 'package:step_ai/features/playground/data/models/page_metadata.dart';

import 'bot_res_dto.dart';

class BotListResDto{
  List<BotResDto> data;
  PageMetadata? meta;

  BotListResDto({
    required this.data,
    required this.meta,
  });

  factory BotListResDto.fromJson(Map<String, dynamic> json) {
    return BotListResDto(
      data: (json['data'] as List)
          .map((item) => BotResDto.fromJson(item))
          .toList(),
      meta: PageMetadata.fromJson(json['meta']),
    );
  }
}