import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservation/src/themes/colors.dart';

class CustomDateFormField extends StatefulWidget {
  const CustomDateFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.validator,
    this.onChange,
    required this.controller,
    this.iconData,
  });

  final IconData? iconData;
  final String hintText;
  final String label;
  final String? Function(String?)? validator;
  final void Function(String?)? onChange;
  final TextEditingController controller;

  @override
  State<CustomDateFormField> createState() => _CustomDateFormFieldState();
}

class _CustomDateFormFieldState extends State<CustomDateFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          onTap: () {
            selectDate(context);
          },
          style: Theme.of(context).textTheme.titleMedium,
          readOnly: true,
          controller:
              widget.controller, // Utilisation du TextEditingController fourni
          keyboardType: TextInputType.datetime,
          validator: widget.validator,
          onChanged: widget.onChange,
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintText: widget.hintText,
            hintStyle:
                TextStyle(color: Theme.of(context).hintColor, fontSize: 14),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            prefixIcon: widget.iconData != null
                ? Icon(
                    widget.iconData,
                    color: AppColors.greyDark.withOpacity(.5),
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red.shade200,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red.shade200,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
        ),
      ],
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      cancelText: "Annuler",
      confirmText: "Valider",
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000, 8),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        widget.controller.text = DateFormat("dd/MM/yyyy").format(pickedDate);
      });
      if (widget.onChange != null) {
        widget.onChange!(pickedDate.toString());
      }
    }
  }
}
