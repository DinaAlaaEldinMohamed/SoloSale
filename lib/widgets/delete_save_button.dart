import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/widgets/custom_elevated_button.dart';

class DeleteSaveButton extends StatelessWidget {
  const DeleteSaveButton({
    Key? key,
    required this.onDelete,
    required this.onSave,
    required this.text,
  }) : super(key: key);

  final VoidCallback onDelete;
  final VoidCallback onSave;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: mediumGrayColor),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
                color: Color(
                  0xFFFF0000,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomElevatedButton(
              label: text,
              onPressed: onSave,
            ),
          ),
        ],
      ),
    );
  }
}
