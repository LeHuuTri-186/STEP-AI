import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/knowledge_base/notifier/add_knowledge_dialog_notifier.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';

class AddKnowledgeDialog extends StatefulWidget {
  const AddKnowledgeDialog({super.key});

  @override
  State<AddKnowledgeDialog> createState() => _AddKnowledgeDialogState();
}

class _AddKnowledgeDialogState extends State<AddKnowledgeDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late KnowledgeNotifier _knowledgeNotifier;
  late AddKnowledgeDialogNotifier _addKnowledgeDialogNotifier;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _knowledgeNotifier = Provider.of<KnowledgeNotifier>(context, listen: false);
    _addKnowledgeDialogNotifier =
        Provider.of<AddKnowledgeDialogNotifier>(context, listen: true);
    return AlertDialog(
      title: const Text('Create Knowledge'),
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
                  errorText: _addKnowledgeDialogNotifier
                          .errorDisplayWhenNameIsUsed.isEmpty
                      ? null
                      : _addKnowledgeDialogNotifier.errorDisplayWhenNameIsUsed,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) {
                  _addKnowledgeDialogNotifier.updateNumberTextInTextFiled();
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
                  _addKnowledgeDialogNotifier.updateNumberTextInTextFiled();
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _nameController.clear();
            _descriptionController.clear();
            _addKnowledgeDialogNotifier.setErrorDisplayWhenNameIsUsed("");
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _addKnowledgeDialogNotifier.isLoadingWhenCreateNewKnowledge
              ? null
              : () async {
                  //Hide keyboard
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, proceed with save
                    try {
                      //show Indicator
                      _addKnowledgeDialogNotifier
                          .setIsLoadingWhenCreateNewKnowledge(true);
                      await _knowledgeNotifier.addNewKnowledge(
                          _nameController.text, _descriptionController.text);
                      _nameController.clear();
                      _descriptionController.clear();

                      //hide Indicator
                      _addKnowledgeDialogNotifier
                          .setIsLoadingWhenCreateNewKnowledge(false);
                      Navigator.pop(context);
                      await _knowledgeNotifier.getKnowledgeList();
                    } catch (e) {
                      _addKnowledgeDialogNotifier
                          .setIsLoadingWhenCreateNewKnowledge(false);
                      _addKnowledgeDialogNotifier
                          .setErrorDisplayWhenNameIsUsed(e.toString());
                    }
                  }
                },
          child: _addKnowledgeDialogNotifier.isLoadingWhenCreateNewKnowledge
              ? Stack(alignment: Alignment.center, children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.grey,
                      ),
                      child: const Text("Loading...")),
                  const Positioned(
                    child: CupertinoActivityIndicator(
                      radius: 10,
                      color: Colors.blue,
                    ),
                  ),
                ])
              : Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.blue,
                  ),
                  child: const Text('Create')),
        ),
      ],
    );
  }
}
