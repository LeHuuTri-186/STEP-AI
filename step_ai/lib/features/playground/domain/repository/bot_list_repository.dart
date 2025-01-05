

import '../../data/models/bot_list_res_dto.dart';
import '../../data/models/bot_model.dart';
import '../../data/models/bot_res_dto.dart';

abstract class BotListRepository{
  Future<BotListResDto?> getBotList(String? query);
  Future<int>createBot(BotModel bot);
  Future<int>deleteBot(BotResDto bot);
  Future<int>updateBot(BotResDto bot);
}