import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n/app_localizations.dart';
import 'providers/wedding_provider.dart';
import 'providers/language_provider.dart';
import 'providers/feedback_provider.dart';
import 'utils/fallback_material_localizations.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => WeddingProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Shaadify - Wedding Budget Visualizer',
            debugShowCheckedModeBanner: false,
            locale: languageProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              FallbackMaterialLocalizationsDelegate(),
              FallbackWidgetsLocalizationsDelegate(),
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('ur'), // Urdu
              Locale('ps'), // Pashto
              Locale('sd'), // Sindhi
              Locale('bal'), // Balochi
              Locale('skr'), // Saraiki
            ],
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: child!,
              );
            },
            
            // ------------------------------------------------------------
            // THEME: DEEP MAROON BACKGROUND & PISTACHIO ACCENTS
            // ------------------------------------------------------------
            theme: ThemeData(
              useMaterial3: true,
              
              // 1. BACKGROUND (Deep Dark Maroon)
              // We use 0xFF600000 to ensure it looks rich/dark, not bright red.
              scaffoldBackgroundColor: const Color(0xFF600000), 
              canvasColor: const Color(0xFF600000), 
              dialogBackgroundColor: const Color(0xFFD7E8CD), // Pistachio Dialogs

              // 2. COLOR SCHEME
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF600000),
                
                // Primary is Dark Maroon
                primary: const Color(0xFF600000),
                onPrimary: const Color(0xFFD7E8CD), // Pistachio text on primary buttons
                
                // Surfaces (Cards) are Pistachio
                surface: const Color(0xFFD7E8CD),   
                onSurface: const Color(0xFF600000), // Text on cards should be Maroon
                
                brightness: Brightness.dark, // Tells Flutter the background is dark
              ),

              // 3. GLOBAL TEXT THEME (Pistachio Green)
              // This sets the text color for everything OUTSIDE cards (Headers, App Bar, etc.)
              textTheme: GoogleFonts.poppinsTextTheme().copyWith(
                displayLarge: GoogleFonts.poppins(color: const Color(0xFFD7E8CD), fontWeight: FontWeight.bold),
                headlineLarge: GoogleFonts.poppins(color: const Color(0xFFD7E8CD), fontWeight: FontWeight.bold),
                titleLarge: GoogleFonts.poppins(color: const Color(0xFFD7E8CD), fontWeight: FontWeight.w600),
                bodyLarge: GoogleFonts.poppins(color: const Color(0xFFD7E8CD)), 
                bodyMedium: GoogleFonts.poppins(color: const Color(0xFFD7E8CD)), 
                titleMedium: GoogleFonts.poppins(color: const Color(0xFFD7E8CD)),
              ),

              // 4. APP BAR THEME
              appBarTheme: AppBarTheme(
                elevation: 0,
                centerTitle: false,
                backgroundColor: const Color(0xFF600000), // Dark Maroon
                foregroundColor: const Color(0xFFD7E8CD), // Pistachio Text/Icons
                titleTextStyle: GoogleFonts.poppins(
                  color: const Color(0xFFD7E8CD),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: const IconThemeData(color: Color(0xFFD7E8CD)),
              ),

              // 5. CARD THEME (Pistachio Green)
              // We use CardThemeData as per your setup requirements
              cardTheme: CardThemeData( 
                elevation: 4,
                color: const Color(0xFFD7E8CD), // Pistachio Green
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              // 6. LIST TILE THEME
              // Automatically makes text inside standard lists Maroon (readable on Green cards)
              listTileTheme: const ListTileThemeData(
                textColor: Color(0xFF600000), 
                iconColor: Color(0xFF600000),
              ),

              // 7. BUTTON THEME
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD7E8CD), // Pistachio Button
                  foregroundColor: const Color(0xFF600000), // Maroon Text
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              // 8. ICON THEME (Default to Pistachio for background icons)
              iconTheme: const IconThemeData(
                color: Color(0xFFD7E8CD),
              ),
            ),
            
            home: const AuthScreen(),
          );
        },
      ),
    );
  }
}