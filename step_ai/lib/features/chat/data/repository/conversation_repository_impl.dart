import 'package:step_ai/core/data/model/conversation_model.dart';
import 'package:step_ai/core/data/model/detailed_messages_model.dart';
import 'package:step_ai/core/data/model/message_model.dart';
import 'package:step_ai/core/data/model/usage_token_model.dart';
import 'package:step_ai/features/chat/domain/params/send_message_param.dart';
import 'package:step_ai/features/chat/domain/repository/conversation_repository.dart';

import '../network/api_client_chat.dart';

class ConversationRepositoryImpl extends ConversationRepository {
  final ApiClientChat _apiClientChat;
  ConversationRepositoryImpl(this._apiClientChat);

  @override
  Future<MessageModel> sendMessage(SendMessageParam sendMessageParam) async {
    final Map<String, dynamic> body = {
      "content": sendMessageParam
          .historyMessages[sendMessageParam.historyMessages.length - 2].content,
      "metadata": null,
      "assistant": sendMessageParam
          .historyMessages[sendMessageParam.historyMessages.length - 2]
          .assistant
          .toJson(),
      "files": null,
    };
    //Add metadata if have history message
    final historyMessages = sendMessageParam.historyMessages;
    if (sendMessageParam.conversationId != null) {
      body["metadata"] = {
        "conversation": {
          "id": sendMessageParam.conversationId,
          "messages": historyMessages
              .take(historyMessages.length - 2)
              .map((message) => message.toJson())
              .toList(),
        }
      };
    }

    final response = await _apiClientChat
        .sendMessage("/api/v1/ai-chat/messages", data: body);
    // print("Response -----------------");
    // print(response);
    // print("\n\n\n\n\n\n\n\n\n");
    return MessageModel.fromJson(response.data);
  }

  @override
  Future<ConversationModel> getHistoryConversationList(int limit) async {
    final Map<String, dynamic> queryParams = {
      "limit": limit,
      "assistantId": "gpt-4o-mini",
      "assistantModel": "dify"
    };

    final response = await _apiClientChat.getHistoryList(
        "/api/v1/ai-chat/conversations",
        queryParams: queryParams);
    //print(response);
    return ConversationModel.fromJson(response.data);
  }

  @override
  Future<UsageTokenModel> getUsageToken() async {
    final response = await _apiClientChat.getUsageToken("/api/v1/tokens/usage");
    //print(response);
    return UsageTokenModel.fromJson(response.data);
  }

  @override
  Future<DetailedMessagesModel> getMessagesByConversationId(
      String idConversation) async {
    final Map<String, dynamic> queryParams = {
      "limit": 100,
      "assistantId": "gpt-4o-mini",
      "assistantModel": "dify"
    };

    final response = await _apiClientChat.getMessagesByConversationId(
        "/api/v1/ai-chat/conversations/$idConversation/messages",
        queryParams: queryParams);
    //print(response);
    return DetailedMessagesModel.fromJson(response.data);
  }
}
