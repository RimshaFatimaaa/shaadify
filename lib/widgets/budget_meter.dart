import 'package:flutter/material.dart';
import '../utils/budget_indicator.dart';
import '../utils/price_formatter.dart';

class BudgetMeter extends StatelessWidget {
  final double totalCost;
  final double budget;
  final bool showDetails;

  const BudgetMeter({
    super.key,
    required this.totalCost,
    required this.budget,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    final status = BudgetIndicator.getStatus(totalCost, budget);
    final color = BudgetIndicator.getColor(status);
    final percentage = budget > 0 ? (totalCost / budget).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showDetails) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Cost',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  PriceFormatter.format(totalCost),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (budget > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Budget', style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    PriceFormatter.format(budget),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Remaining',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    PriceFormatter.format(budget - totalCost),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
          ],
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 20,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 8),
          // Status Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusChip(status),
              if (budget > 0)
                Text(
                  '${(percentage * 100).toStringAsFixed(0)}% of budget',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BudgetStatus status) {
    String text;
    const color = Color(0xFF6B2C3E); // Deep dull maroon

    switch (status) {
      case BudgetStatus.low:
        text = 'Within Budget';
        break;
      case BudgetStatus.medium:
        text = 'Moderate';
        break;
      case BudgetStatus.high:
        text = 'Over Budget';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF), // Beige
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF6B2C3E), // Deep dull maroon
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF6B2C3E), // Deep dull maroon
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
