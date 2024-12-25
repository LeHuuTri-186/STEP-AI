import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/preview/domain/entity/kb_in_bot.dart';

class RemoveKbParam{
  final KbInBot kb;
  final Assistant bot;

  RemoveKbParam(this.kb, this.bot);
}