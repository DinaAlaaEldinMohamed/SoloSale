import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter_pos/widgets/buttons/secondary_button.dart';

class SalesActions extends StatelessWidget {
  const SalesActions({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: const Icon(
        Icons.more_vert,
        color: primaryColor,
        size: 24,
      ),
      onSelected: (value) {
        if (value == 'Edit') {
          // editSale(sale, client, context, time);
        } else if (value == 'Delete') {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Delete Sale'),
                content: const Text('Confirm Delete'),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          backgroundColor: grey1Color,
                          textColor: textDarkColor,
                          onPressed: () {},
                          label: 'Cancel',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CustomElevatedButton(
                          backgroundColor: redColor,
                          onPressed: () {},
                          label: 'Confirm',
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: 'Edit',
          child: Text(
            'Edit',
            style: bodyText(
              Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ),
        PopupMenuItem(
          value: 'Delete',
          child: Text(
            'Delete',
            style: bodyText(redColor),
          ),
        ),
      ],
    );
  }
}
