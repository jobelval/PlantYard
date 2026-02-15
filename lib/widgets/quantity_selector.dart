import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove, size: 18),
            constraints: BoxConstraints(
              minWidth: isTablet ? 40 : 32,
              minHeight: isTablet ? 40 : 32,
            ),
            padding: EdgeInsets.zero,
            color: const Color(0xFF2E7D32),
          ),
          Container(
            width: isTablet ? 40 : 30,
            alignment: Alignment.center,
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 18 : 16,
              ),
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add, size: 18),
            constraints: BoxConstraints(
              minWidth: isTablet ? 40 : 32,
              minHeight: isTablet ? 40 : 32,
            ),
            padding: EdgeInsets.zero,
            color: const Color(0xFF2E7D32),
          ),
        ],
      ),
    );
  }
}
