import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/edit_knowledge_dialog_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/shared/styles/colors.dart';

class EditKnowledgeDialog extends StatefulWidget {
  const EditKnowledgeDialog({super.key});

  @override
  State<EditKnowledgeDialog> createState() => _EditKnowledgeDialogState();
}

class _EditKnowledgeDialogState extends State<EditKnowledgeDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late KnowledgeNotifier _knowledgeNotifier;
  late EditKnowledgeDialogNotifier _editKnowledgeDialogNotifier;
  late UnitNotifier _unitNotifier;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _unitNotifier = Provider.of<UnitNotifier>(context, listen: false);
    _nameController.text = _unitNotifier.currentKnowledge!.knowledgeName;
    _descriptionController.text = _unitNotifier.currentKnowledge!.description;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void findAndUpdateCurrentKnowledge() {
    //to update name when edit knowledge
    _knowledgeNotifier.knowledgeList!.knowledgeList.forEach((knowledge) {
      if (knowledge.id == _unitNotifier.currentKnowledge!.id) {
        _unitNotifier.updateCurrentKnowledge(knowledge);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _knowledgeNotifier = Provider.of<KnowledgeNotifier>(context, listen: false);
    _editKnowledgeDialogNotifier =
        Provider.of<EditKnowledgeDialogNotifier>(context, listen: true);
    _unitNotifier = Provider.of<UnitNotifier>(context, listen: false);
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Edit Knowledge',
        textAlign: TextAlign.center,
        style: TextStyle(color: TColor.tamarama),
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'Name',
                  counterText: '${_nameController.text.length}/50',
                  errorText: _editKnowledgeDialogNotifier
                          .errorDisplayWhenNameIsUsed.isEmpty
                      ? null
                      : _editKnowledgeDialogNotifier.errorDisplayWhenNameIsUsed,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) {
                  _editKnowledgeDialogNotifier.updateNumberTextInTextFiled();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLength: 2000,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  counterText: '${_descriptionController.text.length}/2000',
                ),
                validator: (value) {
                  return null;
                },
                onChanged: (value) {
                  _editKnowledgeDialogNotifier.updateNumberTextInTextFiled();
                },
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            onPressed: () {
              _nameController.clear();
              _descriptionController.clear();
              _editKnowledgeDialogNotifier.setErrorDisplayWhenNameIsUsed("");
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
        ),

        //Edit button
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            onPressed:
                _editKnowledgeDialogNotifier.isLoadingWhenEditNewKnowledge
                    ? null
                    : () async {
                        //Hide keyboard
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          // Form is valid, proceed with save
                          try {
                            //show Indicator
                            _editKnowledgeDialogNotifier
                                .setIsLoadingWhenEditKnowledge(true);
                            //update
                            await _knowledgeNotifier.updateKnowledge(
                                _unitNotifier.currentKnowledge!.id,
                                _nameController.text,
                                _descriptionController.text);

                            await _knowledgeNotifier.getKnowledgeList();
                            findAndUpdateCurrentKnowledge();

                            //hide Indicator
                            _editKnowledgeDialogNotifier
                                .setIsLoadingWhenEditKnowledge(false);
                            _nameController.clear();
                            _descriptionController.clear();
                            Navigator.pop(context);
                          } catch (e) {
                            _editKnowledgeDialogNotifier
                                .setIsLoadingWhenEditKnowledge(false);
                            _editKnowledgeDialogNotifier
                                .setErrorDisplayWhenNameIsUsed(e.toString());
                          }
                        }
                      },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _editKnowledgeDialogNotifier.isLoadingWhenEditNewKnowledge
                      ? Colors.grey
                      : TColor.tamarama,
              minimumSize: const Size(90, 42),
            ),
            child: _editKnowledgeDialogNotifier.isLoadingWhenEditNewKnowledge
                ? Stack(alignment: Alignment.center, children: [
                    const Text("Loading"),
                    Positioned(
                      child: CupertinoActivityIndicator(
                        radius: 10,
                        color: TColor.tamarama,
                      ),
                    ),
                  ])
                : const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }
}
