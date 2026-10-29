import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/wedding_provider.dart';
import '../models/wedding_event.dart';
import '../utils/event_translations.dart';
import 'vendor_detail_screen.dart';
import '../services/wedding_service.dart';
import '../models/vendor.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  EventType? _selectedEventType;
  final WeddingService _weddingService = WeddingService();

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _maroon, // Fallback background
      extendBodyBehindAppBar: true, // Allow body behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent for background image
        elevation: 0,
        title: Text(
          'Saved Items',
          style: GoogleFonts.poppins(
            color: _maroon, // Maroon Text (Outside Card)
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: _maroon),
      ),
      body: Stack(
        children: [
          // 1. BLURRED BACKGROUND IMAGE LAYER
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors
                    .white, // Fallback to white for maroon text visibility
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Added blur
              child: Container(
                color: Colors.white.withOpacity(
                  0.3,
                ), // Light tint to make Maroon text pop
              ),
            ),
          ),

          // 2. CONTENT LAYER
          SafeArea(child: _buildSavedContent()),
        ],
      ),
    );
  }

  Widget _buildSavedContent() {
    return Consumer<WeddingProvider>(
      builder: (context, provider, child) {
        try {
          final savedVendors = provider.savedVendors;
          final events = provider.events;

          final eventVendors = <EventType, List<Vendor>>{};
          for (final event in events) {
            final vendors = <Vendor>[];
            for (final selectedItem in event.selectedItems) {
              if (selectedItem.vendorId != null &&
                  selectedItem.vendorId!.isNotEmpty &&
                  selectedItem.vendorName != null) {
                final vendor = _weddingService.getVendorById(
                  selectedItem.vendorId!,
                );
                if (vendor != null &&
                    vendor.name == selectedItem.vendorName &&
                    !vendors.any((v) => v.id == vendor.id)) {
                  vendors.add(vendor);
                }
              }
            }
            if (vendors.isNotEmpty) {
              eventVendors[event.type] = vendors;
            }
          }

          List<Vendor> vendorsToShow = _selectedEventType != null
              ? (eventVendors[_selectedEventType] ?? [])
              : [...savedVendors];

          if (eventVendors.isEmpty && savedVendors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: _maroon.withOpacity(0.5), // Maroon Icon
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved items yet',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: _maroon, // Maroon Text
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (eventVendors.isNotEmpty) ...[
                Text(
                  'Events',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _maroon, // Maroon Text (Outside)
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: eventVendors.length,
                    itemBuilder: (context, index) {
                      final entry = eventVendors.entries.elementAt(index);
                      final eventType = entry.key;
                      final vendors = entry.value;
                      final isSelected = _selectedEventType == eventType;

                      return GestureDetector(
                        onTap: () => setState(
                          () => _selectedEventType = isSelected
                              ? null
                              : eventType,
                        ),
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: _maroon, // Maroon Card
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? _pistachio
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  eventType.icon,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  EventTranslations.getEventName(
                                    context,
                                    eventType,
                                  ),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _pistachio, // Pistachio Text
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${vendors.length} vendors',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: _pistachio.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Text(
                _selectedEventType != null
                    ? '${EventTranslations.getEventName(context, _selectedEventType!)} Vendors'
                    : 'All Saved Vendors',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _maroon, // Maroon Text (Outside)
                ),
              ),
              const SizedBox(height: 12),
              ...vendorsToShow.map(
                (vendor) => _buildVendorCard(context, vendor, provider),
              ),
            ],
          );
        } catch (e) {
          return Center(
            child: Text(
              'Error loading content',
              style: TextStyle(color: _maroon),
            ),
          );
        }
      },
    );
  }

  Widget _buildVendorCard(
    BuildContext context,
    Vendor vendor,
    WeddingProvider provider,
  ) {
    return Card(
      color: _maroon, // Maroon Card
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.1),
          child: Text(
            vendor.name.isNotEmpty ? vendor.name[0].toUpperCase() : '?',
            style: TextStyle(color: _pistachio, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          vendor.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _pistachio, // Pistachio Text
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vendor.category,
              style: TextStyle(
                color: _pistachio.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  vendor.rating.toStringAsFixed(1),
                  style: TextStyle(color: _pistachio),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: _pistachio.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  vendor.city,
                  style: TextStyle(color: _pistachio.withOpacity(0.6)),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () => provider.unsaveVendor(vendor.id),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VendorDetailScreen(vendor: vendor),
          ),
        ),
      ),
    );
  }
}
