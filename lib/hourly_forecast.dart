import 'package:flutter/material.dart';

class HourlyForcasteCard extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;
  const HourlyForcasteCard(
      {super.key, required this.temp, required this.time, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.only(
            bottom: 15.0, top: 15.0, left: 25.0, right: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(time,
                style: const TextStyle(
                    fontSize: 17.0, fontWeight: FontWeight.w500)),
            Icon(icon, size: 35.0),
            Text(temp,
                style: const TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
