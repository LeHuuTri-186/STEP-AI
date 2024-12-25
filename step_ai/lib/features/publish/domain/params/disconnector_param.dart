import 'package:step_ai/features/chat/domain/entity/assistant.dart';

class DisconnectorParam{
  final String type;
  final Assistant assistant;

  DisconnectorParam({required this.type, required this.assistant});
}