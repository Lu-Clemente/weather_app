import 'package:flutter/material.dart';

class AdditionalInformationBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AdditionalInformationBox(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              value,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
