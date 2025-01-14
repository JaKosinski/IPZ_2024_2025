import 'package:flutter/material.dart';

class EventTypeGrid extends StatelessWidget {
  final void Function(String) onEventTypeSelected;

  EventTypeGrid({required this.onEventTypeSelected});

  final List<Map<String, String>> eventTypes = [
    {'type': 'Domówka', 'icon': 'assets/icons/icon_placeholder.png'},
    {'type': 'Warsztaty', 'icon': 'assets/icons/icon_placeholder.png'},
    {'type': 'Impreza masowa', 'icon': 'assets/icons/icon_placeholder.png'},
    {'type': 'Sportowe', 'icon': 'assets/icons/icon_placeholder.png'},
    {'type': 'Kulturalne', 'icon': 'assets/icons/icon_placeholder.png'},
    {'type': 'Spotkanie towarzyskie', 'icon': 'assets/icons/icon_placeholder.png'},
    {'type': 'Outdoor', 'icon': 'assets/icons/icon_placeholder.png'},
    {'type': 'Relaks', 'icon': 'assets/icons/icon_placeholder.png'},
    {'type': 'Firmowe', 'icon': 'assets/icons/icon_placeholder.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: eventTypes.length,
        itemBuilder: (context, index) {
          final eventType = eventTypes[index];
          return GestureDetector(
            onTap: () {
              onEventTypeSelected(eventType['type']!);
            },
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    eventType['icon']!,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  eventType['type']!,
                  style: const TextStyle(
                    fontSize: 14
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}