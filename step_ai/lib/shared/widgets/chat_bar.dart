import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/chat/notifier/personal_assistant_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';

import '../../config/enum/task_status.dart';
import '../../features/chat/presentation/notifier/prompt_list_notifier.dart';
import '../../features/prompt/presentation/pages/prompt_bottom_sheet.dart';
import '../styles/colors.dart';

class ChatBar extends StatefulWidget {
  const ChatBar({super.key, required this.onSendMessage});
  final Function(String) onSendMessage;

  @override
  _ChatBarState createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _showIconSend = false;
  bool _isUploading = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late ChatBarNotifier _chatBarNotifier;
  late PromptListNotifier _listNotifier;
  late PersonalAssistantNotifier _personalAssistantNotifier;

  Timer? _debounce;


  @override
  void initState() {
    super.initState();
    _controller.addListener(onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.removeListener(onTextChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _pickMultipleImages() async {
    try {
      setState(() {
        _isUploading = true;
      });
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {

          _images = pickedFiles.map((file) => File(file.path)).toList();
        });
      }
    } catch (e) {
      print("Error picking images: $e");
      // Optionally show a user-friendly message
    } finally {
      setState(() {
        _isUploading = false; // Stop loading
      });
    }
  }

  //Event to display/hide the accessibility icons
  void onTextChanged() {
    final currentText = _controller.text;

    // Log current text for debugging
    //print(currentText);

    // If the text is empty, reset relevant states and return
    if (currentText.isEmpty) {
      _chatBarNotifier.setShowOverlay(false);
      setState(() {
        _showIconSend = false;
      });
      _debounce?.cancel(); // Cancel any pending debounce timer
      return;
    }

    // Determine if a response is loading
    final chatNotifier = Provider.of<ChatNotifier>(context, listen: false);
    final isLoadingResponse = chatNotifier.historyMessages.isNotEmpty &&
        chatNotifier.historyMessages.last.content == null;

    // Update the state of the send icon
    setState(() {
      _showIconSend = !isLoadingResponse && !currentText.startsWith('/');
    });

    // Handle command input if the text starts with "/"
    if (currentText.startsWith('/')) {
      _debounce?.cancel(); // Cancel any previous debounce
      _debounce = Timer(const Duration(milliseconds: 800), () async {
        _chatBarNotifier.setShowOverlay(true);
        final status = await _listNotifier.getPrompts(currentText);

        // Handle unauthorized status if detected
        if (status == TaskStatus.UNAUTHORIZED) {
          _chatBarNotifier.setLogout(true);
        }
      });
    } else {
      // If not a command, hide the overlay
      _chatBarNotifier.setShowOverlay(false);
    }
  }

  Future<List<String>> _convertImages() async {
    List<String> imageFiles = [];
    for (var image in _images) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final mimeType =
          'image/${image.uri.toString().split('.').last}'; // e.g., "image/png"
      final base64ImageWithPrefix = 'data:$mimeType;base64,$base64Image';
      imageFiles.add(base64ImageWithPrefix);
    }

    return imageFiles;
  }

  @override
  Widget build(BuildContext context) {
    _chatBarNotifier = Provider.of<ChatBarNotifier>(context);
    _listNotifier = Provider.of<PromptListNotifier>(context);
    _personalAssistantNotifier = Provider.of<PersonalAssistantNotifier>(context);

    if (_chatBarNotifier.triggeredPrompt) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = '';
        _controller.text = _chatBarNotifier.content;
        _chatBarNotifier.cancelPrompt();
      });
    }
    return Focus(
      focusNode: _focusNode,
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus(); // Focus when tapped
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: _focusNode.hasFocus
                  ? TColor.doctorWhite
                  : TColor.northEastSnow.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color:
                    _focusNode.hasFocus ? TColor.tamarama : Colors.transparent,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (_isUploading)
                          LoadingAnimationWidget.twistingDots(
                            leftDotColor: TColor.tamarama,
                            rightDotColor: TColor.daJuice,
                            size: 30,
                          ),
                        if (_images.isNotEmpty)
                          Wrap(
                            direction: Axis
                                .horizontal, // Ensures wrap aligns items horizontally
                            spacing: 10, // Space between images
                            runSpacing: 10, // Space between rows
                            children: _images.map((image) {
                              return Stack(
                                children: [
                                  // Image container
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(width: 0),
                                      image: DecorationImage(
                                        image: FileImage(image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Close button
                                  Positioned(
                                    top: 3,
                                    right: 3,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(50),
                                        focusColor:
                                        TColor.northEastSnow.withOpacity(0.5),
                                        onTap: () => onRemove(image),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            color: TColor.northEastSnow
                                                .withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          width: 20,
                                          height: 20,
                                          child: Icon(
                                            Icons.close,
                                            color: TColor.petRock,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                //TextField to chat
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 3.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: TextField(
                        autocorrect: false,
                        cursorColor: TColor.squidInk,
                        controller: _controller,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              color: TColor.squidInk,
                            ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          hintText: 'Enter your question, or / to use a prompt',
                          hintStyle:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 15,
                                    color: TColor.petRock.withOpacity(0.5),
                                  ),
                          border: InputBorder.none,
                        ),

                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        _chatBarNotifier.setShowOverlay(false);
                        showModalBottomSheet(
                          backgroundColor: TColor.doctorWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          context: context,
                          builder: (_) {
                            return ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              child: PromptBottomSheet(
                                returnPrompt: (value) async {
                                  _controller.clear();
                                  try {
                                    if (_personalAssistantNotifier.isPersonal) {
                                      await Provider.of<ChatNotifier>(
                                          context, listen: false
                                      ).sendMessageForPersonalBot(value);
                                    }
                                    else {
                                      await Provider.of<ChatNotifier>(
                                          context, listen: false
                                      ).sendMessage(value);
                                    }
                                  } catch (e) {
                                    //e is 401 and return to login screen
                                    // print(
                                    //     "e is 401 and return to login screen");
                                    // print(e);

                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      Routes.authenticate,
                                          (Route<dynamic> route) => false,
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        FontAwesomeIcons.wandMagicSparkles,
                        color: TColor.petRock,
                        size: 20,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildPromptButton(context),
                          _buildImageUploadButton(context),
                        ],
                      ),
                    _showIconSend
                        ? IconButton(
                            padding: const EdgeInsets.all(2),
                            icon: Icon(
                              Icons.send,
                              size: 20,
                              color: TColor.tamarama,
                            ),
                            onPressed: () async {
                              // Hide keyboard
                              FocusScope.of(context).unfocus();
                              try {
                                String message = _controller.text;
                                _controller.clear();
                                _chatBarNotifier.setShowOverlay(false);
                                if (!_personalAssistantNotifier.isPersonal) {
                                  await Provider.of<ChatNotifier>(context,
                                      listen: false)
                                      .sendMessage(message);
                                } else {
                                  await Provider.of<ChatNotifier>(
                                      context, listen: false
                                  ).sendMessageForPersonalBot(message);
                                }


                              } catch (e) {
                                //e is 401 and return to login screen

                                // print(e);
                                if (context.mounted &&
                                    e is TaskStatus &&
                                    e == TaskStatus.UNAUTHORIZED) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    Routes.authenticate,
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              }
                              setState(() {
                                //print("set state ABCDDDDDE");
                                _showIconSend = true;
                              });
                              // _controller.clear();
                            })
                        : IconButton(
                            padding: const EdgeInsets.all(2),
                            icon: Icon(
                              Icons.send,
                              size: 20,
                              color: TColor.petRock
                            ),
                              onPressed: () {},
                            ),
                    ],
                  )]
              )],
            ),
          ),
        ),
      ),
    ));
  }

  IconButton _buildImageUploadButton(BuildContext context) {
    return IconButton(
      onPressed: _pickMultipleImages,
      icon: Icon(
        FontAwesomeIcons.images,
        color: TColor.petRock.withOpacity(0.7),
        size: 20,
      ),
    );
  }

  IconButton _buildPromptButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        _chatBarNotifier.setShowOverlay(false);
        showModalBottomSheet(
          useSafeArea: true,
          isScrollControlled: true,
          useRootNavigator: true,
          backgroundColor: TColor.doctorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          context: context,
          builder: (_) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: PromptBottomSheet(
                returnPrompt: (value) async {
                  FocusScope.of(context).unfocus();
                  _controller.clear();
                  try {
                    await Provider.of<ChatNotifier>(context, listen: false)
                        .sendMessage(value);
                  } catch (e) {
                    //e is 401 and return to login screen
                    // print("e is 401 and return to login screen");
                    // print(e);
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.authenticate,
                        (Route<dynamic> route) => false,
                      );
                    }
                  }
                },
              ),
            );
          },
        );
      },
      icon: Icon(
        FontAwesomeIcons.wandMagicSparkles,
        color: TColor.petRock.withOpacity(0.7),
        size: 20,
      ),
    );
  }

  onRemove(File image) {
    setState(() {
      _images.remove(image);
    });
  }
}
