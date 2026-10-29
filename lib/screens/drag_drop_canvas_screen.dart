import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/wedding_provider.dart';
import '../models/wedding_item.dart';
import '../widgets/draggable_item_card.dart';
import '../widgets/item_with_vendors_card.dart';
import '../widgets/selected_item_card.dart';
import '../widgets/budget_meter.dart';
import '../models/vendor.dart';
import '../constants/app_constants.dart';
import '../utils/price_formatter.dart';
import '../utils/event_translations.dart';
import 'timeline_screen.dart';

class DragDropCanvasScreen extends StatefulWidget {
  const DragDropCanvasScreen({super.key});

  @override
  State<DragDropCanvasScreen> createState() => _DragDropCanvasScreenState();
}

enum PriceLevel { budget, balanced, premium }

class _DragDropCanvasScreenState extends State<DragDropCanvasScreen> {
  String? _selectedCategory;
  bool _showItemsDrawer = false;
  final bool _showBudgetDrawer = false;
  PriceLevel _priceLevel = PriceLevel.balanced;
  String? _selectedCity;
  final TextEditingController _budgetController = TextEditingController();

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
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _maroon, // Fallback background
      extendBodyBehindAppBar: true, // Allow body behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent for background image
        elevation: 0,
        iconTheme: IconThemeData(color: _maroon),
        title: Consumer<WeddingProvider>(
          builder: (context, provider, child) {
            final event = provider.currentEvent;
            return Text(
              event?.name ?? 'Plan Your Event',
              style: GoogleFonts.poppins(
                color: _maroon,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        actions: [
          Builder(
            builder: (context) {
              final isMobile = MediaQuery.of(context).size.width < 768;
              if (isMobile) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  tooltip: 'Items',
                  onPressed: () {
                    setState(() {
                      _showItemsDrawer = true;
                    });
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.timeline),
            tooltip: 'Timeline',
            onPressed: () {
              final provider = Provider.of<WeddingProvider>(
                context,
                listen: false,
              );
              provider.generateTimeline();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TimelineScreen()),
              );
            },
          ),
        ],
      ),
      endDrawer: Builder(
        builder: (context) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 768;
              if (!isMobile) return const SizedBox.shrink();
              return Consumer<WeddingProvider>(
                builder: (context, provider, child) {
                  return Drawer(
                    backgroundColor: _maroon, // Maroon Drawer
                    child: _buildItemsSidebar(context, provider),
                  );
                },
              );
            },
          );
        },
      ),
      body: Stack(
        children: [
          // 1. BLURRED BACKGROUND IMAGE LAYER
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.white, // Fallback color
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
              child: Container(
                color: Colors.white.withOpacity(0.3), // Light tint
              ),
            ),
          ),

          // 2. CONTENT LAYER
          SafeArea(
            child: Consumer<WeddingProvider>(
              builder: (context, provider, child) {
                final event = provider.currentEvent;
                if (event == null) {
                  return Center(
                    child: Text(
                      'No event selected',
                      style: GoogleFonts.poppins(color: _maroon),
                    ),
                  );
                }

                List<WeddingItem> availableItems;
                try {
                  availableItems = _selectedCategory == null
                      ? provider.availableItems
                      : provider.getItemsByCategory(_selectedCategory!);
                } catch (e) {
                  debugPrint('Error getting items by category in body: $e');
                  availableItems = provider.availableItems;
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 768;
                    if (isMobile) {
                      return _buildMobileLayout(
                        context,
                        provider,
                        event,
                        availableItems,
                      );
                    } else {
                      return _buildDesktopLayout(
                        context,
                        provider,
                        event,
                        availableItems,
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    WeddingProvider provider,
    dynamic event,
    List<WeddingItem> availableItems,
  ) {
    return Column(
      children: [
        // Top Card (Budget Meter)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white, // White Card for Contrast
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              // HARDCODED MAROON TEXT for Budget Card
              textTheme: Theme.of(context).textTheme.apply(
                bodyColor: _maroon,
                displayColor: _maroon,
                decorationColor: _maroon,
              ),
              iconTheme: IconThemeData(color: _maroon),
            ),
            child: BudgetMeter(
              totalCost: event.totalCost,
              budget: event.budget,
            ),
          ),
        ),

        // Budget Settings Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  color: _maroon, // Maroon Button
                  borderRadius: BorderRadius.circular(12),
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.7,
                          minChildSize: 0.5,
                          maxChildSize: 0.95,
                          builder: (context, scrollController) =>
                              StatefulBuilder(
                                builder: (context, setModalState) => Container(
                                  decoration: BoxDecoration(
                                    color: _maroon, // Maroon Modal
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    child: _buildBudgetBottomSheet(
                                      context,
                                      provider,
                                      setModalState,
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, color: _pistachio),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.budgetSettings,
                            style: GoogleFonts.poppins(
                              color: _pistachio, // Pistachio Text
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Canvas Area
        Expanded(
          child: DragTarget<Object>(
            onWillAcceptWithDetails: (data) => true,
            onAcceptWithDetails: (details) {
              Future.microtask(() {
                if (!mounted) return;
                if (details.data is ItemWithVendor) {
                  final itemWithVendor = details.data as ItemWithVendor;
                  provider.addItemToEventWithVendor(
                    itemWithVendor.item,
                    itemWithVendor.vendor,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${itemWithVendor.vendor.name} - ${itemWithVendor.item.name} added!',
                          style: TextStyle(color: _maroon),
                        ),
                        backgroundColor: _pistachio,
                      ),
                    );
                  }
                } else if (details.data is WeddingItem) {
                  final item = details.data as WeddingItem;
                  provider.addItemToEvent(item);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${item.name} added!',
                          style: TextStyle(color: _maroon),
                        ),
                        backgroundColor: _pistachio,
                      ),
                    );
                  }
                }
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // CORRECTED: Maroon/Transparent background, NOT Pistachio
                  color: _maroon.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: candidateData.isNotEmpty
                        ? Colors.amber
                        : _pistachio.withOpacity(0.3),
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
                child: event.selectedItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 48,
                              color: _pistachio.withOpacity(0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tap menu to add items',
                              style: GoogleFonts.poppins(
                                color: _pistachio.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: event.selectedItems.length,
                        itemBuilder: (context, index) {
                          final selectedItem = event.selectedItems[index];
                          // Note: Ensure SelectedItemCard handles its own coloring (likely Pistachio card with Maroon text)
                          return SelectedItemCard(
                            selectedItem: selectedItem,
                            onRemove: () {
                              provider.removeItemFromEvent(selectedItem.id);
                            },
                          );
                        },
                      ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // DRAWER ITEMS
  // ---------------------------------------------------------------------------
  Widget _buildItemsSidebar(BuildContext context, WeddingProvider provider) {
    List<WeddingItem> availableItems;
    try {
      availableItems = _selectedCategory == null
          ? provider.availableItems
          : provider.getItemsByCategory(_selectedCategory!);
    } catch (e) {
      availableItems = provider.availableItems;
    }

    final isMobile = MediaQuery.of(context).size.width < 768;

    return Column(
      children: [
        if (isMobile)
          Container(
            padding: const EdgeInsets.all(16),
            color: _pistachio, // Header is Pistachio
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: _maroon, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tap "Add" to add items',
                        style: GoogleFonts.poppins(
                          color: _maroon,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Expand items to see vendor options',
                  style: GoogleFonts.poppins(
                    color: _maroon.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.all(12),
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            dropdownColor: _pistachio,
            decoration: InputDecoration(
              filled: true,
              fillColor: _pistachio,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: _pistachio),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _pistachio),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _pistachio, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            hint: Text(
              AppLocalizations.of(context)!.allCategories,
              style: TextStyle(color: _maroon),
            ),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(
                  AppLocalizations.of(context)!.allCategories,
                  style: TextStyle(color: _maroon),
                ),
              ),
              ...AppConstants.itemCategories.map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text(
                    _getCategoryTranslation(context, c),
                    style: TextStyle(color: _maroon),
                  ),
                ),
              ),
            ],
            onChanged: (v) =>
                Future.microtask(() => setState(() => _selectedCategory = v)),
            icon: Icon(Icons.arrow_drop_down, color: _maroon),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: availableItems.length,
            itemBuilder: (context, index) {
              final item = availableItems[index];
              final vendors = provider.getVendorsByCategory(
                item.category,
                city: _selectedCity,
              );
              return ItemWithVendorsCard(
                item: item,
                vendors: vendors,
                onVendorSelected: (s, v) =>
                    provider.addItemToEventWithVendor(s, v),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // BUDGET BOTTOM SHEET
  // ---------------------------------------------------------------------------
  Widget _buildBudgetBottomSheet(
    BuildContext context,
    WeddingProvider provider, [
    StateSetter? setModalState,
  ]) {
    final event = provider.currentEvent;
    final currentBudget = event?.budget ?? 0.0;
    final TextEditingController bottomSheetBudgetController =
        TextEditingController(
          text: currentBudget > 0 ? currentBudget.toStringAsFixed(0) : '',
        );

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _pistachio.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.budgetSettings,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _pistachio,
            ),
          ),
          const SizedBox(height: 16),
          // City Selection
          Row(
            children: [
              Icon(Icons.location_city, size: 18, color: _pistachio),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.selectCity,
                style: GoogleFonts.poppins(fontSize: 13, color: _pistachio),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedCity,
            isExpanded: true,
            dropdownColor: _maroon,
            decoration: InputDecoration(
              filled: true,
              fillColor: _maroon,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: _pistachio),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _pistachio),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _pistachio, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              hintText: AppLocalizations.of(context)!.allCities,
              hintStyle: TextStyle(color: _pistachio.withOpacity(0.6)),
            ),
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text(
                  AppLocalizations.of(context)!.allCities,
                  style: TextStyle(color: _pistachio),
                ),
              ),
              ...AppConstants.pakistaniCities.map((city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city, style: TextStyle(color: _pistachio)),
                );
              }),
            ],
            onChanged: (val) {
              if (setModalState != null) {
                setModalState(() {
                  _selectedCity = val;
                });
              } else {
                setState(() {
                  _selectedCity = val;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: bottomSheetBudgetController,
            style: TextStyle(color: _pistachio),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.setBudget,
              labelStyle: TextStyle(color: _pistachio.withOpacity(0.7)),
              filled: true,
              fillColor: _maroon,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: _pistachio),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _pistachio),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _pistachio, width: 2),
              ),
            ),
            keyboardType: TextInputType.number,
            onSubmitted: (value) {
              final budget = double.tryParse(value);
              if (budget != null && budget > 0) {
                provider.updateEventBudget(budget);
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.tune, size: 18, color: _pistachio),
              const SizedBox(width: 8),
              Text(
                'Preferred price range',
                style: GoogleFonts.poppins(fontSize: 13, color: _pistachio),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<PriceLevel>(
            initialValue: _priceLevel,
            isExpanded: true,
            dropdownColor: _maroon,
            decoration: InputDecoration(
              filled: true,
              fillColor: _maroon,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: _pistachio),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _pistachio, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            items: [
              DropdownMenuItem(
                value: PriceLevel.budget,
                child: Text(
                  'Budget (lowest price)',
                  style: TextStyle(color: _pistachio),
                ),
              ),
              DropdownMenuItem(
                value: PriceLevel.balanced,
                child: Text(
                  'Balanced (mid price)',
                  style: TextStyle(color: _pistachio),
                ),
              ),
              DropdownMenuItem(
                value: PriceLevel.premium,
                child: Text(
                  'Premium (highest price)',
                  style: TextStyle(color: _pistachio),
                ),
              ),
            ],
            onChanged: (val) {
              if (val != null) {
                if (setModalState != null) {
                  setModalState(() {
                    _priceLevel = val;
                  });
                } else {
                  setState(() {
                    _priceLevel = val;
                  });
                }
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              final budgetText = bottomSheetBudgetController.text.trim();
              if (budgetText.isNotEmpty) {
                final budget = double.tryParse(budgetText);
                if (budget != null && budget > 0) {
                  provider.updateEventBudget(budget);
                  Navigator.pop(context);
                  Future.microtask(() {
                    final result = provider.generateBudgetPlan(
                      priceLevel: _priceLevel.name,
                      city: _selectedCity,
                    );
                    if (result['success'] == true) {
                      _showBudgetPlanModal(context, result);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result['message'] ??
                                'Failed to generate budget plan',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  });
                  return;
                }
              }
              Navigator.pop(context);
              Future.microtask(() {
                final result = provider.generateBudgetPlan(
                  priceLevel: _priceLevel.name,
                );
                if (result['success'] == true) {
                  _showBudgetPlanModal(context, result);
                }
              });
            },
            icon: const Icon(Icons.account_balance_wallet),
            label: const Text('Generate Budget Plan'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: _pistachio, // Pistachio Button
              foregroundColor: _maroon, // Maroon Text
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // (Helper methods)
  Widget _buildDesktopLayout(
    BuildContext context,
    WeddingProvider provider,
    dynamic event,
    List<WeddingItem> availableItems,
  ) {
    return Row(
      children: [
        Container(
          width: 300,
          color: _maroon, // Maroon Sidebar
          child: _buildItemsSidebar(context, provider),
        ),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white, // White Budget Card
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: _maroon, // Maroon Text
                        displayColor: _maroon,
                      ),
                    ),
                    child: BudgetMeter(
                      totalCost: event.totalCost,
                      budget: event.budget,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: DragTarget<Object>(
                  builder: (context, candidateData, rejectedData) => Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _maroon.withOpacity(0.8), // Maroon Canvas
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: event.selectedItems.isEmpty
                        ? Center(
                            child: Text(
                              'Drag items here',
                              style: TextStyle(color: _pistachio),
                            ),
                          )
                        : ListView.builder(
                            itemCount: event.selectedItems.length,
                            itemBuilder: (context, index) => SelectedItemCard(
                              selectedItem: event.selectedItems[index],
                              onRemove: () {},
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 300,
          color: _pistachio, // Pistachio Sidebar
          child: _buildBudgetSidebar(context, provider),
        ),
      ],
    );
  }

  Widget _buildBudgetSidebar(BuildContext context, WeddingProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.budgetSettings,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _maroon,
            ),
          ),
        ],
      ),
    );
  }

  void _showBudgetPlanModal(
    BuildContext context,
    Map<String, dynamic> planData,
  ) {
    final breakdown =
        planData['breakdown'] as Map<String, Map<String, dynamic>>;
    final budget = planData['budget'] as double;
    final remaining = planData['remaining'] as double;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: _maroon, // Maroon Modal
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _pistachio.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Budget Plan Breakdown',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _pistachio,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: _pistachio),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _pistachio, // Pistachio Summary Card
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _maroon, width: 2),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Budget:',
                              style: TextStyle(color: _maroon),
                            ),
                            Text(
                              PriceFormatter.format(budget),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _maroon,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Remaining:',
                              style: TextStyle(color: _maroon),
                            ),
                            Text(
                              PriceFormatter.format(remaining),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: remaining >= 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: breakdown.length,
                    itemBuilder: (context, index) {
                      final category = breakdown.keys.elementAt(index);
                      final data = breakdown[category]!;
                      final item = data['item'] as WeddingItem;
                      final price = data['price'] as double;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: _pistachio, // Pistachio Item Card
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(
                                item.icon,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _maroon,
                                  ),
                                ),
                              ),
                              Text(
                                PriceFormatter.format(price),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _maroon,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
