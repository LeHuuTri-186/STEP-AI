import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/enum/request_response.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/chat/notifier/personal_assistant_notifier.dart';

import 'package:step_ai/features/personal/data/models/bot_res_dto.dart';
import 'package:step_ai/features/personal/presentation/notifier/bot_list_notifier.dart';
import 'package:step_ai/features/personal/presentation/widgets/update_bot_dialog.dart';
import 'package:step_ai/features/preview/presentation/pages/preview_chat_page.dart';
import 'bot_tile.dart';

class BotListView extends StatelessWidget {
  const BotListView({
    super.key,
    required ScrollController scrollController,
    required this.bots,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<BotResDto> bots;
  // final Function(int) toggleFavorite;
  // final Function(String) returnPrompt;

  @override
  Widget build(BuildContext context) {
    final BotListNotifier botListNotifier = context.watch<BotListNotifier>();
    final PersonalAssistantNotifier personalAssistantNotifier
      = Provider.of<PersonalAssistantNotifier>(context);
    return ListView.separated(
      controller: _scrollController,
      primary: false,
      shrinkWrap: true,
      itemCount: bots.length,
      itemBuilder: (_, int index) {
        return BotTile(
          bot: bots[index],
          index: index,
          onTap: () {
            //Load assistant chat view.
            Navigator.of(context).pushNamed(Routes.previewChat);
          },
          onToggleDelete: () async{
            RequestResponse res = await botListNotifier.deleteBot(bots[index]);
            if (res == RequestResponse.unauthorized) {
              //Logout

            }
            if (res == RequestResponse.success) {
              RequestResponse innerRes =
                  await botListNotifier.getBots(null);
              if (innerRes == RequestResponse.unauthorized) {
                //logout

              }
            }
            },
          onToggleUpdate: () {
            //Print
            showDialog(
                context: context,
                builder: (context) =>
                    BotUpdateDialog(
                      onUpdateBot: (BotResDto bot) async{

                        RequestResponse res = await botListNotifier
                            .updateBot(bot);
                        print(res);
                        if (res == RequestResponse.success){

                          RequestResponse innerResponse =
                          await botListNotifier.getBots(null);

                          if (innerResponse == RequestResponse.unauthorized) {
                            //Logout here.
                          }
                        }
                        if (res == RequestResponse.unauthorized) {
                          //Logout here
                        }
                      },
                      oldBot: bots[index],
                    )
            );
          },
          onToggleAddBot: () {
            personalAssistantNotifier.addAssistant(
                Assistant(
                  id: bots[index].id,
                  model: 'personal',
                  name: bots[index].assistantName,
                )
            );
          },
        );
      },
      separatorBuilder: (_, int index) {
        return const Divider();
      },
    );
  }
}
