import 'package:flutter/material.dart';

import 'package:step_ai/features/prompt/presentation/widgets/category_custom_dropdown.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/horizontal_spacing.dart';
import '../../../../shared/styles/vertical_spacing.dart';
import '../../data/models/bot_res_dto.dart';

class UpdateBotForm extends StatefulWidget {
  const UpdateBotForm({
    super.key,
    required this.formKey,
    required this.onNameChanged,
    required this.onDescriptionChanged,
    required this.onInstructionChanged,
    required this.bot});

  final GlobalKey<FormState> formKey;

  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onInstructionChanged;

  final BotResDto bot;

  @override
  State<UpdateBotForm> createState() => _UpdateBotFormState();
}

class _UpdateBotFormState extends State<UpdateBotForm> {
  late TextEditingController _name, _description, _instruction;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name = TextEditingController();
    _description = TextEditingController();
    _instruction = TextEditingController();

    _name.text = widget.bot.assistantName;
    _description.text = widget.bot.description ?? "";
    _instruction.text = widget.bot.instructions?? "";

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TColor.petRock,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    wordSpacing: 1,
                  ),
                  children: [
                    const TextSpan(text: 'Name'),
                    TextSpan(
                        text: ' *',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColor.poppySurprise,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                  ]),
            ),
          ),
          VSpacing.sm,
          TextFormField(
            controller: _name,
            onChanged: widget.onNameChanged,
            cursorColor: TColor.tamarama,
            decoration: InputDecoration(
              filled: true,
              fillColor: TColor.northEastSnow,
              focusColor: TColor.grahamHair,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
                gapPadding: 4.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: TColor.tamarama),
                borderRadius: BorderRadius.circular(15),
                gapPadding: 4.0,
              ),
              hintText: "Name of your bot/assistant",
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColor.petRock.withOpacity(0.5),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                wordSpacing: 1,
              ),
            ),
          ),
          VSpacing.sm,
          Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TColor.petRock,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    wordSpacing: 1,
                  ),
                  children: const [
                    TextSpan(text: 'Description'),
                  ]),
            ),
          ),
          VSpacing.sm,
          TextFormField(
            controller: _description,
            onChanged: widget.onDescriptionChanged,
            maxLines: 4,
            cursorColor: TColor.tamarama,
            decoration: InputDecoration(
              filled: true,
              fillColor: TColor.northEastSnow,
              focusColor: TColor.grahamHair,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
                gapPadding: 4.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: TColor.tamarama),
                borderRadius: BorderRadius.circular(15),
                gapPadding: 4.0,
              ),
              hintText:
              "Describe your assistant's role and responsibility.",
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColor.petRock.withOpacity(0.5),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                wordSpacing: 1,
              ),
            ),
          ),
          VSpacing.sm,
          Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TColor.petRock,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    wordSpacing: 1,
                  ),
                  children: const [
                    TextSpan(text: 'Instruction(Prompt)'),
                  ]),
            ),
          ),
          VSpacing.sm,
          TextFormField(
            controller: _instruction,
            onChanged: widget.onInstructionChanged,
            maxLines: 4,
            cursorColor: TColor.tamarama,
            decoration: InputDecoration(
              filled: true,
              fillColor: TColor.northEastSnow,
              focusColor: TColor.grahamHair,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
                gapPadding: 4.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: TColor.tamarama),
                borderRadius: BorderRadius.circular(15),
                gapPadding: 4.0,
              ),
              hintText:
              "Insert the instruction/prompt for your assistant.",
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColor.petRock.withOpacity(0.5),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                wordSpacing: 1,
              ),
            ),
          ),
          VSpacing.sm,
        ],
      ),
    );
  }
}
