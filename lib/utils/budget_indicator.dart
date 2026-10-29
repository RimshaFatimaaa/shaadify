import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

enum BudgetStatus {
  low, // Green
  medium, // Yellow
  high, // Red
}

class BudgetIndicator {
  static BudgetStatus getStatus(double totalCost, double budget) {
    if (budget == 0) {
      // No budget set, use absolute thresholds
      if (totalCost < AppConstants.budgetLow) {
        return BudgetStatus.low;
      } else if (totalCost < AppConstants.budgetMedium) {
        return BudgetStatus.medium;
      } else {
        return BudgetStatus.high;
      }
    } else {
      // Use budget percentage
      double percentage = (totalCost / budget) * 100;
      if (percentage < 80) {
        return BudgetStatus.low;
      } else if (percentage < 100) {
        return BudgetStatus.medium;
      } else {
        return BudgetStatus.high;
      }
    }
  }

  static Color getColor(BudgetStatus status) {
    // All statuses use deep dull maroon
    return const Color(0xFF6B2C3E);
  }

  static Color getColorFromCost(double totalCost, double budget) {
    return getColor(getStatus(totalCost, budget));
  }
}

