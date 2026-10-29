import 'package:flutter/material.dart';
import '../models/wedding_item.dart';
import '../utils/price_formatter.dart';

class DraggableItemCard extends StatelessWidget {
  final WeddingItem item;
  final VoidCallback? onTap;

  const DraggableItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Draggable<WeddingItem>(
      data: item,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: Container(
          width: isMobile ? 200 : 140,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 4),
              Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildCard(context),
      ),
      child: _buildCard(context),
      onDragStarted: () {
        // Optional: Handle drag start
      },
    );
  }

  Widget _buildCard(BuildContext context, {double opacity = 1.0}) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minWidth: isMobile ? 0 : 140,
          maxWidth: isMobile ? double.infinity : 140,
        ),
        margin: EdgeInsets.all(isMobile ? 4 : 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: opacity),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isMobile
            ? ListTile(
                leading: Text(
                  item.icon,
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                subtitle: Text(
                  '${PriceFormatter.formatCompact(item.minPrice)} - ${PriceFormatter.formatCompact(item.maxPrice)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                trailing: const Icon(Icons.drag_handle),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      item.icon,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  // Name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      item.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Price Range
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${PriceFormatter.formatCompact(item.minPrice)} - ${PriceFormatter.formatCompact(item.maxPrice)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
      ),
    );
  }
}

