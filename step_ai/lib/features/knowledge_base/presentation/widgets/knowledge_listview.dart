// import 'package:flutter/material.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
// import 'package:step_ai/features/knowledge_base/presentation/widgets/knowledge_item.dart';
// import 'package:step_ai/shared/widgets/no_data_panel.dart';
// import 'package:step_ai/shared/styles/colors.dart';

// class KnowledgeListview extends StatefulWidget {
//   KnowledgeListview({super.key});

//   @override
//   State<KnowledgeListview> createState() => _KnowledgeListviewState();
// }

// class _KnowledgeListviewState extends State<KnowledgeListview> {
//   late KnowledgeNotifier _knowledgeNotifier;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _knowledgeNotifier =
//           Provider.of<KnowledgeNotifier>(context, listen: false);
//           knowledgeNotifier.reset();
//       if (!_knowledgeNotifier.isLoadingKnowledgeList) {
//         _knowledgeNotifier.getKnowledgeList();
//       }
//     });
//     _scrollController.addListener(_scrollListener);
//   }

//   void _scrollListener() {
//     print("ABCD================================>LKL");
//     if (_scrollController.position.pixels ==
//             _scrollController.position.maxScrollExtent &&
//         !_knowledgeNotifier.isLoadingKnowledgeList &&
//         _knowledgeNotifier.hasNext) {
//       _knowledgeNotifier.getKnowledgeList();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _knowledgeNotifier = Provider.of<KnowledgeNotifier>(context);
//     if (_knowledgeNotifier.isLoadingKnowledgeList) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(3.0),
//           child: LoadingAnimationWidget.twistingDots(
//             size: 50,
//             leftDotColor: TColor.tamarama,
//             rightDotColor: TColor.daJuice,
//           ),
//         ),
//       );
//     }

//     if (_knowledgeNotifier.errorString.isNotEmpty ||
//         _knowledgeNotifier.knowledgeList == null) {
//       return const Center(child: Text("Have error. Try again later"));
//     }
//     if (_knowledgeNotifier.knowledgeList!.knowledgeList.isEmpty) {
//       return const NoDataPannel(
//         contentNoData: "Create a knowledge base to store your data",
//       );
//     }
//     print(
//         "ABCD================================> ${_knowledgeNotifier.hasNext}");
//     return ListView.builder(
//       controller: _scrollController,
//       itemCount: _knowledgeNotifier.knowledgeList!.knowledgeList.length +
//           (_knowledgeNotifier.hasNext ? 1 : 0),
//       itemBuilder: (context, index) {
//         if (index == _knowledgeNotifier.knowledgeList!.knowledgeList.length) {
//           return const Center(
//             child: Padding(
//               padding: EdgeInsets.all(8.0),
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//         final knowledge =
//             _knowledgeNotifier.knowledgeList!.knowledgeList[index];
//         if (knowledge.isDisplay == false) {
//           return const SizedBox.shrink();
//         }
//         return KnowledgeItem(knowledge: knowledge);
//       },
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/knowledge_base/presentation/widgets/knowledge_item.dart';
import 'package:step_ai/shared/widgets/no_data_panel.dart';
import 'package:step_ai/shared/styles/colors.dart';

class KnowledgeListview extends StatefulWidget {
  KnowledgeListview({super.key});

  @override
  State<KnowledgeListview> createState() => _KnowledgeListviewState();
}

class _KnowledgeListviewState extends State<KnowledgeListview> {
  late KnowledgeNotifier _knowledgeNotifier;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _knowledgeNotifier =
          Provider.of<KnowledgeNotifier>(context, listen: false);
      if (!_knowledgeNotifier.isLoadingKnowledgeList) {
        _knowledgeNotifier.getKnowledgeList();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    _knowledgeNotifier = Provider.of<KnowledgeNotifier>(context);
    if (_knowledgeNotifier.isLoadingKnowledgeList) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: LoadingAnimationWidget.twistingDots(
            size: 50,
            leftDotColor: TColor.tamarama,
            rightDotColor: TColor.daJuice,
          ),
        ),
      );
    }

    if (_knowledgeNotifier.errorString.isNotEmpty ||
        _knowledgeNotifier.knowledgeList == null) {
      return const Center(child: Text("Have error. Try again later"));
    }
    if (_knowledgeNotifier.knowledgeList!.knowledgeList.isEmpty) {
      return const NoDataPannel(
        contentNoData: "Create a knowledge base to store your data",
      );
    }
    print(
        "ABCD================================> ${_knowledgeNotifier.hasNext}");
    return ListView.builder(
      itemCount: _knowledgeNotifier.knowledgeList!.knowledgeList.length,
      itemBuilder: (context, index) {
        final knowledge =
            _knowledgeNotifier.knowledgeList!.knowledgeList[index];
        if (knowledge.isDisplay == false) {
          return const SizedBox.shrink();
        }
        return KnowledgeItem(knowledge: knowledge);
      },
    );
  }
}
