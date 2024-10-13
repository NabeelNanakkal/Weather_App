import 'package:flutter/material.dart';

class AdditionalInf extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AdditionalInf(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30.00,
          ),
          const SizedBox(
            height: 6.0,
          ),
          Text(label, style: const TextStyle(fontSize: 17.0)),
          const SizedBox(
            height: 2.0,
          ),
          Text(value,
              style:
                  const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
