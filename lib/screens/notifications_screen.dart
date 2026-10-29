import 'dart:ui'; // Required for ImageFilter (Blur)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
        iconTheme: IconThemeData(color: _maroon), // Maroon Back Button
        title: Text(
          'Notifications',
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
                color: Colors.white, // Fallback so maroon text is visible
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
          SafeArea(child: _buildNotificationList()),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    // Mock data - replace with your actual notification model/provider
    final List<Map<String, String>> notifications = [
      {
        'title': 'Budget Alert',
        'message': 'You have used 97% of your Barat budget.',
        'time': '2 hours ago',
        'icon': '⚠️',
      },
      {
        'title': 'New Vendor Saved',
        'message': 'Golden Platter LHR has been added to your favorites.',
        'time': '5 hours ago',
        'icon': '❤️',
      },
      {
        'title': 'Timeline Updated',
        'message': 'Your Mehndi event timeline has been generated.',
        'time': 'Yesterday',
        'icon': '📅',
      },
    ];

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: _maroon.withOpacity(0.5), // Maroon Empty State Icon
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: GoogleFonts.poppins(
                color: _maroon,
                fontSize: 16,
              ), // Maroon Text
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: _maroon, // Maroon Card background
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.1),
              child: Text(item['icon']!, style: const TextStyle(fontSize: 20)),
            ),
            title: Text(
              item['title']!,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: _pistachio, // Pistachio Title inside card
                fontSize: 14,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  item['message']!,
                  style: GoogleFonts.poppins(
                    color: _pistachio.withOpacity(0.8), // Pistachio Subtitle
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['time']!,
                  style: GoogleFonts.poppins(
                    color: _pistachio.withOpacity(0.5), // Pistachio Time
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.more_vert,
              color: _pistachio.withOpacity(0.4), // Pistachio Icon
              size: 20,
            ),
            onTap: () {
              // Mark as read or navigate
            },
          ),
        );
      },
    );
  }
}
