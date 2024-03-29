import 'package:cardiac_petct/src/ui/petct_text_form_field.dart';
import 'package:flutter/material.dart';

class PetctDatePicker extends StatelessWidget {
  final Function(DateTime?) onValue;
  final TextEditingController controller;
  final Function(String?) validator;
  final String? hintText;
  const PetctDatePicker(
      {super.key,
      required this.onValue,
      required this.controller,
      required this.validator,
      this.hintText = 'Data'});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        onValue(date);
      },
      child: AbsorbPointer(
        child: PetctTextFormField(
          controller: controller,
          readOnly: true,
          hintText: hintText,
          validator: (value) => validator(value),
          suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
        ),
      ),
    );
  }
}
