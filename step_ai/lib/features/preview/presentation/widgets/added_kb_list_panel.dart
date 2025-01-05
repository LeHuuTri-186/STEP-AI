import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/preview/presentation/notifier/preview_chat_notifier.dart';
import 'package:step_ai/features/preview/presentation/widgets/added_kb_list_view.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';

import '../../../../config/routes/routes.dart';
import '../../../../shared/styles/colors.dart';


class AddedKbPanel extends StatefulWidget {
  const AddedKbPanel({super.key});

  @override
  State<AddedKbPanel> createState() => _AddedKbPanelState();
}

class _AddedKbPanelState extends State<AddedKbPanel> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // context.read<PrivateViewState>().fetchPrompts();
      });
    } catch (e) {
      print("e is 401 and return to login screen");
      print(e);
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.authenticate,
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Consumer<PreviewChatNotifier>(builder: (context, preview, child){
      if (preview.isLoading) {
        return Center(
          child: _twistingDotsLoadIndicator(),
        );
      } else {
        return Column(
        children: [
          VSpacing.sm,
          VSpacing.md,
          _buildListView(),
          VSpacing.md,
        ],
      );
      }
    });
  }

  Widget _buildListView() {
    return Consumer<PreviewChatNotifier>(
      builder: (context, preview, child) {
        return AddedKbListView(
          scrollController: _scrollController,
          kbs: preview.kbList,
          deleteIndex: (int index) {
            preview.removeKbInList(preview.kbList[index]); // Pass the correct index instead of null
          },
        );
      },
    );
  }

  Widget _twistingDotsLoadIndicator() {
    return LoadingAnimationWidget.twistingDots(
      size: 50,
      leftDotColor: TColor.tamarama,
      rightDotColor: TColor.daJuice,
    );
  }


  void _onScroll() {
    final preview = Provider.of<PreviewChatNotifier>(context, listen: false);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !preview.isLoadingMore &&
        preview.hasMore) {

      preview.getKbInBot();
    }
  }
}
