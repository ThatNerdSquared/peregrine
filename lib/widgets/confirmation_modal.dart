import 'package:flutter/material.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

class ConfirmationModal extends StatelessWidget {
  final int count;

  const ConfirmationModal({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Are you sure you want to delete this tag, and remove it from $count entries?',
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: PretConfig.defaultElementSpacing,
              ),
            ),
            const Text(
                'Warning: this is an irreversible + highly destructive action!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red)),
            const Padding(
              padding: EdgeInsets.only(
                top: PretConfig.defaultElementSpacing,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  autofocus: true,
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: PretConfig.defaultElementSpacing,
                  ),
                ),
                OutlinedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
