class ThreadChatParam{
  final String message;
  final String openAiThreadId;
  final String assistantId;
  final String? additionalInstruction;

  ThreadChatParam({required this.message, required this.openAiThreadId,
    required this.assistantId, required this.additionalInstruction});
}