import 'package:flutter/material.dart';

class DropdownSelect<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabel;

  const DropdownSelect({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField<T>(
            value: value,
            menuMaxHeight: 300,
            decoration: InputDecoration(
              contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
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
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(itemLabel(item)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
