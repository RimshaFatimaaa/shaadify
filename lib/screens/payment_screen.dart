import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/wedding_provider.dart';
import '../models/subscription_plan.dart';

class PaymentScreen extends StatefulWidget {
  final SubscriptionPeriod period;
  final SubscriptionPlan plan;
  final bool isVendor;

  const PaymentScreen({
    super.key,
    required this.period,
    required this.plan,
    this.isVendor = false,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isProcessing = false;

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String _formatCardNumber(String value) {
    // Remove all non-digits
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    // Add space every 4 digits
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digitsOnly[i]);
    }
    return buffer.toString();
  }

  String _formatExpiry(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length >= 2) {
      return '${digitsOnly.substring(0, 2)}/${digitsOnly.length > 2 ? digitsOnly.substring(2, 4) : ''}';
    }
    return digitsOnly;
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final provider = Provider.of<WeddingProvider>(context, listen: false);
      bool success;
      
      if (widget.isVendor) {
        success = await provider.subscribeVendor(widget.period);
      } else {
        success = await provider.subscribeToPro(widget.period);
      }

      setState(() => _isProcessing = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isVendor
                  ? 'Payment successful! You can now register your business.'
                  : 'Payment successful! Welcome to Pro!',
              style: GoogleFonts.poppins(color: _maroon),
            ),
            backgroundColor: _pistachio,
          ),
        );
        if (widget.isVendor) {
          // Pop back to auth screen so vendor can complete registration
          Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Payment failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _maroon,
      appBar: AppBar(
        backgroundColor: _maroon,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _pistachio),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment Details',
          style: GoogleFonts.poppins(
            color: _pistachio,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.white,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plan Summary Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _pistachio,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Summary',
                            style: GoogleFonts.poppins(
                              color: _maroon,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.plan.name,
                                style: GoogleFonts.poppins(
                                  color: _maroon,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                widget.plan.formattedPrice,
                                style: GoogleFonts.poppins(
                                  color: _maroon,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.plan.periodLabel,
                            style: GoogleFonts.poppins(
                              color: _maroon.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Card Information',
                      style: GoogleFonts.poppins(
                        color: _maroon,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Card Number
                    TextFormField(
                      controller: _cardNumberController,
                      style: GoogleFonts.poppins(color: _maroon),
                      decoration: InputDecoration(
                        labelText: 'Card Number',
                        labelStyle: GoogleFonts.poppins(color: _maroon),
                        hintText: '1234 5678 9012 3456',
                        hintStyle: GoogleFonts.poppins(color: _maroon.withOpacity(0.6)),
                        prefixIcon: Icon(Icons.credit_card, color: _maroon),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _maroon),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _maroon, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _maroon),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final formatted = _formatCardNumber(newValue.text);
                          return TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(
                              offset: formatted.length,
                            ),
                          );
                        }),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card number';
                        }
                        final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                        if (digitsOnly.length < 16) {
                          return 'Card number must be 16 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Card Holder Name
                    TextFormField(
                      controller: _cardHolderController,
                      style: GoogleFonts.poppins(color: _maroon),
                      decoration: InputDecoration(
                        labelText: 'Cardholder Name',
                        labelStyle: GoogleFonts.poppins(color: _maroon),
                        hintText: 'John Doe',
                        hintStyle: GoogleFonts.poppins(color: _maroon.withOpacity(0.6)),
                        prefixIcon: Icon(Icons.person, color: _maroon),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _maroon),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _maroon, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _maroon),
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter cardholder name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Expiry and CVV Row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiryController,
                            style: GoogleFonts.poppins(color: _maroon),
                            decoration: InputDecoration(
                              labelText: 'Expiry Date',
                              labelStyle: GoogleFonts.poppins(color: _maroon),
                              hintText: 'MM/YY',
                              hintStyle: GoogleFonts.poppins(color: _maroon.withOpacity(0.6)),
                              prefixIcon: Icon(Icons.calendar_today, color: _maroon),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: _maroon),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: _maroon, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: _maroon),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              TextInputFormatter.withFunction((oldValue, newValue) {
                                final formatted = _formatExpiry(newValue.text);
                                return TextEditingValue(
                                  text: formatted,
                                  selection: TextSelection.collapsed(
                                    offset: formatted.length,
                                  ),
                                );
                              }),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                              if (digitsOnly.length < 4) {
                                return 'Invalid';
                              }
                              final month = int.tryParse(digitsOnly.substring(0, 2));
                              if (month == null || month < 1 || month > 12) {
                                return 'Invalid month';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cvvController,
                            style: GoogleFonts.poppins(color: _maroon),
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              labelStyle: GoogleFonts.poppins(color: _maroon),
                              hintText: '123',
                              hintStyle: GoogleFonts.poppins(color: _maroon.withOpacity(0.6)),
                              prefixIcon: Icon(Icons.lock, color: _maroon),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: _maroon),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: _maroon, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: _maroon),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (value.length < 3) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Security Notice
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock, color: _maroon, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your payment information is secure and encrypted',
                              style: GoogleFonts.poppins(
                                color: _maroon,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Pay Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _processPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _maroon,
                          foregroundColor: _pistachio,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: _isProcessing
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
                            : Text(
                                'Pay ${widget.plan.formattedPrice}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
