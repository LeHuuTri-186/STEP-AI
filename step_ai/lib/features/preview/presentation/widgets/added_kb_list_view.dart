import 'package:flutter/material.dart';
import 'package:step_ai/features/preview/domain/entity/kb_in_bot.dart';
import 'package:step_ai/features/preview/presentation/widgets/kb_tile.dart';
import 'package:step_ai/features/preview/presentation/widgets/remove_kb_dialog.dart';
import '../../../../config/routes/routes.dart';

class AddedKbListView extends StatelessWidget {
  const AddedKbListView({
    super.key,
    required ScrollController scrollController,
    required this.kbs,
    required this.deleteIndex,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<KbInBot> kbs;
  final Function(int) deleteIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        controller: _scrollController,
        primary: false,
        shrinkWrap: true,
        itemCount: kbs.length,
        itemBuilder: (_, int index) {
          return KbTile(kb: kbs[index], index: index,
            onDelete: () {
              try {
                showKbListDialog(
                    context: context, index: index, deleteIndex: deleteIndex);
              }
              catch (e) {
                print("e is 401 and return to login screen");
                print(e);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.authenticate,
                      (Route<dynamic> route) => false,
                );
              }
            },);
        },
        separatorBuilder: (_, int index) {
          return const Divider();
        },
      ),
    );
  }


  void showKbListDialog(
      {required BuildContext context,
        required int index,
        required Function(int) deleteIndex}) {
    showDialog(
        context: context,
        builder: (context) => RemoveKbDialog(
          deleteIndex: deleteIndex,
          index: index,
        )
    );
  }
}

