import 'package:flutter/material.dart';

class ProfileFormWideField extends StatelessWidget {
  final String label;
  final String value;
  final bool withEditButton;
  final VoidCallback? onEdit;

  ProfileFormWideField({
    required this.label,
    required this.value,
    this.withEditButton = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (withEditButton)
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                ),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class ProfileFormNarrowField extends StatelessWidget {
  final String label;
  final String value;
  final bool withEditButton;
  final VoidCallback? onEdit;

  ProfileFormNarrowField({
    required this.label,
    required this.value,
    this.withEditButton = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
            Spacer(),
            if (withEditButton)
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
              ),
          ],
        )



      ],
    );
  }
}