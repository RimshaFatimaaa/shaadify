import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/wedding_item.dart';
import '../models/vendor.dart';
import '../utils/price_formatter.dart';

// Data class to pass both item and vendor for drag and drop
class ItemWithVendor {
  final WeddingItem item;
  final Vendor vendor;

  ItemWithVendor({required this.item, required this.vendor});
}

class ItemWithVendorsCard extends StatefulWidget {
  final WeddingItem item;
  final List<Vendor> vendors;
  final Function(WeddingItem item, Vendor vendor)? onVendorSelected;

  const ItemWithVendorsCard({
    super.key,
    required this.item,
    required this.vendors,
    this.onVendorSelected,
  });

  @override
  State<ItemWithVendorsCard> createState() => _ItemWithVendorsCardState();
}

class _ItemWithVendorsCardState extends State<ItemWithVendorsCard> {
  bool _isExpanded = false;

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    // Get vendors for this category, sort by rating, and take top 3 from different cities
    final categoryVendors = widget.vendors
        .where((v) => v.category == widget.item.category)
        .toList();

    // Sort by rating (highest first)
    categoryVendors.sort((a, b) => b.rating.compareTo(a.rating));

    // Get unique vendors from different cities (top 3)
    final uniqueVendors = <Vendor>[];
    final seenCities = <String>{};
    for (final vendor in categoryVendors) {
      if (!seenCities.contains(vendor.city) && uniqueVendors.length < 3) {
        uniqueVendors.add(vendor);
        seenCities.add(vendor.city);
      }
    }

    // If we don't have 3 from different cities, fill with remaining top-rated
    if (uniqueVendors.length < 3) {
      for (final vendor in categoryVendors) {
        if (!uniqueVendors.contains(vendor) && uniqueVendors.length < 3) {
          uniqueVendors.add(vendor);
        }
      }
    }

    return Card(
      color: _pistachio, // FIXED: Card is now Pistachio
      margin: EdgeInsets.all(isMobile ? 4 : 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Item Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text(widget.item.icon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: _maroon, // Maroon Text
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${PriceFormatter.formatCompact(widget.item.minPrice)} - ${PriceFormatter.formatCompact(widget.item.maxPrice)}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: _maroon.withOpacity(
                              0.7,
                            ), // Light Maroon Text
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: _maroon, // Maroon Icon
                  ),
                ],
              ),
            ),
          ),
          // Vendor Options
          if (_isExpanded && uniqueVendors.isNotEmpty)
            ...uniqueVendors.map((vendor) {
              final package = vendor.packages.isNotEmpty
                  ? vendor.packages.first
                  : null;
              final price =
                  package?.price ??
                  (widget.item.minPrice + widget.item.maxPrice) / 2;

              final itemWithVendor = ItemWithVendor(
                item: widget.item,
                vendor: vendor,
              );

              return Draggable<ItemWithVendor>(
                data: itemWithVendor,
                feedback: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: _pistachio, // Feedback Card also Pistachio
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    width: 200,
                    decoration: BoxDecoration(
                      color: _pistachio,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _maroon, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.item.icon,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vendor.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: _maroon,
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
                  child: _buildVendorCard(vendor, price, isMobile),
                ),
                child: InkWell(
                  onTap: () {
                    if (widget.onVendorSelected != null) {
                      widget.onVendorSelected!(widget.item, vendor);
                    }
                  },
                  child: _buildVendorCard(vendor, price, isMobile),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildVendorCard(Vendor vendor, double price, bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _pistachio, // Background matches card
        border: Border(
          top: BorderSide(color: _maroon.withOpacity(0.1)), // Subtle separator
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 36), // Align with icon
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        vendor.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: _maroon, // Maroon Text
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (vendor.isVerified)
                      const Icon(Icons.verified, size: 16, color: Colors.blue),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: Colors
                          .amber[800], // Slightly darker amber for visibility
                    ),
                    const SizedBox(width: 4),
                    Text(
                      vendor.rating.toStringAsFixed(1),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _maroon.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '(${vendor.reviewCount})',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _maroon.withOpacity(0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '• ${vendor.city}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _maroon.withOpacity(0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isMobile)
            // Mobile: Show price and prominent Add button
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    PriceFormatter.formatCompact(price),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: _maroon,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Material(
                    color: _maroon, // Maroon Button
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        if (widget.onVendorSelected != null) {
                          widget.onVendorSelected!(widget.item, vendor);
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              size: 16,
                              color: _pistachio, // Pistachio Icon
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Add',
                              style: GoogleFonts.poppins(
                                color: _pistachio, // Pistachio Text
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            // Desktop: Show drag handle
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  PriceFormatter.formatCompact(price),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: _maroon,
                  ),
                ),
                Icon(
                  Icons.drag_handle,
                  size: 16,
                  color: _maroon.withOpacity(0.5),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
