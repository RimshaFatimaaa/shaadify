import 'dart:ui'; // Required for ImageFilter (Blur)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/wedding_provider.dart';
import '../models/vendor_booking.dart';
import '../models/vendor_lead.dart';
import '../models/wedding_event.dart';
import '../utils/event_translations.dart';
import 'vendor_detail_screen.dart';
import 'qr_code_screen.dart';
import 'notifications_screen.dart';
import 'auth_screen.dart';
import 'report_vendor_screen.dart';

class BookedVendorsScreen extends StatefulWidget {
  const BookedVendorsScreen({super.key});

  @override
  State<BookedVendorsScreen> createState() => _BookedVendorsScreenState();
}

class _BookedVendorsScreenState extends State<BookedVendorsScreen> {
  String _selectedTab = 'pending'; // pending, confirmed

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  String _getCategoryTranslation(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return category;

    switch (category) {
      case 'Venue':
        return l10n.categoryVenue;
      case 'Décor':
        return l10n.categoryDecor;
      case 'Catering':
        return l10n.categoryCatering;
      case 'Makeup':
        return l10n.categoryMakeup;
      case 'Photography':
        return l10n.categoryPhotography;
      case 'Music':
        return l10n.categoryMusic;
      case 'Nikah Setup':
        return l10n.categoryNikahSetup;
      case 'Gifts':
        return l10n.categoryGifts;
      case 'Car Entry':
        return l10n.categoryCarEntry;
      case 'Other':
        return l10n.categoryOther;
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _maroon, // Maroon background
      body: Stack(
        children: [
          // 1. BLURRED BACKGROUND IMAGE LAYER
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.white, // Fallback to white for maroon text visibility
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Added blur
              child: Container(
                color: Colors.white.withOpacity(0.3), // Light tint to make Maroon text pop
              ),
            ),
          ),

          // 2. CONTENT LAYER
          SafeArea(
            child: Consumer<WeddingProvider>(
              builder: (context, provider, child) {
                final bookedVendors = provider.bookedVendors;
                
                final pendingBookings = bookedVendors.where((b) => b.status == 'pending').toList();
                final confirmedBookings = bookedVendors.where((b) => b.status == 'confirmed').toList();
                final filteredBookings = _selectedTab == 'pending' ? pendingBookings : confirmedBookings;

                if (bookedVendors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 64,
                          color: _maroon.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No booked vendors yet',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: _maroon,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Book vendors to view them here',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: _maroon.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Tab Bar
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _maroon.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTab('pending', 'Pending', pendingBookings.length),
                          ),
                          Expanded(
                            child: _buildTab('confirmed', 'Confirmed', confirmedBookings.length),
                          ),
                        ],
                      ),
                    ),
                    // Bookings List
                    Expanded(
                      child: filteredBookings.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.inbox_outlined,
                                    size: 64,
                                    color: _maroon.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _selectedTab == 'pending'
                                        ? 'No pending bookings'
                                        : 'No confirmed bookings',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: _maroon,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _selectedTab == 'pending'
                              ? _buildEventGroupedView(context, filteredBookings, provider)
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: filteredBookings.length,
                                  itemBuilder: (context, index) {
                                    final booking = filteredBookings[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: _buildBookingCard(context, booking, provider),
                                    );
                                  },
                                ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tabId, String label, int count) {
    final isSelected = _selectedTab == tabId;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = tabId;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? _pistachio
              : Colors.transparent, // Pistachio Highlight
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              '$label${count > 0 ? ' ($count)' : ''}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? _maroon : _pistachio, // Inverted Text Color
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Group bookings by event type and display as tiles
  Widget _buildEventGroupedView(BuildContext context, List<VendorBooking> bookings, WeddingProvider provider) {
    // Separate bookings with event types and without
    final Map<String, List<VendorBooking>> groupedBookings = {};
    final List<VendorBooking> nonEventBookings = [];
    
    for (final booking in bookings) {
      if (booking.eventType != null && booking.eventType!.isNotEmpty) {
        final eventType = booking.eventType!;
        if (!groupedBookings.containsKey(eventType)) {
          groupedBookings[eventType] = [];
        }
        groupedBookings[eventType]!.add(booking);
      } else {
        // Randomly selected vendors (not from events)
        nonEventBookings.add(booking);
      }
    }

    // Filter out empty event groups - only keep events with bookings
    final validEventGroups = <String, List<VendorBooking>>{};
    groupedBookings.forEach((eventType, eventBookings) {
      if (eventBookings.isNotEmpty) {
        validEventGroups[eventType] = eventBookings;
      }
    });

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Event tiles in vertical list (only if vendors exist for events)
        if (validEventGroups.isNotEmpty) ...[
          ...validEventGroups.entries.map((entry) {
            final eventTypeString = entry.key;
            final eventBookings = entry.value;
            // Only show tile if there are bookings for this event
            if (eventBookings.isEmpty) return const SizedBox.shrink();
            // Find EventType from string
            EventType? eventTypeEnum;
            for (final type in EventType.values) {
              if (EventTranslations.getEventName(context, type) == eventTypeString || 
                  type.displayName == eventTypeString) {
                eventTypeEnum = type;
                break;
              }
            }
            final eventTypeName = eventTypeEnum != null 
                ? EventTranslations.getEventName(context, eventTypeEnum)
                : eventTypeString;
            return _buildEventTile(context, eventTypeName, eventBookings, provider);
          }).toList(),
          const SizedBox(height: 16),
        ],
        // Non-event bookings section
        if (nonEventBookings.isNotEmpty) ...[
          if (validEventGroups.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Other Vendors',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _maroon,
                ),
              ),
            ),
          ...nonEventBookings.map((booking) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildBookingCard(context, booking, provider),
          )),
        ],
      ],
    );
  }

  // Build event tile similar to event selection screen (half screen width)
  Widget _buildEventTile(BuildContext context, String eventTypeName, List<VendorBooking> bookings, WeddingProvider provider) {
    // Only show tile if there are bookings for this event
    if (bookings.isEmpty) return const SizedBox.shrink();
    // Get EventType from name
    EventType? eventType;
    for (final type in EventType.values) {
      if (type.displayName == eventTypeName || EventTranslations.getEventName(context, type) == eventTypeName) {
        eventType = type;
        break;
      }
    }

    // Get event image path
    String imagePath = 'assets/images/default_event.jpg';
    if (eventType != null) {
      switch (eventType) {
        case EventType.mehndi:
          imagePath = 'assets/images/me.jpg';
          break;
        case EventType.barat:
          imagePath = 'assets/images/ba.jpg';
          break;
        case EventType.walima:
          imagePath = 'assets/images/w.jpg';
          break;
        case EventType.mayun:
          imagePath = 'assets/images/m.jpg';
          break;
        case EventType.engagement:
          imagePath = 'assets/images/eng.jpg';
          break;
        case EventType.nikah:
          imagePath = 'assets/images/nikah.jpg';
          break;
        case EventType.qawaliNight:
          imagePath = 'assets/images/q.jpg';
          break;
      }
    }

    // Get event description
    String description = 'Vendors for $eventTypeName';
    if (eventType != null) {
      final l10n = AppLocalizations.of(context);
      if (l10n != null) {
        switch (eventType) {
          case EventType.mehndi:
            description = l10n.eventDescriptionMehndi;
            break;
          case EventType.barat:
            description = l10n.eventDescriptionBarat;
            break;
          case EventType.walima:
            description = l10n.eventDescriptionWalima;
            break;
          case EventType.mayun:
            description = l10n.eventDescriptionMayun;
            break;
          case EventType.engagement:
            description = l10n.eventDescriptionEngagement;
            break;
          case EventType.nikah:
            description = l10n.eventDescriptionNikah;
            break;
          case EventType.qawaliNight:
            description = l10n.eventDescriptionQawaliNight;
            break;
        }
      } else {
        switch (eventType) {
          case EventType.mehndi:
            description = 'Traditional henna ceremony';
            break;
          case EventType.barat:
            description = 'Main wedding ceremony';
            break;
          case EventType.walima:
            description = 'Reception dinner';
            break;
          case EventType.mayun:
            description = 'Pre-wedding celebration';
            break;
          case EventType.engagement:
            description = 'Engagement ceremony';
            break;
          case EventType.nikah:
            description = 'Islamic marriage ceremony';
            break;
          case EventType.qawaliNight:
            description = 'Musical celebration night';
            break;
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        shadowColor: Colors.black.withOpacity(0.2),
        color: _maroon, // Card Background: Maroon
        child: InkWell(
          onTap: () {
            // Show vendors for this event type
            _showEventVendorsDialog(context, eventTypeName, bookings, provider);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _pistachio.withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                // Image Container - Square on left
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _pistachio.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            eventType?.icon ?? '🎉',
                            style: const TextStyle(fontSize: 36),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Text Content - Expanded in middle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventType != null 
                            ? EventTranslations.getEventName(context, eventType)
                            : eventTypeName,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White Title
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.7), // White Description
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow Icon - Circular on right
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white, // White Arrow
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show vendors dialog for selected event type
  void _showEventVendorsDialog(BuildContext context, String eventTypeName, List<VendorBooking> bookings, WeddingProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: _maroon,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: _pistachio.withOpacity(0.3)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$eventTypeName Vendors',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _pistachio,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: _pistachio),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Vendors List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildBookingCard(context, booking, provider),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    VendorBooking booking,
    WeddingProvider provider,
  ) {
    final vendor = booking.vendor;
    final planName = booking.planName;
    final price = booking.price;
    final status = booking.status;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      color: _maroon, // Maroon Card Background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _pistachio.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorDetailScreen(vendor: vendor),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    child: Text(
                      vendor.name[0].toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: _pistachio,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _pistachio, // Pistachio Text
                                ),
                              ),
                            ),
                            if (vendor.isVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _pistachio.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      size: 16,
                                      color: _pistachio,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      AppLocalizations.of(context)!.verified,
                                      style: GoogleFonts.poppins(
                                        color: _pistachio,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getCategoryTranslation(context, vendor.category),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: _pistachio.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: _pistachio.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              vendor.city,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: _pistachio.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: _pistachio.withOpacity(0.2)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plan',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _pistachio.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$planName Plan',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _pistachio,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Price',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _pistachio.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatPrice(price),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _pistachio, // Keep consistent with theme
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // QR Code button for confirmed Venue bookings
              if (status == 'confirmed' && vendor.category.toLowerCase() == 'venue')
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Convert VendorBooking to VendorLead for QR code
                      final lead = VendorLead(
                        id: booking.id,
                        clientName: provider.userName.isNotEmpty 
                            ? provider.userName 
                            : 'Client',
                        location: vendor.city,
                        eventType: 'Event',
                        eventDate: booking.bookedAt.toString().split(' ')[0],
                        packageName: '$planName Plan',
                        status: LeadStatus.confirmed,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRCodeScreen(
                            lead: lead,
                            isVendorView: false,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.qr_code),
                    label: Text(
                      'View QR Code',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pistachio,
                      foregroundColor: _maroon,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              // Report button for confirmed vendors
              if (status == 'confirmed')
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportVendorScreen(
                            vendor: vendor,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.flag_outlined),
                    label: Text(
                      'Report Vendor',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: status == 'pending' 
                          ? Colors.orange.withOpacity(0.2)
                          : status == 'confirmed'
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: status == 'pending'
                            ? Colors.orange
                            : status == 'confirmed'
                            ? Colors.green
                            : Colors.red,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: status == 'pending' 
                            ? Colors.orange
                            : status == 'confirmed'
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  ),
                  if (status == 'pending')
                    TextButton.icon(
                      onPressed: () {
                        _showCancelBookingDialog(context, booking, provider);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                      label: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Booked on: ${_formatDate(booking.bookedAt)}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: _pistachio.withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 100000) {
      return 'Rs. ${(price / 100000).toStringAsFixed(1)} Lakh';
    } else if (price >= 1000) {
      return 'Rs. ${(price / 1000).toStringAsFixed(0)}K';
    } else {
      return 'Rs. ${price.toStringAsFixed(0)}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCancelBookingDialog(
    BuildContext context,
    VendorBooking booking,
    WeddingProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Booking',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _maroon, // Maroon Text for Dialog Title
          ),
        ),
        content: Text(
          'Are you sure you want to cancel the booking for ${booking.vendor.name}?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.cancelBooking(booking.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Booking cancelled'),
                  backgroundColor: _maroon,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Yes, Cancel',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
