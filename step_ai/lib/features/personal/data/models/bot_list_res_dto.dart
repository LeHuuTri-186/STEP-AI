import 'package:step_ai/features/personal/data/models/bot_res_dto.dart';
import 'package:step_ai/features/personal/data/models/page_metadata.dart';

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