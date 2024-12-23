import 'package:flutter/material.dart';

import '../../../../shared/styles/colors.dart';

class EmailComposer extends StatefulWidget {
  const EmailComposer({super.key});

  @override
  State<EmailComposer> createState() => _EmailComposerState();
}

class _EmailComposerState extends State<EmailComposer> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _senderController = TextEditingController();
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _yourEmailController = TextEditingController();
  final TextEditingController _mainIdeaController = TextEditingController();
  final TextEditingController _emailActionController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _formalityController = TextEditingController();
  final TextEditingController _toneController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free resources
    _subjectController.dispose();
    _senderController.dispose();
    _receiverController.dispose();
    _yourEmailController.dispose();
    _mainIdeaController.dispose();
    _emailActionController.dispose();
    _lengthController.dispose();
    _formalityController.dispose();
    _toneController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with submission logic
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildResult(),
                  ],
                ),
              ),
            );
          });
    }
  }

  String? _validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Composer"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Container _buildResult() {
    return Container(
      width: 350,
      height: 300,
      decoration: BoxDecoration(
        color: TColor.tamarama.withOpacity(0.5),
      ),
      child: const SingleChildScrollView(
        child: Text(""),
      ),
    );
  }

  Widget _buildForm() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Wrap(
            children: [
              _buildRowFormField("Email Subject", _subjectController),
              _buildRowFormField("Sender", _senderController),
              _buildRowFormField("Receiver", _receiverController),
              _buildEmailFormField("Email to reply to", _yourEmailController),
              _buildRowFormField("Main Idea", _mainIdeaController),
              _buildRowFormField("Email Action", _emailActionController),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  _buildFormField("Length", _lengthController),
                  _buildFormField("Formality", _formalityController),
                  _buildFormField("Tone", _toneController),
                  _buildFormField("Language", _languageController),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _submitForm,
                        borderRadius: BorderRadius.circular(4),
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: TColor.goldenState,
                              gradient: LinearGradient(
                                  colors: [TColor.tamarama, TColor.royalBlue])),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 50),
                            child: Text(
                              "Generate",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontSize: 20,
                                      color: TColor.doctorWhite,
                                      fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextFormField(
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: TColor.petRock,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
            controller: controller,
            validator: _validateField,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: TColor.petRock.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
              labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: TColor.petRock.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
              filled: true,
              fillColor: TColor.northEastSnow,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: TColor.tamarama,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return SizedBox(
      width: 175,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            TextFormField(
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: TColor.petRock,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
              controller: controller,
              validator: _validateField,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: TColor.petRock.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: TColor.petRock.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                filled: true,
                fillColor: TColor.northEastSnow,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: TColor.tamarama,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextFormField(
            maxLines: 20,
            minLines: 10,
            controller: controller,
            validator: _validateField,
            decoration: InputDecoration(
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: TColor.petRock.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
              labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: TColor.petRock.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
              filled: true,
              fillColor: TColor.northEastSnow,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: TColor.tamarama,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
