import 'package:flutter/material.dart';

class HourlyForecastCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;

  const HourlyForecastCard(
      {super.key,
      required this.time,
      required this.icon,
      required this.temperature});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Icon(icon, size: 32),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                "$temperature °C",
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
