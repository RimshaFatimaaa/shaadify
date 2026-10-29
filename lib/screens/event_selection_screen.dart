import 'dart:ui'; // Required for ImageFilter (Blur)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/wedding_provider.dart';
import '../models/wedding_event.dart';
import '../utils/event_translations.dart';
import 'drag_drop_canvas_screen.dart';

class EventSelectionScreen extends StatelessWidget {
  const EventSelectionScreen({super.key});

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
        centerTitle: true,
        iconTheme: IconThemeData(
          color: _maroon,
        ), // Maroon Back Button (Changed for visibility on light bg)
        title: Text(
          AppLocalizations.of(context)?.selectEventType ?? 'Select Event',
          style: GoogleFonts.poppins(
            color: _maroon, // Maroon Title
            fontWeight: FontWeight.bold,
          ),
        ),
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
          SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: EventType.values.length,
              itemBuilder: (context, index) {
                return _buildEventTypeCard(context, EventType.values[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTypeCard(BuildContext context, EventType eventType) {
    // Get the path string once so we can use it for both the image and the debug print
    final String imagePath = _getEventImagePath(eventType);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        shadowColor: Colors.black.withOpacity(0.2),
        color: _maroon, // Card Background: Maroon
        child: InkWell(
          onTap: () {
            final provider = Provider.of<WeddingProvider>(
              context,
              listen: false,
            );
            provider.createEvent(eventType);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DragDropCanvasScreen(),
              ),
            );
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
                // ------------------------------------------------
                // IMAGE CONTAINER WITH DEBUGGING
                // ------------------------------------------------
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
                      imagePath, // Uses the path defined above
                      fit: BoxFit.cover,

                      // DEBUGGING CODE: This runs if the image fails to load
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint(
                          "--------------------------------------------------",
                        );
                        debugPrint(
                          "⚠️ IMAGE LOAD FAILED for ${eventType.name}",
                        );
                        debugPrint("⚠️ Trying to load file: $imagePath");
                        debugPrint("⚠️ Error Details: $error");
                        debugPrint(
                          "--------------------------------------------------",
                        );

                        // Fallback to Icon
                        return Center(
                          child: Text(
                            eventType.icon,
                            style: const TextStyle(fontSize: 36),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // ------------------------------------------------
                // TEXT CONTENT
                // ------------------------------------------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        EventTranslations.getEventName(context, eventType),
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              _pistachio, // Pistachio Title inside Maroon Card
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getEventDescription(context, eventType),
                        style: GoogleFonts.poppins(
                          color: _pistachio.withOpacity(
                            0.7,
                          ), // Pistachio Description
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _pistachio.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: _pistachio, // Pistachio Arrow
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

  // ---------------------------------------------------------
  // IMAGE PATHS MAPPING (Using .jpg)
  // ---------------------------------------------------------
  String _getEventImagePath(EventType eventType) {
    switch (eventType) {
      case EventType.mehndi:
        return 'assets/images/me.jpg';
      case EventType.barat:
        return 'assets/images/ba.jpg';
      case EventType.walima:
        return 'assets/images/w.jpg';
      case EventType.mayun:
        return 'assets/images/m.jpg';
      case EventType.engagement:
        return 'assets/images/eng.jpg';
      case EventType.nikah:
        return 'assets/images/nikah.jpg';
      case EventType.qawaliNight:
        return 'assets/images/q.jpg';
      default:
        return 'assets/images/default_event.jpg';
    }
  }

  String _getEventDescription(BuildContext context, EventType eventType) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      switch (eventType) {
        case EventType.mehndi:
          return 'Traditional henna ceremony';
        case EventType.barat:
          return 'Main wedding ceremony';
        case EventType.walima:
          return 'Reception dinner';
        case EventType.mayun:
          return 'Pre-wedding celebration';
        case EventType.engagement:
          return 'Engagement ceremony';
        case EventType.nikah:
          return 'Islamic marriage ceremony';
        case EventType.qawaliNight:
          return 'Musical celebration night';
      }
    }

    switch (eventType) {
      case EventType.mehndi:
        return l10n.eventDescriptionMehndi;
      case EventType.barat:
        return l10n.eventDescriptionBarat;
      case EventType.walima:
        return l10n.eventDescriptionWalima;
      case EventType.mayun:
        return l10n.eventDescriptionMayun;
      case EventType.engagement:
        return l10n.eventDescriptionEngagement;
      case EventType.nikah:
        return l10n.eventDescriptionNikah;
      case EventType.qawaliNight:
        return l10n.eventDescriptionQawaliNight;
    }
  }
}
