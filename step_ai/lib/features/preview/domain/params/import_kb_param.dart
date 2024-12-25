import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge.dart';

class ImportKbParam{
  final Knowledge kb;
  final Assistant bot;

  ImportKbParam(this.kb, this.bot);
}