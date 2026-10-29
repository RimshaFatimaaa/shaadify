import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/wedding_event.dart';
import '../utils/price_formatter.dart';

class SelectedItemCard extends StatelessWidget {
  final SelectedItem selectedItem;
  final VoidCallback? onRemove;

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  const SelectedItemCard({
    super.key,
    required this.selectedItem,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _pistachio, // Apply Pistachio theme background
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Icon Container
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: _maroon.withOpacity(0.1)),
                  ),
                  child: Center(
                    child: Text(
                      selectedItem.item.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // 2. Content Area (Expanded to fix overflow)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Allows vertical expansion
                    children: [
                      Text(
                        selectedItem.item.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: _maroon,
                        ),
                      ),
                      Text(
                        selectedItem.item.category,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _maroon.withOpacity(0.7),
                        ),
                      ),
                      
                      if (selectedItem.vendorName != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          selectedItem.vendorName!,
                          style: GoogleFonts.poppins(
                            color: _maroon,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Wrap( // Wrap prevents horizontal overflow for ratings/location
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (selectedItem.vendorRating != null) ...[
                              Icon(Icons.star, size: 14, color: Colors.amber[800]),
                              const SizedBox(width: 2),
                              Text(
                                selectedItem.vendorRating!.toStringAsFixed(1),
                                style: TextStyle(fontSize: 12, color: _maroon),
                              ),
                              const SizedBox(width: 8),
                            ],
                            if (selectedItem.vendorCity != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on, size: 14, color: _maroon.withOpacity(0.6)),
                                  const SizedBox(width: 2),
                                  Text(
                                    selectedItem.vendorCity!,
                                    style: TextStyle(fontSize: 12, color: _maroon.withOpacity(0.7)),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // 3. Price Display
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 24),
                  child: Text(
                    PriceFormatter.format(selectedItem.price),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: _maroon,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 4. Remove Button (Top Right)
          if (onRemove != null)
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: Icon(Icons.close, size: 20, color: _maroon.withOpacity(0.6)),
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
        ],
      ),
    );
  }
}