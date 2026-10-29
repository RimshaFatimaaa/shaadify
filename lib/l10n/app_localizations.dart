import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bal.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ps.dart';
import 'app_localizations_sd.dart';
import 'app_localizations_skr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bal'),
    Locale('en'),
    Locale('ps'),
    Locale('sd'),
    Locale('skr'),
    Locale('ur'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Shaadify'**
  String get appName;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @vendors.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get vendors;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @locationUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Location updated successfully!'**
  String get locationUpdatedSuccessfully;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationsDisabled;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help? Contact us:'**
  String get needHelp;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @aboutShaadify.
  ///
  /// In en, this message translates to:
  /// **'About Shaadify'**
  String get aboutShaadify;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Plan your perfect Pakistani wedding with our interactive budgeting and vendor marketplace.'**
  String get appDescription;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully!'**
  String get languageChanged;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @canvas.
  ///
  /// In en, this message translates to:
  /// **'Canvas'**
  String get canvas;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @specialDeals.
  ///
  /// In en, this message translates to:
  /// **'Special Deals'**
  String get specialDeals;

  /// No description provided for @topVendors.
  ///
  /// In en, this message translates to:
  /// **'Top Vendors'**
  String get topVendors;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @categoryVenue.
  ///
  /// In en, this message translates to:
  /// **'Venue'**
  String get categoryVenue;

  /// No description provided for @categoryDecor.
  ///
  /// In en, this message translates to:
  /// **'Décor'**
  String get categoryDecor;

  /// No description provided for @categoryCatering.
  ///
  /// In en, this message translates to:
  /// **'Catering'**
  String get categoryCatering;

  /// No description provided for @categoryMakeup.
  ///
  /// In en, this message translates to:
  /// **'Makeup'**
  String get categoryMakeup;

  /// No description provided for @categoryPhotography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get categoryPhotography;

  /// No description provided for @categoryMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get categoryMusic;

  /// No description provided for @categoryNikahSetup.
  ///
  /// In en, this message translates to:
  /// **'Nikah Setup'**
  String get categoryNikahSetup;

  /// No description provided for @categoryGifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get categoryGifts;

  /// No description provided for @categoryCarEntry.
  ///
  /// In en, this message translates to:
  /// **'Car Entry'**
  String get categoryCarEntry;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @eventMehndi.
  ///
  /// In en, this message translates to:
  /// **'Mehndi'**
  String get eventMehndi;

  /// No description provided for @eventBarat.
  ///
  /// In en, this message translates to:
  /// **'Barat'**
  String get eventBarat;

  /// No description provided for @eventWalima.
  ///
  /// In en, this message translates to:
  /// **'Walima'**
  String get eventWalima;

  /// No description provided for @eventMayun.
  ///
  /// In en, this message translates to:
  /// **'Mayun'**
  String get eventMayun;

  /// No description provided for @eventEngagement.
  ///
  /// In en, this message translates to:
  /// **'Engagement'**
  String get eventEngagement;

  /// No description provided for @eventNikah.
  ///
  /// In en, this message translates to:
  /// **'Nikah'**
  String get eventNikah;

  /// No description provided for @eventQawaliNight.
  ///
  /// In en, this message translates to:
  /// **'Qawali Night'**
  String get eventQawaliNight;

  /// No description provided for @selectEventType.
  ///
  /// In en, this message translates to:
  /// **'Select Event Type'**
  String get selectEventType;

  /// No description provided for @eventDescriptionMehndi.
  ///
  /// In en, this message translates to:
  /// **'Traditional henna ceremony'**
  String get eventDescriptionMehndi;

  /// No description provided for @eventDescriptionBarat.
  ///
  /// In en, this message translates to:
  /// **'Main wedding ceremony'**
  String get eventDescriptionBarat;

  /// No description provided for @eventDescriptionWalima.
  ///
  /// In en, this message translates to:
  /// **'Reception dinner'**
  String get eventDescriptionWalima;

  /// No description provided for @eventDescriptionMayun.
  ///
  /// In en, this message translates to:
  /// **'Pre-wedding celebration'**
  String get eventDescriptionMayun;

  /// No description provided for @eventDescriptionEngagement.
  ///
  /// In en, this message translates to:
  /// **'Engagement ceremony'**
  String get eventDescriptionEngagement;

  /// No description provided for @eventDescriptionNikah.
  ///
  /// In en, this message translates to:
  /// **'Islamic marriage ceremony'**
  String get eventDescriptionNikah;

  /// No description provided for @eventDescriptionQawaliNight.
  ///
  /// In en, this message translates to:
  /// **'Musical celebration night'**
  String get eventDescriptionQawaliNight;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @allCities.
  ///
  /// In en, this message translates to:
  /// **'All Cities'**
  String get allCities;

  /// No description provided for @noVendorsFound.
  ///
  /// In en, this message translates to:
  /// **'No vendors found'**
  String get noVendorsFound;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @fromRs.
  ///
  /// In en, this message translates to:
  /// **'From Rs.'**
  String get fromRs;

  /// No description provided for @packagesFrom.
  ///
  /// In en, this message translates to:
  /// **'Packages from'**
  String get packagesFrom;

  /// No description provided for @budgetSettings.
  ///
  /// In en, this message translates to:
  /// **'Budget Settings'**
  String get budgetSettings;

  /// No description provided for @setBudget.
  ///
  /// In en, this message translates to:
  /// **'Set Budget (PKR)'**
  String get setBudget;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @venue.
  ///
  /// In en, this message translates to:
  /// **'Venue'**
  String get venue;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @preferredPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Preferred price range'**
  String get preferredPriceRange;

  /// No description provided for @generateBudgetPlan.
  ///
  /// In en, this message translates to:
  /// **'Generate Budget Plan'**
  String get generateBudgetPlan;

  /// No description provided for @estimatedPrice.
  ///
  /// In en, this message translates to:
  /// **'Estimated Price'**
  String get estimatedPrice;

  /// No description provided for @premiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Premium Plan'**
  String get premiumPlan;

  /// No description provided for @standardPlan.
  ///
  /// In en, this message translates to:
  /// **'Standard Plan'**
  String get standardPlan;

  /// No description provided for @basicPlan.
  ///
  /// In en, this message translates to:
  /// **'Basic Plan'**
  String get basicPlan;

  /// No description provided for @mediumPlan.
  ///
  /// In en, this message translates to:
  /// **'Medium Plan'**
  String get mediumPlan;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @giveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Give Feedback'**
  String get giveFeedback;

  /// No description provided for @viewFeedback.
  ///
  /// In en, this message translates to:
  /// **'View Feedback'**
  String get viewFeedback;

  /// No description provided for @selectVendor.
  ///
  /// In en, this message translates to:
  /// **'Select Vendor'**
  String get selectVendor;

  /// No description provided for @yourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback'**
  String get yourFeedback;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @submitFeedback.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// No description provided for @goodFeedback.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get goodFeedback;

  /// No description provided for @averageFeedback.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get averageFeedback;

  /// No description provided for @badFeedback.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get badFeedback;

  /// No description provided for @allFeedback.
  ///
  /// In en, this message translates to:
  /// **'All Feedback'**
  String get allFeedback;

  /// No description provided for @goodFeedbacks.
  ///
  /// In en, this message translates to:
  /// **'Good Feedbacks'**
  String get goodFeedbacks;

  /// No description provided for @averageFeedbacks.
  ///
  /// In en, this message translates to:
  /// **'Average Feedbacks'**
  String get averageFeedbacks;

  /// No description provided for @badFeedbacks.
  ///
  /// In en, this message translates to:
  /// **'Bad Feedbacks'**
  String get badFeedbacks;

  /// No description provided for @feedbackSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted successfully!'**
  String get feedbackSubmitted;

  /// No description provided for @pleaseSelectVendor.
  ///
  /// In en, this message translates to:
  /// **'Please select a vendor'**
  String get pleaseSelectVendor;

  /// No description provided for @pleaseSelectFeedbackType.
  ///
  /// In en, this message translates to:
  /// **'Please select feedback type'**
  String get pleaseSelectFeedbackType;

  /// No description provided for @pleaseEnterComment.
  ///
  /// In en, this message translates to:
  /// **'Please enter your feedback comment'**
  String get pleaseEnterComment;

  /// No description provided for @noFeedbackYet.
  ///
  /// In en, this message translates to:
  /// **'No feedback yet'**
  String get noFeedbackYet;

  /// No description provided for @feedbackFrom.
  ///
  /// In en, this message translates to:
  /// **'Feedback from'**
  String get feedbackFrom;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get on;

  /// No description provided for @vendorDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get vendorDashboard;

  /// No description provided for @vendorProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get vendorProfile;

  /// No description provided for @vendorPackages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get vendorPackages;

  /// No description provided for @vendorPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get vendorPortfolio;

  /// No description provided for @vendorAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get vendorAnalytics;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @manageYourBusiness.
  ///
  /// In en, this message translates to:
  /// **'Manage your business'**
  String get manageYourBusiness;

  /// No description provided for @quickStats.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get quickStats;

  /// No description provided for @totalBookings.
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get totalBookings;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @managePackages.
  ///
  /// In en, this message translates to:
  /// **'Manage Packages'**
  String get managePackages;

  /// No description provided for @addPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Add Portfolio'**
  String get addPortfolio;

  /// No description provided for @viewAnalytics.
  ///
  /// In en, this message translates to:
  /// **'View Analytics'**
  String get viewAnalytics;

  /// No description provided for @shaadifyVendor.
  ///
  /// In en, this message translates to:
  /// **'SHAADIFY VENDOR'**
  String get shaadifyVendor;

  /// No description provided for @leadsBookings.
  ///
  /// In en, this message translates to:
  /// **'Leads & Bookings'**
  String get leadsBookings;

  /// No description provided for @yourBusiness.
  ///
  /// In en, this message translates to:
  /// **'Your Business'**
  String get yourBusiness;

  /// Welcome message with business name
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {businessName}!'**
  String welcomeBackBusiness(String businessName);

  /// No description provided for @newLeadsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'New Leads\nthis week'**
  String get newLeadsThisWeek;

  /// No description provided for @profileViews.
  ///
  /// In en, this message translates to:
  /// **'Profile Views'**
  String get profileViews;

  /// No description provided for @bookedViaApp.
  ///
  /// In en, this message translates to:
  /// **'Booked via App'**
  String get bookedViaApp;

  /// No description provided for @latestActivity.
  ///
  /// In en, this message translates to:
  /// **'Latest Activity'**
  String get latestActivity;

  /// No description provided for @newBookingRequest.
  ///
  /// In en, this message translates to:
  /// **'New Booking Request from Fatima A. for Nov 12th'**
  String get newBookingRequest;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @packageTrending.
  ///
  /// In en, this message translates to:
  /// **'Your \"Gold Bridal Package\" is trending 🔥 in days'**
  String get packageTrending;

  /// No description provided for @renewNow.
  ///
  /// In en, this message translates to:
  /// **'Renew Now'**
  String get renewNow;

  /// No description provided for @subscriptionPlan.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plan'**
  String get subscriptionPlan;

  /// No description provided for @monthlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Monthly Plan'**
  String get monthlyPlan;

  /// No description provided for @yearlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Yearly Plan'**
  String get yearlyPlan;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get active;

  /// Renewal date text
  ///
  /// In en, this message translates to:
  /// **'Renews on: {date}'**
  String renewsOn(String date);

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manageSubscription;

  /// No description provided for @subscribeNow.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribeNow;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @requestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Request accepted successfully!'**
  String get requestAccepted;

  /// No description provided for @leadCompleted.
  ///
  /// In en, this message translates to:
  /// **'Lead marked as completed!'**
  String get leadCompleted;

  /// No description provided for @vendorSubscription.
  ///
  /// In en, this message translates to:
  /// **'Vendor Subscription'**
  String get vendorSubscription;

  /// No description provided for @businessListing.
  ///
  /// In en, this message translates to:
  /// **'Business listing on platform'**
  String get businessListing;

  /// No description provided for @receiveBookingRequests.
  ///
  /// In en, this message translates to:
  /// **'Receive booking requests'**
  String get receiveBookingRequests;

  /// No description provided for @managePortfolio.
  ///
  /// In en, this message translates to:
  /// **'Manage your portfolio'**
  String get managePortfolio;

  /// No description provided for @viewAnalyticsInsights.
  ///
  /// In en, this message translates to:
  /// **'View analytics & insights'**
  String get viewAnalyticsInsights;

  /// No description provided for @customerReviewsRatings.
  ///
  /// In en, this message translates to:
  /// **'Customer reviews & ratings'**
  String get customerReviewsRatings;

  /// No description provided for @qrCodeBookings.
  ///
  /// In en, this message translates to:
  /// **'QR code for bookings'**
  String get qrCodeBookings;

  /// No description provided for @priorityListingPlacement.
  ///
  /// In en, this message translates to:
  /// **'Priority listing placement'**
  String get priorityListingPlacement;

  /// No description provided for @featuredVendorBadge.
  ///
  /// In en, this message translates to:
  /// **'Featured vendor badge'**
  String get featuredVendorBadge;

  /// No description provided for @bestValueSave.
  ///
  /// In en, this message translates to:
  /// **'Best value - Save 17%'**
  String get bestValueSave;

  /// No description provided for @changePlan.
  ///
  /// In en, this message translates to:
  /// **'Change Plan'**
  String get changePlan;

  /// No description provided for @cancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancelSubscription;

  /// No description provided for @cancelSubscriptionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel your subscription?'**
  String get cancelSubscriptionConfirmation;

  /// No description provided for @subscriptionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled. You have been logged out.'**
  String get subscriptionCancelled;

  /// No description provided for @businessProfile.
  ///
  /// In en, this message translates to:
  /// **'Business Profile'**
  String get businessProfile;

  /// No description provided for @packages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get packages;

  /// Manage packages text with category
  ///
  /// In en, this message translates to:
  /// **'Manage your {category} packages'**
  String manageYourPackages(String category);

  /// No description provided for @managePackagesGeneric.
  ///
  /// In en, this message translates to:
  /// **'Manage your packages'**
  String get managePackagesGeneric;

  /// No description provided for @addPackage.
  ///
  /// In en, this message translates to:
  /// **'Add Package'**
  String get addPackage;

  /// No description provided for @packageName.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get packageName;

  /// No description provided for @packageDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get packageDescription;

  /// No description provided for @packagePrice.
  ///
  /// In en, this message translates to:
  /// **'Price (PKR)'**
  String get packagePrice;

  /// No description provided for @savePackage.
  ///
  /// In en, this message translates to:
  /// **'Save Package'**
  String get savePackage;

  /// No description provided for @analyticsInsights.
  ///
  /// In en, this message translates to:
  /// **'Analytics & Insights'**
  String get analyticsInsights;

  /// Track business performance text with category
  ///
  /// In en, this message translates to:
  /// **'Track your {category} business performance'**
  String trackBusinessPerformance(String category);

  /// No description provided for @trackBusinessPerformanceGeneric.
  ///
  /// In en, this message translates to:
  /// **'Track your business performance'**
  String get trackBusinessPerformanceGeneric;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// No description provided for @scanQRCodeVenue.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code for venue\'s pin location and other details'**
  String get scanQRCodeVenue;

  /// No description provided for @saveQRCode.
  ///
  /// In en, this message translates to:
  /// **'Save QR Code'**
  String get saveQRCode;

  /// No description provided for @qrCodeSaved.
  ///
  /// In en, this message translates to:
  /// **'QR code saved to gallery!'**
  String get qrCodeSaved;

  /// No description provided for @vendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get vendor;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @package.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get package;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @passwordChangeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Password change feature coming soon!'**
  String get passwordChangeComingSoon;

  /// No description provided for @privacySettingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Privacy settings coming soon!'**
  String get privacySettingsComingSoon;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// No description provided for @noActiveSubscription.
  ///
  /// In en, this message translates to:
  /// **'No active subscription'**
  String get noActiveSubscription;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @acceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Accept Request'**
  String get acceptRequest;

  /// No description provided for @viewQRCode.
  ///
  /// In en, this message translates to:
  /// **'View QR Code'**
  String get viewQRCode;

  /// No description provided for @markAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markAsCompleted;

  /// No description provided for @interestedIn.
  ///
  /// In en, this message translates to:
  /// **'Interested in:'**
  String get interestedIn;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @upgradeOrChangePlan.
  ///
  /// In en, this message translates to:
  /// **'Upgrade or Change Plan'**
  String get upgradeOrChangePlan;

  /// No description provided for @mo.
  ///
  /// In en, this message translates to:
  /// **'mo'**
  String get mo;

  /// No description provided for @yr.
  ///
  /// In en, this message translates to:
  /// **'yr'**
  String get yr;

  /// No description provided for @continueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to Payment'**
  String get continueToPayment;

  /// No description provided for @businessListingRemoved.
  ///
  /// In en, this message translates to:
  /// **'Your business listing will be removed and you will be logged out.'**
  String get businessListingRemoved;

  /// Track business performance with category
  ///
  /// In en, this message translates to:
  /// **'Track your {category} business performance'**
  String trackBusinessPerformanceCategory(String category);

  /// No description provided for @totalViews.
  ///
  /// In en, this message translates to:
  /// **'Total Views'**
  String get totalViews;

  /// No description provided for @inquiries.
  ///
  /// In en, this message translates to:
  /// **'Inquiries'**
  String get inquiries;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @ratingOverview.
  ///
  /// In en, this message translates to:
  /// **'Rating Overview'**
  String get ratingOverview;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @noActivityYet.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get noActivityYet;

  /// No description provided for @recentActivityWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Your recent activity will appear here'**
  String get recentActivityWillAppear;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupport;

  /// No description provided for @phoneSupport.
  ///
  /// In en, this message translates to:
  /// **'Phone Support'**
  String get phoneSupport;

  /// No description provided for @businessHours.
  ///
  /// In en, this message translates to:
  /// **'Business Hours'**
  String get businessHours;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @howToUpdateBusinessProfile.
  ///
  /// In en, this message translates to:
  /// **'How do I update my business profile?'**
  String get howToUpdateBusinessProfile;

  /// No description provided for @howToUpdateBusinessProfileAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile tab and edit your business information. Click Save Profile when done.'**
  String get howToUpdateBusinessProfileAnswer;

  /// No description provided for @howToManagePackages.
  ///
  /// In en, this message translates to:
  /// **'How do I manage my packages?'**
  String get howToManagePackages;

  /// No description provided for @howToManagePackagesAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Packages tab and click the + icon to add new packages or edit existing ones.'**
  String get howToManagePackagesAnswer;

  /// No description provided for @howToAcceptBookingRequests.
  ///
  /// In en, this message translates to:
  /// **'How do I accept booking requests?'**
  String get howToAcceptBookingRequests;

  /// No description provided for @howToAcceptBookingRequestsAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Leads tab, view pending requests, and click Accept Request to confirm bookings.'**
  String get howToAcceptBookingRequestsAnswer;

  /// No description provided for @howToViewAnalytics.
  ///
  /// In en, this message translates to:
  /// **'How do I view my analytics?'**
  String get howToViewAnalytics;

  /// No description provided for @howToViewAnalyticsAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Menu > Analytics to see your business performance metrics, views, and bookings.'**
  String get howToViewAnalyticsAnswer;

  /// No description provided for @vendorType.
  ///
  /// In en, this message translates to:
  /// **'Vendor Type'**
  String get vendorType;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @pleaseEnterBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Please enter business name'**
  String get pleaseEnterBusinessName;

  /// No description provided for @pleaseEnterOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner name'**
  String get pleaseEnterOwnerName;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @pleaseSelectCity.
  ///
  /// In en, this message translates to:
  /// **'Please select a city'**
  String get pleaseSelectCity;

  /// No description provided for @pleaseEnterBusinessAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter business address'**
  String get pleaseEnterBusinessAddress;

  /// No description provided for @pleaseEnterBusinessDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter business description'**
  String get pleaseEnterBusinessDescription;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// No description provided for @noPackagesYet.
  ///
  /// In en, this message translates to:
  /// **'No packages yet'**
  String get noPackagesYet;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @packageAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Package added successfully!'**
  String get packageAddedSuccessfully;

  /// No description provided for @tapIconToAddFirstPackage.
  ///
  /// In en, this message translates to:
  /// **'Tap the + icon to add your first package'**
  String get tapIconToAddFirstPackage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bal',
    'en',
    'ps',
    'sd',
    'skr',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bal':
      return AppLocalizationsBal();
    case 'en':
      return AppLocalizationsEn();
    case 'ps':
      return AppLocalizationsPs();
    case 'sd':
      return AppLocalizationsSd();
    case 'skr':
      return AppLocalizationsSkr();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
