import 'package:flutter/material.dart';

class CardCajas extends StatelessWidget {
  final Color color;
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const CardCajas({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        leading: Icon(icon, size: 32, color: const Color(0xFF333333)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
