import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wedding_provider.dart';
import '../services/ai_service.dart';
import '../utils/price_formatter.dart';

class PriceSimulatorScreen extends StatefulWidget {
  const PriceSimulatorScreen({super.key});

  @override
  State<PriceSimulatorScreen> createState() => _PriceSimulatorScreenState();
}

class _PriceSimulatorScreenState extends State<PriceSimulatorScreen> {
  final AIService _aiService = AIService();
  final TextEditingController _budgetIncreaseController =
      TextEditingController();
  final TextEditingController _decorReductionController =
      TextEditingController();
  bool _isSimulating = false;
  Map<String, dynamic>? _simulationResult;

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  void dispose() {
    _budgetIncreaseController.dispose();
    _decorReductionController.dispose();
    super.dispose();
  }

  Future<void> _simulatePriceChange() async {
    final provider = Provider.of<WeddingProvider>(context, listen: false);
    final event = provider.currentEvent;

    if (event == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No event selected')));
      return;
    }

    setState(() {
      _isSimulating = true;
    });

    final changes = <String, dynamic>{};
    if (_budgetIncreaseController.text.isNotEmpty) {
      final increase = double.tryParse(_budgetIncreaseController.text);
      if (increase != null) {
        changes['budgetIncrease'] = increase;
      }
    }
    if (_decorReductionController.text.isNotEmpty) {
      final reduction = double.tryParse(_decorReductionController.text);
      if (reduction != null) {
        changes['decorReduction'] = reduction;
      }
    }

    if (changes.isEmpty) {
      setState(() {
        _isSimulating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one change')),
      );
      return;
    }

    try {
      final result = await _aiService.simulatePriceChange(event, changes);
      setState(() {
        _simulationResult = result;
        _isSimulating = false;
      });
    } catch (e) {
      setState(() {
        _isSimulating = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error simulating: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _maroon, // Fallback background
      extendBodyBehindAppBar: true, // Allow body behind AppBar
      appBar: AppBar(
        title: Text(
          'Price Simulator',
          style: TextStyle(fontWeight: FontWeight.bold, color: _maroon),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                color: Colors.white, // Fallback for visibility of maroon text
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
              child: Container(
                color: Colors.white.withOpacity(
                  0.3,
                ), // Light tint to make Maroon text pop
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
                      style: TextStyle(color: _maroon),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Status
                      Card(
                        color: _maroon, // Maroon Card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Status',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: _pistachio, // Pistachio Text
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Current Total:',
                                    style: TextStyle(color: _pistachio),
                                  ),
                                  Text(
                                    PriceFormatter.format(event.totalCost),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: _pistachio, // Pistachio Text
                                    ),
                                  ),
                                ],
                              ),
                              if (event.budget > 0) ...[
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Budget:',
                                      style: TextStyle(color: _pistachio),
                                    ),
                                    Text(
                                      PriceFormatter.format(event.budget),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _pistachio,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Simulation Options
                      Text(
                        'What If Scenarios',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _maroon, // Maroon Text (Outside)
                        ),
                      ),
                      const SizedBox(height: 16),

                      Card(
                        color: _maroon, // Maroon Card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Increase Budget',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: _pistachio, // Pistachio Text
                                    ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _budgetIncreaseController,
                                style: TextStyle(
                                  color: _maroon,
                                ), // Maroon Input Text
                                decoration: InputDecoration(
                                  labelText: 'Amount to increase (PKR)',
                                  hintText: 'e.g., 50000',
                                  labelStyle: TextStyle(
                                    color: _maroon.withOpacity(0.7),
                                  ),
                                  hintStyle: TextStyle(
                                    color: _maroon.withOpacity(0.5),
                                  ),
                                  filled: true,
                                  fillColor: _pistachio, // Pistachio Input BG
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixText: 'Rs. ',
                                  prefixStyle: TextStyle(color: _maroon),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'This will show you what better options you can get with increased budget',
                                style: TextStyle(
                                  color: _pistachio.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Card(
                        color: _maroon, // Maroon Card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reduce Décor Cost',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: _pistachio, // Pistachio Text
                                    ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _decorReductionController,
                                style: TextStyle(
                                  color: _maroon,
                                ), // Maroon Input Text
                                decoration: InputDecoration(
                                  labelText: 'Percentage reduction',
                                  hintText: 'e.g., 20',
                                  labelStyle: TextStyle(
                                    color: _maroon.withOpacity(0.7),
                                  ),
                                  hintStyle: TextStyle(
                                    color: _maroon.withOpacity(0.5),
                                  ),
                                  filled: true,
                                  fillColor: _pistachio, // Pistachio Input BG
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixText: '%',
                                  suffixStyle: TextStyle(color: _maroon),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'This will show you savings if you reduce décor expenses',
                                style: TextStyle(
                                  color: _pistachio.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: _isSimulating ? null : _simulatePriceChange,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _maroon, // Maroon Button
                          foregroundColor: _pistachio, // Pistachio Text
                          minimumSize: const Size(double.infinity, 48),
                          side: BorderSide(color: _pistachio),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSimulating
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _pistachio,
                                  ),
                                ),
                              )
                            : const Text('Simulate Changes'),
                      ),

                      // Results
                      if (_simulationResult != null) ...[
                        const SizedBox(height: 24),
                        Card(
                          color: _maroon, // Maroon Card
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.insights, color: _pistachio),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Simulation Results',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: _pistachio, // Pistachio Text
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'New Total:',
                                      style: TextStyle(color: _pistachio),
                                    ),
                                    Text(
                                      PriceFormatter.format(
                                        (_simulationResult!['newTotal'] as num)
                                            .toDouble(),
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        // Use light green for positive indication on dark BG
                                        color: Colors.lightGreenAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                if (_simulationResult!['savings'] != null) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Savings:',
                                        style: TextStyle(color: _pistachio),
                                      ),
                                      Text(
                                        PriceFormatter.format(
                                          (_simulationResult!['savings'] as num)
                                              .toDouble(),
                                        ),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightGreenAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
