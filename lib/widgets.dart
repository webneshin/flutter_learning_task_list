import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String search;

  const EmptyState({super.key, required this.search});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.hourglass_empty,
            size: 40,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(search.isNotEmpty
              ? "Your Search task list is empty!"
              : "Your task list is empty!"),
        ],
      ),
    );
  }
}


class MyCheckBox extends StatelessWidget {
  final double size = 20;
  final bool value;
  final GestureTapCallback onTap;

  const MyCheckBox({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: !value
          ? Icon(
        Icons.circle_outlined,
        size: size,
        color: Colors.grey,
      )
          : Icon(
        Icons.check_circle,
        size: size,
        color: Colors.deepPurple,
      ),
    );
  }
}

