import 'dart:ui'; // Required for ImageFilter (Blur)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../providers/wedding_provider.dart';
import '../models/wedding_event.dart';
import '../models/vendor.dart';
import '../services/wedding_service.dart';
import '../utils/event_translations.dart';
import 'event_selection_screen.dart';
import 'vendor_marketplace_screen.dart';
import 'vendor_detail_screen.dart';
import 'notifications_screen.dart';
import 'saved_screen.dart';
import 'profile_screen.dart';
import 'auth_screen.dart';
import 'booked_vendors_screen.dart';
import 'personality_quiz_screen.dart'; // Added import for navigation
import '../constants/app_constants.dart';
import '../widgets/draggable_feedback_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final WeddingService _weddingService = WeddingService();
  List<Vendor> _topRatedVendors = [];
  int _currentIndex = 0;
  late PageController _dealsPageController;
  late ScrollController _categoriesScrollController;
  int _currentDealIndex = 0;

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  int _getValidIndex(int index) {
    if (index < 0) return 0;
    if (index >= 5) return 4;
    return index;
  }

  @override
  void initState() {
    super.initState();
    _dealsPageController = PageController();
    _categoriesScrollController = ScrollController();
    // Ensure currentIndex is valid
    _currentIndex = _getValidIndex(_currentIndex);
    // Load vendors asynchronously to avoid blocking UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTopRatedVendors();
      _startDealsAutoPlay();
    });
  }

  @override
  void dispose() {
    _dealsPageController.dispose();
    _categoriesScrollController.dispose();
    super.dispose();
  }

  void _startDealsAutoPlay() {
    if (!mounted) return;
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _topRatedVendors.length >= 3) {
        final nextIndex = (_currentDealIndex + 1) % 3;
        setState(() {
          _currentDealIndex = nextIndex;
        });
        if (_dealsPageController.hasClients) {
          _dealsPageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        _startDealsAutoPlay();
      }
    });
  }

  void _loadTopRatedVendors() {
    // Use Future.microtask to avoid blocking the build
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _topRatedVendors = _weddingService.getTopRatedVendorsInCity('Lahore');
        });
      }
    });
  }

  void _onTabTapped(int index) {
    if (index >= 0 && index < 5) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  String _getAppBarTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return 'SHAADIFY';

    switch (_currentIndex) {
      case 0:
        return l10n.home;
      case 1:
        return l10n.canvas;
      case 2:
        return l10n.vendors;
      case 3:
        return l10n.cart;
      case 4:
        return l10n.profile;
      default:
        return 'SHAADIFY';
    }
  }

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
    // Ensure currentIndex is always valid before building
    final validIndex = _getValidIndex(_currentIndex);

    return Scaffold(
      backgroundColor: _maroon, // Default background color
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent, // Transparent to show background
        leadingWidth: validIndex == 0 ? 130 : null,
        leading: validIndex == 0
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SHAADIFY',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _maroon, // Maroon Text
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'PAKISTAN EDITION',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        // Changed to Maroon opacity for visibility on light bg
                        color: _maroon.withOpacity(0.7),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        title: validIndex != 0
            ? Text(
                _getAppBarTitle(context),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _maroon, // Maroon Text
                ),
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: _maroon,
            ), // Maroon Icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: _maroon), // Maroon Icon
            tooltip: 'Logout',
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true, // Content flows under AppBar for background
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
          IndexedStack(
            index: validIndex,
            children: [
              _buildHomeContent(),
              const EventSelectionScreen(),
              const VendorMarketplaceScreen(),
              const BookedVendorsScreen(),
              const ProfileScreen(),
            ],
          ),
          // Draggable Feedback Icon - positioned on top
          const DraggableFeedbackIcon(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _maroon.withOpacity(0.95), // Semi-transparent maroon
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: validIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, // Transparent to show container decoration
          elevation: 0, // Remove default elevation

          // 2. SELECTED ITEM (Pistachio Green)
          selectedItemColor: _pistachio,

          // 3. UNSELECTED ITEM (Dimmed Pistachio)
          unselectedItemColor: _pistachio.withOpacity(0.5),

          selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard),
              label: AppLocalizations.of(context)!.canvas,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.store),
              label: AppLocalizations.of(context)!.vendors,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_bag),
              label: AppLocalizations.of(context)!.cart,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: AppLocalizations.of(context)!.profile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Promotional Slider
            _buildPromotionalSlider(context),
            const SizedBox(height: 12),

            // --- ADDED: AI PERSONALITY QUIZ CARD ---
            _buildQuizPreviewCard(context),
            const SizedBox(height: 20),

            // Vendor Categories
            _buildVendorCategories(context),
            const SizedBox(height: 20),

            // Deal Cards Slider
            _buildDealCardsSlider(context),
            const SizedBox(height: 20),

            // Top Vendors
            _buildTopVendors(context),
            const SizedBox(height: 20),

            // Budget Tracker (if exists)
            Consumer<WeddingProvider>(
              builder: (context, provider, child) {
                final currentEvent = provider.currentEvent;
                if (currentEvent != null && currentEvent.budget > 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildBudgetTracker(context, currentEvent),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- NEW: AI QUIZ HELPER METHOD WITH UPDATED NAVIGATION ---
  Widget _buildQuizPreviewCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _maroon, // Maroon Card
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigation updated to PersonalityQuizScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonalityQuizScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.psychology_alt,
                  color: _pistachio, // Pistachio Icon
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Personality Quiz',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _pistachio, // Pistachio Text
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Discover your ideal wedding vibe and get tailored recommendations.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _pistachio.withOpacity(0.8), // Pistachio Text
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: _pistachio, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetTracker(BuildContext context, WeddingEvent event) {
    final spent = event.totalCost;
    final budget = event.budget;
    final percentage = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _maroon, // Maroon Card
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // FIXED: Expanded prevents "Spent" text from overflowing
              Expanded(
                flex: 2,
                child: Text(
                  'Spent: ${_formatLac(spent)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _pistachio, // Pistachio Text
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Event Badge (e.g., Barat)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  EventTranslations.getEventName(context, event.type),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // FIXED: Expanded prevents "Budget" text from overflowing
              Expanded(
                flex: 2,
                child: Text(
                  'Budget: ${_formatLac(budget)}',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _pistachio, // Pistachio Text
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 12,
              backgroundColor: _pistachio.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(_pistachio),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(percentage * 100).toStringAsFixed(0)}% used',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: _pistachio.withOpacity(0.7),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigate to breakdown if needed
                },
                child: Text(
                  'View Full Breakdown →',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _pistachio, // Pistachio Text
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVendorCard(
    BuildContext context,
    Vendor vendor, {
    bool isClickable = false,
  }) {
    Widget cardContent = Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _maroon, // Maroon Card
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.1),
            backgroundImage: AssetImage(
              'assets/images/${vendor.name.toLowerCase().replaceAll(' ', '_').replaceAll("'", "").replaceAll('é', 'e')}.png',
            ),
            onBackgroundImageError: (exception, stackTrace) {
              debugPrint('Image missing for: ${vendor.name}');
            },
            child: vendor.name.isNotEmpty
                ? Text(
                    vendor.name[0].toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _pistachio,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor.name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _pistachio, // Pistachio Text
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < vendor.rating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      );
                    }),
                    const SizedBox(width: 4),
                    Text(
                      vendor.rating.toStringAsFixed(1),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _pistachio, // Pistachio Text
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (vendor.packages.isNotEmpty)
                  Text(
                    '${AppLocalizations.of(context)!.packagesFrom} ${_formatLac(vendor.packages.first.price)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: _pistachio.withOpacity(0.6), // Pistachio Text
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    if (isClickable) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorDetailScreen(vendor: vendor),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: cardContent,
      );
    }

    return cardContent;
  }

  String _formatLac(double amount) {
    if (amount >= 100000) {
      final lac = amount / 100000;
      return '${lac.toStringAsFixed(1)} Lac';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  Widget _buildDotIndicator({
    required int itemCount,
    required int currentIndex,
    required PageController pageController,
    Color? activeColor,
    Color? inactiveColor,
  }) {
    if (itemCount <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (pageController.hasClients) {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: index == currentIndex ? 24 : 8,
              height: 4,
              decoration: BoxDecoration(
                color: index == currentIndex
                    ? (activeColor ?? const Color(0xFFD7E8CD))
                    : (inactiveColor ?? Colors.grey.withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionalSlider(BuildContext context) {
    return Container(
      height: 240,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/login_img.jpeg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: _maroon, // Fallback Color
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Special Offer',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome back!',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enjoy 1.5 Lac off & free consultation',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.95),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_topRatedVendors.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VendorDetailScreen(
                              vendor: _topRatedVendors.first,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Redeem now',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorCategories(BuildContext context) {
    final categories = AppConstants.itemCategories.take(8).toList();
    final categoryIcons = {
      'Venue': Icons.location_city,
      'Décor': Icons.celebration,
      'Catering': Icons.restaurant,
      'Makeup': Icons.face,
      'Photography': Icons.camera_alt,
      'Music': Icons.music_note,
      'Nikah Setup': Icons.church,
      'Gifts': Icons.card_giftcard,
      'Car Entry': Icons.directions_car,
      'Other': Icons.more_horiz,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizations.of(context)!.categories,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _maroon, // Maroon Text outside
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.builder(
            controller: _categoriesScrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VendorMarketplaceScreen(initialCategory: category),
                    ),
                  );
                },
                child: Container(
                  width: 85,
                  margin: const EdgeInsets.only(right: 14),
                  child: Column(
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: _maroon, // Maroon Card
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(
                              0xFFD7E8CD,
                            ).withValues(alpha: 0.15),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFD7E8CD,
                              ).withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          categoryIcons[category] ?? Icons.category,
                          size: 36,
                          color: _pistachio, // Pistachio Icon
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getCategoryTranslation(context, category),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _maroon, // Maroon Text outside
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDealCardsSlider(BuildContext context) {
    if (_topRatedVendors.length < 3) {
      return const SizedBox.shrink();
    }

    final dealVendors = _topRatedVendors.take(3).toList();
    final discounts = [30, 25, 20];
    final dealPricesInLacs = [4.25, 6.90, 5.50];

    final originalPrices = dealPricesInLacs.asMap().entries.map((entry) {
      final index = entry.key;
      final discountedPrice = entry.value;
      final discountPercent = discounts[index];
      return discountedPrice / (1 - discountPercent / 100);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizations.of(context)!.specialDeals,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _maroon, // Maroon Text outside
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _dealsPageController,
            onPageChanged: (index) {
              setState(() {
                _currentDealIndex = index;
              });
            },
            itemCount: dealVendors.length,
            itemBuilder: (context, index) {
              final vendor = dealVendors[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: _maroon, // Maroon Card
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFD7E8CD).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD7E8CD).withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Decorative background pattern
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFD7E8CD,
                            ).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        left: -30,
                        bottom: -30,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '${discounts[index]}% off',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    vendor.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _pistachio, // Pistachio Text
                                      height: 1.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  // Original price (strikethrough)
                                  Row(
                                    children: [
                                      Text(
                                        _formatLac(
                                          originalPrices[index] * 100000,
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: _pistachio.withOpacity(0.5),
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // Discounted price
                                  Row(
                                    children: [
                                      Text(
                                        _formatLac(
                                          dealPricesInLacs[index] * 100000,
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: _pistachio, // Pistachio Text
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'T&Cs apply',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: _pistachio.withOpacity(0.5),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.local_offer,
                                size: 50,
                                color: _pistachio.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _buildDotIndicator(
          itemCount: dealVendors.length,
          currentIndex: _currentDealIndex,
          pageController: _dealsPageController,
          activeColor: Colors.red,
          inactiveColor: _maroon.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildTopVendors(BuildContext context) {
    if (_topRatedVendors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Top Vendors',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _maroon, // Maroon Text outside
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VendorMarketplaceScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Color(0xFF600000),
                ),
                label: Text(
                  AppLocalizations.of(context)!.seeAll,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _maroon,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  backgroundColor: _pistachio.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: _topRatedVendors.take(5).map((vendor) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: _buildVendorCard(context, vendor, isClickable: true),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _maroon, // Maroon Dialog Background
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _pistachio, // Pistachio Text
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(
            color: _pistachio, // Pistachio Text
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: _pistachio.withOpacity(0.7), // Pistachio with opacity
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (route) => false,
              );
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: Colors.redAccent, // Red accent for logout action
              ),
            ),
          ),
        ],
      ),
    );
  }
}
