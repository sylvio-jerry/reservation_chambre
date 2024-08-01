import 'package:flutter/material.dart';

typedef CallbackOnTap = void Function(String? value);

class InputRadio extends StatefulWidget {
  const InputRadio(
      {super.key,
      required this.label,
      required this.onTap,
      required this.selectedValue,
      this.isButtonStyle = false,
      this.isDisabled = false,
      this.boxWidth = 155,
      });

  final String label;
  final String selectedValue;
  final bool isButtonStyle;
  final bool isDisabled;
  final double boxWidth;

  final CallbackOnTap onTap;

  @override
  State<InputRadio> createState() =>
      _InputRadioState();
}

class _InputRadioState
    extends State<InputRadio> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: widget.isButtonStyle ? 60 : 20,
      width:widget.isButtonStyle ? widget.boxWidth : null,
      padding: widget.isButtonStyle ? const EdgeInsets.symmetric(horizontal: 10,vertical: 5) : null,
      decoration: BoxDecoration(
        border: widget.isButtonStyle ? Border.all(color: Theme.of(context).dividerColor) : null,
        borderRadius: widget.isButtonStyle ? BorderRadius.circular(8) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: widget.isButtonStyle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Radio(
            value: widget.label,
            groupValue: widget.selectedValue,
            onChanged: widget.isDisabled ? null : widget.onTap,
            toggleable: false,
            activeColor: isDarkMode ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
            visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 4,),
          Text(
            widget.label,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
