import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @doNotHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get doNotHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during login'**
  String get loginError;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @chooseImage.
  ///
  /// In en, this message translates to:
  /// **'Choose Image'**
  String get chooseImage;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Have an account?'**
  String get haveAccount;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @editFile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editFile;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsConditions;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @calculatorProjects.
  ///
  /// In en, this message translates to:
  /// **'Calculator and Projects'**
  String get calculatorProjects;

  /// No description provided for @approximateCostDetails.
  ///
  /// In en, this message translates to:
  /// **'Approximate cost details and fees:'**
  String get approximateCostDetails;

  /// No description provided for @constructionConsultationPlansInsurance.
  ///
  /// In en, this message translates to:
  /// **'Construction + Consultation + Plans + Insurance + Fence and tank works + Sanitation + Excavation and backfilling + Removal and transport. All products used are of high quality with necessary guarantees provided.'**
  String get constructionConsultationPlansInsurance;

  /// No description provided for @plansDesigns.
  ///
  /// In en, this message translates to:
  /// **'Plans and Designs'**
  String get plansDesigns;

  /// No description provided for @successPartners.
  ///
  /// In en, this message translates to:
  /// **'Success Partners'**
  String get successPartners;

  /// No description provided for @totalLandArea.
  ///
  /// In en, this message translates to:
  /// **'Total Land Area'**
  String get totalLandArea;

  /// No description provided for @pleaseEnterTotalArea.
  ///
  /// In en, this message translates to:
  /// **'Please enter the total area'**
  String get pleaseEnterTotalArea;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @errorPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please try again'**
  String get errorPleaseTryAgain;

  /// No description provided for @pleaseEnterRequiredInformation.
  ///
  /// In en, this message translates to:
  /// **'Please enter the required information'**
  String get pleaseEnterRequiredInformation;

  /// No description provided for @buildingMechanism.
  ///
  /// In en, this message translates to:
  /// **'Building Mechanism'**
  String get buildingMechanism;

  /// No description provided for @choosebuildingMechanism.
  ///
  /// In en, this message translates to:
  /// **'Choose Building Mechanism'**
  String get choosebuildingMechanism;

  /// No description provided for @chooseType.
  ///
  /// In en, this message translates to:
  /// **'Choose Type'**
  String get chooseType;

  /// No description provided for @residentialComplex.
  ///
  /// In en, this message translates to:
  /// **'Residential Complex'**
  String get residentialComplex;

  /// No description provided for @numberOfFloors.
  ///
  /// In en, this message translates to:
  /// **'Number of Floors'**
  String get numberOfFloors;

  /// No description provided for @enterNumberOfFloors.
  ///
  /// In en, this message translates to:
  /// **'Enter Number of Floors'**
  String get enterNumberOfFloors;

  /// No description provided for @numberOfApartments.
  ///
  /// In en, this message translates to:
  /// **'Number of Apartments'**
  String get numberOfApartments;

  /// No description provided for @enterNumberOfApartments.
  ///
  /// In en, this message translates to:
  /// **'Enter Number of Apartments'**
  String get enterNumberOfApartments;

  /// No description provided for @requestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Request sent successfully'**
  String get requestSentSuccessfully;

  /// No description provided for @requestWillBeReviewed.
  ///
  /// In en, this message translates to:
  /// **'The request will be reviewed soon, you can check the notifications'**
  String get requestWillBeReviewed;

  /// No description provided for @electronicDeed.
  ///
  /// In en, this message translates to:
  /// **'Electronic Deed *'**
  String get electronicDeed;

  /// No description provided for @addSoilTestReport.
  ///
  /// In en, this message translates to:
  /// **'Add Soil Test Report '**
  String get addSoilTestReport;

  /// No description provided for @additionalCostIfNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'If not available, there will be an additional cost of 2000 SAR'**
  String get additionalCostIfNotAvailable;

  /// No description provided for @propertyLocation.
  ///
  /// In en, this message translates to:
  /// **'Property Location'**
  String get propertyLocation;

  /// No description provided for @enterSiteLink.
  ///
  /// In en, this message translates to:
  /// **'Or enter the site link'**
  String get enterSiteLink;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get cancelRequest;

  /// No description provided for @replySentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Reply sent successfully'**
  String get replySentSuccessfully;

  /// No description provided for @paymentNotification.
  ///
  /// In en, this message translates to:
  /// **'You will receive a notification about payment'**
  String get paymentNotification;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @cancelRequestConfirmation.
  ///
  /// In en, this message translates to:
  /// **'The request will be canceled, are you sure you want to cancel?'**
  String get cancelRequestConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @typeOfBuilding.
  ///
  /// In en, this message translates to:
  /// **'Type of Building'**
  String get typeOfBuilding;

  /// No description provided for @totalProjectCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost of the Project'**
  String get totalProjectCost;

  /// No description provided for @agreeToTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Agree to '**
  String get agreeToTermsAndConditions;

  /// No description provided for @pleaseChooseDesignOrPlan.
  ///
  /// In en, this message translates to:
  /// **'Please choose the design or plan'**
  String get pleaseChooseDesignOrPlan;

  /// No description provided for @otherDetailsOrInformation.
  ///
  /// In en, this message translates to:
  /// **'Other details or information'**
  String get otherDetailsOrInformation;

  /// No description provided for @pleaseWriteOtherDetails.
  ///
  /// In en, this message translates to:
  /// **'Please write any other details'**
  String get pleaseWriteOtherDetails;

  /// No description provided for @enterRequestNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter request number'**
  String get enterRequestNumber;

  /// No description provided for @pleaseChooseRequestNumber.
  ///
  /// In en, this message translates to:
  /// **'Please choose request number'**
  String get pleaseChooseRequestNumber;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get submitRequest;

  /// No description provided for @noRequests.
  ///
  /// In en, this message translates to:
  /// **'No requests'**
  String get noRequests;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @plans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get plans;

  /// No description provided for @designs.
  ///
  /// In en, this message translates to:
  /// **'Designs'**
  String get designs;

  /// No description provided for @customPlansAndDesigns.
  ///
  /// In en, this message translates to:
  /// **'Custom Plans and Designs'**
  String get customPlansAndDesigns;

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during loading, please try again'**
  String get loadingError;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @expiresIn3Days.
  ///
  /// In en, this message translates to:
  /// **'Expires in 3 days'**
  String get expiresIn3Days;

  /// No description provided for @attachTransferReceipt.
  ///
  /// In en, this message translates to:
  /// **'Attach Transfer Receipt'**
  String get attachTransferReceipt;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @ahmedAbdullah.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Abdullah'**
  String get ahmedAbdullah;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @sar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get sar;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'عربي'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumber;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @page1Title.
  ///
  /// In en, this message translates to:
  /// **'We build your dreams and make them reality'**
  String get page1Title;

  /// No description provided for @page1Description.
  ///
  /// In en, this message translates to:
  /// **''**
  String get page1Description;

  /// No description provided for @page2Title.
  ///
  /// In en, this message translates to:
  /// **'Are you looking to build and searching for a trustworthy partner'**
  String get page2Title;

  /// No description provided for @page2Description.
  ///
  /// In en, this message translates to:
  /// **'We provide everything you need and build for you using the best specifications and standards. All you have to do is register in the system, choose what suits you, and leave the rest to us'**
  String get page2Description;

  /// No description provided for @page3Title.
  ///
  /// In en, this message translates to:
  /// **'Do you own a property and want to sell it'**
  String get page3Title;

  /// No description provided for @page3Description.
  ///
  /// In en, this message translates to:
  /// **'We\'ll sell it for you at a price higher than you expect, and without any cost to you'**
  String get page3Description;

  /// No description provided for @page4Title.
  ///
  /// In en, this message translates to:
  /// **'Do you want to achieve profits'**
  String get page4Title;

  /// No description provided for @page4Description.
  ///
  /// In en, this message translates to:
  /// **'Diverse, short-term investment opportunities are waiting for you'**
  String get page4Description;

  /// No description provided for @page5Title.
  ///
  /// In en, this message translates to:
  /// **'Our App'**
  String get page5Title;

  /// No description provided for @page5Description.
  ///
  /// In en, this message translates to:
  /// **'Through the app, you can calculate costs, choose your desired designs, and submit your request with ease and convenience.'**
  String get page5Description;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @landcheck.
  ///
  /// In en, this message translates to:
  /// **'Is there a soil test report?'**
  String get landcheck;

  /// No description provided for @realestate.
  ///
  /// In en, this message translates to:
  /// **'Real Estate Offers'**
  String get realestate;

  /// No description provided for @completeMessage.
  ///
  /// In en, this message translates to:
  /// **'Please complete sections'**
  String get completeMessage;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @enterDistrict.
  ///
  /// In en, this message translates to:
  /// **'Enter district name'**
  String get enterDistrict;

  /// No description provided for @chooseCity.
  ///
  /// In en, this message translates to:
  /// **' Choose City'**
  String get chooseCity;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filtering'**
  String get filter;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @mainPhoto.
  ///
  /// In en, this message translates to:
  /// **'Main Photo '**
  String get mainPhoto;

  /// No description provided for @sectionPhotos.
  ///
  /// In en, this message translates to:
  /// **'Section Photos '**
  String get sectionPhotos;

  /// No description provided for @addEstate.
  ///
  /// In en, this message translates to:
  /// **'Add Estate '**
  String get addEstate;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @estateSummary.
  ///
  /// In en, this message translates to:
  /// **'Write a summary about Estate '**
  String get estateSummary;

  /// No description provided for @estateType.
  ///
  /// In en, this message translates to:
  /// **'Estate Type '**
  String get estateType;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @space.
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get space;

  /// No description provided for @residential.
  ///
  /// In en, this message translates to:
  /// **'Residential'**
  String get residential;

  /// No description provided for @commercial.
  ///
  /// In en, this message translates to:
  /// **'Commercial'**
  String get commercial;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @discreption.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get discreption;

  /// No description provided for @refilter.
  ///
  /// In en, this message translates to:
  /// **'ReFilter'**
  String get refilter;

  /// No description provided for @dontFound.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Found'**
  String get dontFound;

  /// No description provided for @estateName.
  ///
  /// In en, this message translates to:
  /// **'House Name'**
  String get estateName;

  /// No description provided for @cooperationAndPartnership.
  ///
  /// In en, this message translates to:
  /// **'Collaboration and Development'**
  String get cooperationAndPartnership;

  /// No description provided for @completeRequest.
  ///
  /// In en, this message translates to:
  /// **' Complete Request'**
  String get completeRequest;

  /// No description provided for @realEstateOrders.
  ///
  /// In en, this message translates to:
  /// **'Real Estate Orders'**
  String get realEstateOrders;

  /// No description provided for @calculatorAndProjectsOrders.
  ///
  /// In en, this message translates to:
  /// **'Calculator and Projects Orders'**
  String get calculatorAndProjectsOrders;

  /// No description provided for @collaborationAndPartenershipOrders.
  ///
  /// In en, this message translates to:
  /// **'طلبات الحاسبـة والمشاريع'**
  String get collaborationAndPartenershipOrders;

  /// No description provided for @oldBuildingsOrders.
  ///
  /// In en, this message translates to:
  /// **'Old Buildings Orders'**
  String get oldBuildingsOrders;

  /// No description provided for @rawLandsOrders.
  ///
  /// In en, this message translates to:
  /// **'RawLands Orders'**
  String get rawLandsOrders;

  /// No description provided for @schemaOrders.
  ///
  /// In en, this message translates to:
  /// **' schema Orders'**
  String get schemaOrders;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Move to payment'**
  String get payment;

  /// No description provided for @confirmlocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmlocation;

  /// No description provided for @addpool.
  ///
  /// In en, this message translates to:
  /// **'Add Pool'**
  String get addpool;

  /// No description provided for @favourite.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favourite;

  /// No description provided for @chances.
  ///
  /// In en, this message translates to:
  /// **'Chances'**
  String get chances;

  /// No description provided for @presentestate.
  ///
  /// In en, this message translates to:
  /// **'Existing property'**
  String get presentestate;

  /// No description provided for @rowland.
  ///
  /// In en, this message translates to:
  /// **'Raw Land'**
  String get rowland;

  /// No description provided for @joinRCT.
  ///
  /// In en, this message translates to:
  /// **'Join RCT'**
  String get joinRCT;

  /// No description provided for @choosebuidingType.
  ///
  /// In en, this message translates to:
  /// **'Choose Building Type'**
  String get choosebuidingType;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @commercialRegister.
  ///
  /// In en, this message translates to:
  /// **'Commercial Registry'**
  String get commercialRegister;

  /// No description provided for @oldBuildings.
  ///
  /// In en, this message translates to:
  /// **'Old Buildings'**
  String get oldBuildings;

  /// No description provided for @sketches.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get sketches;

  /// No description provided for @pleaselogin.
  ///
  /// In en, this message translates to:
  /// **'Please log in'**
  String get pleaselogin;

  /// No description provided for @pleasecontacttheRCTteam.
  ///
  /// In en, this message translates to:
  /// **'Please contact the RCT team to complete your request.'**
  String get pleasecontacttheRCTteam;

  /// No description provided for @pleaseSelectBuilingType.
  ///
  /// In en, this message translates to:
  /// **'Please Select Building Type'**
  String get pleaseSelectBuilingType;

  /// No description provided for @tocontactviaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'to contact via whatsapp'**
  String get tocontactviaWhatsApp;

  /// No description provided for @building.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get building;

  /// No description provided for @villa.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get villa;

  /// No description provided for @complex.
  ///
  /// In en, this message translates to:
  /// **'Complex'**
  String get complex;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @iDNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get iDNumber;

  /// No description provided for @nationalID.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalID;

  /// No description provided for @uploadNationalIdOrCommercialRegister.
  ///
  /// In en, this message translates to:
  /// **'Please upload the National ID or Commercial registry'**
  String get uploadNationalIdOrCommercialRegister;

  /// No description provided for @uploadCommercialRegister.
  ///
  /// In en, this message translates to:
  /// **'Please upload the Commercial Registery'**
  String get uploadCommercialRegister;

  /// No description provided for @enterBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Please enter the birth date'**
  String get enterBirthDate;

  /// No description provided for @enterNationalId.
  ///
  /// In en, this message translates to:
  /// **'Please enter the ID Number'**
  String get enterNationalId;

  /// No description provided for @nationalIdMustBeAtLeast10.
  ///
  /// In en, this message translates to:
  /// **'The National ID must be at least 10 digits'**
  String get nationalIdMustBeAtLeast10;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Please confirm the location'**
  String get confirmLocation;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @oneStreetFencePercentage.
  ///
  /// In en, this message translates to:
  /// **'One street'**
  String get oneStreetFencePercentage;

  /// No description provided for @twoStreetsFencePercentage.
  ///
  /// In en, this message translates to:
  /// **'Two streets'**
  String get twoStreetsFencePercentage;

  /// No description provided for @threeStreetsFencePercentage.
  ///
  /// In en, this message translates to:
  /// **'Three streets'**
  String get threeStreetsFencePercentage;

  /// No description provided for @fourStreetsFencePercentage.
  ///
  /// In en, this message translates to:
  /// **'Four streets'**
  String get fourStreetsFencePercentage;

  /// No description provided for @decorativeFacade.
  ///
  /// In en, this message translates to:
  /// **'Decorative facade'**
  String get decorativeFacade;

  /// No description provided for @stoneFacade.
  ///
  /// In en, this message translates to:
  /// **'Stone facade'**
  String get stoneFacade;

  /// No description provided for @twoStoneFacades.
  ///
  /// In en, this message translates to:
  /// **'Two stone facades'**
  String get twoStoneFacades;

  /// No description provided for @threeStoneFacades.
  ///
  /// In en, this message translates to:
  /// **'Three stone facades'**
  String get threeStoneFacades;

  /// No description provided for @fourStoneFacades.
  ///
  /// In en, this message translates to:
  /// **'Four stone facades'**
  String get fourStoneFacades;

  /// No description provided for @firstFloorArea.
  ///
  /// In en, this message translates to:
  /// **'First floor area'**
  String get firstFloorArea;

  /// No description provided for @repeatedFloorsArea.
  ///
  /// In en, this message translates to:
  /// **'Repeated floors area'**
  String get repeatedFloorsArea;

  /// No description provided for @annexArea.
  ///
  /// In en, this message translates to:
  /// **'Annex area'**
  String get annexArea;

  /// No description provided for @noStone.
  ///
  /// In en, this message translates to:
  /// **'No Stone'**
  String get noStone;

  /// No description provided for @exteriorfinishing.
  ///
  /// In en, this message translates to:
  /// **'Exterior finishing'**
  String get exteriorfinishing;

  /// No description provided for @landdetails.
  ///
  /// In en, this message translates to:
  /// **'Land details'**
  String get landdetails;

  /// No description provided for @buildingdetails.
  ///
  /// In en, this message translates to:
  /// **'Building details'**
  String get buildingdetails;

  /// No description provided for @exteriorFinishing.
  ///
  /// In en, this message translates to:
  /// **'Exterior Finishing'**
  String get exteriorFinishing;

  /// No description provided for @landDetails.
  ///
  /// In en, this message translates to:
  /// **'Land Details'**
  String get landDetails;

  /// No description provided for @buildingDetails.
  ///
  /// In en, this message translates to:
  /// **'Building Details'**
  String get buildingDetails;

  /// No description provided for @waterTank.
  ///
  /// In en, this message translates to:
  /// **'Water Tank'**
  String get waterTank;

  /// No description provided for @sewageTank.
  ///
  /// In en, this message translates to:
  /// **'Sewage Tank'**
  String get sewageTank;

  /// No description provided for @fence.
  ///
  /// In en, this message translates to:
  /// **'Fence'**
  String get fence;

  /// No description provided for @invertedBeams.
  ///
  /// In en, this message translates to:
  /// **'Inverted Beams'**
  String get invertedBeams;

  /// No description provided for @swimmingPool.
  ///
  /// In en, this message translates to:
  /// **'Swimming Pool'**
  String get swimmingPool;

  /// No description provided for @soilTesting.
  ///
  /// In en, this message translates to:
  /// **'Soil Testing'**
  String get soilTesting;

  /// No description provided for @floorArea.
  ///
  /// In en, this message translates to:
  /// **'Floor Area'**
  String get floorArea;

  /// No description provided for @totalBuildingArea.
  ///
  /// In en, this message translates to:
  /// **'Total Building Area'**
  String get totalBuildingArea;

  /// No description provided for @excavationandBackfillCharges.
  ///
  /// In en, this message translates to:
  /// **'Excavation and Backfill Charges'**
  String get excavationandBackfillCharges;

  /// No description provided for @norealestatelistingmatchesthesearch.
  ///
  /// In en, this message translates to:
  /// **'No real estate listing matches the search.'**
  String get norealestatelistingmatchesthesearch;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully.'**
  String get registerSuccess;

  /// No description provided for @pleaseenteravalidphonenumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number.'**
  String get pleaseenteravalidphonenumber;

  /// No description provided for @riyadh.
  ///
  /// In en, this message translates to:
  /// **'Riyadh'**
  String get riyadh;

  /// No description provided for @jeddah.
  ///
  /// In en, this message translates to:
  /// **'Jeddah'**
  String get jeddah;

  /// No description provided for @makkahAlMukarramah.
  ///
  /// In en, this message translates to:
  /// **'Makkah Al-Mukarramah'**
  String get makkahAlMukarramah;

  /// No description provided for @madinahAlMunawwarah.
  ///
  /// In en, this message translates to:
  /// **'Madinah Al-Munawwarah'**
  String get madinahAlMunawwarah;

  /// No description provided for @dammam.
  ///
  /// In en, this message translates to:
  /// **'Dammam'**
  String get dammam;

  /// No description provided for @khobar.
  ///
  /// In en, this message translates to:
  /// **'Khobar'**
  String get khobar;

  /// No description provided for @alAhsa.
  ///
  /// In en, this message translates to:
  /// **'Al-Ahsa'**
  String get alAhsa;

  /// No description provided for @dhahran.
  ///
  /// In en, this message translates to:
  /// **'Dhahran'**
  String get dhahran;

  /// No description provided for @qassim.
  ///
  /// In en, this message translates to:
  /// **'Qassim'**
  String get qassim;

  /// No description provided for @abha.
  ///
  /// In en, this message translates to:
  /// **'Abha'**
  String get abha;

  /// No description provided for @hail.
  ///
  /// In en, this message translates to:
  /// **'Hail'**
  String get hail;

  /// No description provided for @tabuk.
  ///
  /// In en, this message translates to:
  /// **'Tabuk'**
  String get tabuk;

  /// No description provided for @alJouf.
  ///
  /// In en, this message translates to:
  /// **'Al-Jouf'**
  String get alJouf;

  /// No description provided for @gurayat.
  ///
  /// In en, this message translates to:
  /// **'Gurayat'**
  String get gurayat;

  /// No description provided for @khamisMushait.
  ///
  /// In en, this message translates to:
  /// **'Khamis Mushait'**
  String get khamisMushait;

  /// No description provided for @jazan.
  ///
  /// In en, this message translates to:
  /// **'Jazan'**
  String get jazan;

  /// No description provided for @najran.
  ///
  /// In en, this message translates to:
  /// **'Najran'**
  String get najran;

  /// No description provided for @yanbu.
  ///
  /// In en, this message translates to:
  /// **'Yanbu'**
  String get yanbu;

  /// No description provided for @alHofuf.
  ///
  /// In en, this message translates to:
  /// **'Al-Hofuf'**
  String get alHofuf;

  /// No description provided for @qatif.
  ///
  /// In en, this message translates to:
  /// **'Qatif'**
  String get qatif;

  /// No description provided for @buraydah.
  ///
  /// In en, this message translates to:
  /// **'Buraydah'**
  String get buraydah;

  /// No description provided for @unayzah.
  ///
  /// In en, this message translates to:
  /// **'Unayzah'**
  String get unayzah;

  /// No description provided for @areyousureyouwanttocanceltheorder.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the order?'**
  String get areyousureyouwanttocanceltheorder;

  /// No description provided for @pleaseuploadtheelectronicdeed.
  ///
  /// In en, this message translates to:
  /// **'Please upload the electronic deed'**
  String get pleaseuploadtheelectronicdeed;

  /// No description provided for @pleaseentertheprice.
  ///
  /// In en, this message translates to:
  /// **'Please enter the price'**
  String get pleaseentertheprice;

  /// No description provided for @pleaseselectacity.
  ///
  /// In en, this message translates to:
  /// **'Please select a city'**
  String get pleaseselectacity;

  /// No description provided for @pleaseentertheneighborhoodname.
  ///
  /// In en, this message translates to:
  /// **'Please enter the neighborhood name'**
  String get pleaseentertheneighborhoodname;

  /// No description provided for @pleaseselectthelocationviathemaporenterthelink.
  ///
  /// In en, this message translates to:
  /// **'Please select the location via the map or enter the link'**
  String get pleaseselectthelocationviathemaporenterthelink;

  /// No description provided for @pleaseconfirmthelocation.
  ///
  /// In en, this message translates to:
  /// **'Please confirm the location'**
  String get pleaseconfirmthelocation;

  /// No description provided for @nospecial.
  ///
  /// In en, this message translates to:
  /// **'No special'**
  String get nospecial;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get delete;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'description'**
  String get description;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @stores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get stores;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @theserviceiscurrentlyunavailable.
  ///
  /// In en, this message translates to:
  /// **'The service is currently unavailable'**
  String get theserviceiscurrentlyunavailable;

  /// No description provided for @theorderhasbeensuccessfullydeleted.
  ///
  /// In en, this message translates to:
  /// **'The order has been successfully deleted'**
  String get theorderhasbeensuccessfullydeleted;

  /// No description provided for @failedtodeletetheorderPleasetryagainlater.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete the order. Please try again later'**
  String get failedtodeletetheorderPleasetryagainlater;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deleting;

  /// No description provided for @canceltheorder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get canceltheorder;

  /// No description provided for @pleaseDownloadFile.
  ///
  /// In en, this message translates to:
  /// **'Please Download File'**
  String get pleaseDownloadFile;

  /// No description provided for @ihavereadandagreetothetermsandconditions.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the terms and conditions.'**
  String get ihavereadandagreetothetermsandconditions;

  /// No description provided for @youhaverejectedthetermsandconditions.
  ///
  /// In en, this message translates to:
  /// **'You have rejected the terms and conditions.'**
  String get youhaverejectedthetermsandconditions;

  /// No description provided for @anerroroccurredpleasetryagain.
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please try again.'**
  String get anerroroccurredpleasetryagain;

  /// No description provided for @yourresponsehasbeensuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your response has been successfully submitted. Thank you'**
  String get yourresponsehasbeensuccessfully;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving....'**
  String get saving;

  /// No description provided for @pleaseenterthenamematchingtheID.
  ///
  /// In en, this message translates to:
  /// **'Please enter the name matching the ID'**
  String get pleaseenterthenamematchingtheID;

  /// No description provided for @agreetothetermsandconditions.
  ///
  /// In en, this message translates to:
  /// **'Agree to the terms and conditions.'**
  String get agreetothetermsandconditions;

  /// No description provided for @pleaseenterthephonenumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter the mobile number'**
  String get pleaseenterthephonenumber;

  /// No description provided for @theopportunityiscomplete.
  ///
  /// In en, this message translates to:
  /// **'The opportunity is complete. You cannot complete the request.'**
  String get theopportunityiscomplete;

  /// No description provided for @remainingopportunities.
  ///
  /// In en, this message translates to:
  /// **'Remaining opportunities : '**
  String get remainingopportunities;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @opportunityduration.
  ///
  /// In en, this message translates to:
  /// **'Opportunity duration :'**
  String get opportunityduration;

  /// No description provided for @financialrevenue.
  ///
  /// In en, this message translates to:
  /// **'Financial revenue : '**
  String get financialrevenue;

  /// No description provided for @opportunityPrice.
  ///
  /// In en, this message translates to:
  /// **'Opportunity Price : '**
  String get opportunityPrice;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price : '**
  String get totalPrice;

  /// No description provided for @theverificationcodehasbeensenttthenumberendingwith.
  ///
  /// In en, this message translates to:
  /// **'The verification code has been sent to the number ending with'**
  String get theverificationcodehasbeensenttthenumberendingwith;

  /// No description provided for @confirmPhone.
  ///
  /// In en, this message translates to:
  /// **'Confirm Phone Number'**
  String get confirmPhone;

  /// No description provided for @didntreceivetheverificationcode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the verification code?'**
  String get didntreceivetheverificationcode;

  /// No description provided for @resendverificationcode.
  ///
  /// In en, this message translates to:
  /// **'Resend verification code'**
  String get resendverificationcode;

  /// No description provided for @pleaseentertheactivationcode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the activation code'**
  String get pleaseentertheactivationcode;

  /// No description provided for @theactivationcodehasbeenresentsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'The activation code has been resent successfully'**
  String get theactivationcodehasbeenresentsuccessfully;

  /// No description provided for @loginusingyourmobilenumber.
  ///
  /// In en, this message translates to:
  /// **'Log in using your mobile number'**
  String get loginusingyourmobilenumber;

  /// No description provided for @thephonenumberisincorrectoralreadyinuse.
  ///
  /// In en, this message translates to:
  /// **'The phone number is incorrect or already in use'**
  String get thephonenumberisincorrectoralreadyinuse;

  /// No description provided for @pleaseenteravalidemailaddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseenteravalidemailaddress;

  /// No description provided for @accDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accDeletedSuccess;

  /// No description provided for @areyousureyouwanttodeleteAcc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the account? Please note that deleting the account will remove all data and previous orders'**
  String get areyousureyouwanttodeleteAcc;

  /// No description provided for @pleaseenterthepassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter the password.'**
  String get pleaseenterthepassword;

  /// No description provided for @passwordsdonotmatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsdonotmatch;

  /// No description provided for @pleaseconfirmthepassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm the password.'**
  String get pleaseconfirmthepassword;

  /// No description provided for @uploadPayMentRecipt.
  ///
  /// In en, this message translates to:
  /// **'Upload PayMent Reciept'**
  String get uploadPayMentRecipt;

  /// No description provided for @amountWasntSelected.
  ///
  /// In en, this message translates to:
  /// **'cost wasn\'t selected yet'**
  String get amountWasntSelected;

  /// No description provided for @fileselectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'File is selected successfully'**
  String get fileselectedSuccess;

  /// No description provided for @nomatchingsearchresults.
  ///
  /// In en, this message translates to:
  /// **'No matching search results'**
  String get nomatchingsearchresults;

  /// No description provided for @pleaseChooseService.
  ///
  /// In en, this message translates to:
  /// **'Please choose service'**
  String get pleaseChooseService;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get service;

  /// No description provided for @productsandservices.
  ///
  /// In en, this message translates to:
  /// **'Products and Services'**
  String get productsandservices;

  /// No description provided for @typeofservice.
  ///
  /// In en, this message translates to:
  /// **'Type of service'**
  String get typeofservice;

  /// No description provided for @failedtoloadservices.
  ///
  /// In en, this message translates to:
  /// **'Failed to load services'**
  String get failedtoloadservices;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @productaddedtocart.
  ///
  /// In en, this message translates to:
  /// **'product added successfully to cart '**
  String get productaddedtocart;

  /// No description provided for @youcanmotaddproductsfromdifferntseller.
  ///
  /// In en, this message translates to:
  /// **'Upon adding this product, the previous store\'s products in the cart will be removed.'**
  String get youcanmotaddproductsfromdifferntseller;

  /// No description provided for @addingtocart.
  ///
  /// In en, this message translates to:
  /// **'Adding to cart....'**
  String get addingtocart;

  /// No description provided for @addtocart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart + '**
  String get addtocart;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @totalcost.
  ///
  /// In en, this message translates to:
  /// **'Total cost'**
  String get totalcost;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get productDetails;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get category;

  /// No description provided for @enterCategory.
  ///
  /// In en, this message translates to:
  /// **' Enter category '**
  String get enterCategory;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAll;

  /// No description provided for @betSeller.
  ///
  /// In en, this message translates to:
  /// **'Best seller'**
  String get betSeller;

  /// No description provided for @visitStore.
  ///
  /// In en, this message translates to:
  /// **'Show store '**
  String get visitStore;

  /// No description provided for @thanksfororderFrom.
  ///
  /// In en, this message translates to:
  /// **'Thanks For Order From Store of '**
  String get thanksfororderFrom;

  /// No description provided for @coupon.
  ///
  /// In en, this message translates to:
  /// **'Coupon'**
  String get coupon;

  /// No description provided for @orderList.
  ///
  /// In en, this message translates to:
  /// **'Orders List'**
  String get orderList;

  /// No description provided for @confirmRequest.
  ///
  /// In en, this message translates to:
  /// **'Request is confirmed successfully '**
  String get confirmRequest;

  /// No description provided for @productType.
  ///
  /// In en, this message translates to:
  /// **'product type'**
  String get productType;

  /// No description provided for @extra.
  ///
  /// In en, this message translates to:
  /// **'Delivery cost'**
  String get extra;

  /// No description provided for @theselectedcodeisinvalid.
  ///
  /// In en, this message translates to:
  /// **'The selected code is invalid'**
  String get theselectedcodeisinvalid;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'try another code'**
  String get retry;

  /// No description provided for @realestateorders.
  ///
  /// In en, this message translates to:
  /// **'Real Estate'**
  String get realestateorders;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @noordernumber.
  ///
  /// In en, this message translates to:
  /// **'No order Number'**
  String get noordernumber;

  /// No description provided for @discountMessage.
  ///
  /// In en, this message translates to:
  /// **'Discount done ☑ '**
  String get discountMessage;

  /// No description provided for @cartisEmpty.
  ///
  /// In en, this message translates to:
  /// **'cart is empty'**
  String get cartisEmpty;

  /// No description provided for @sortingUnite.
  ///
  /// In en, this message translates to:
  /// **'Sorting Units'**
  String get sortingUnite;

  /// No description provided for @enterUnitNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter the number of units'**
  String get enterUnitNumber;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @deliveryInformation.
  ///
  /// In en, this message translates to:
  /// **'Delivery Information'**
  String get deliveryInformation;

  /// No description provided for @independentTitleDeedforEachUnit.
  ///
  /// In en, this message translates to:
  /// **'(Independent Title Deed for Each Unit)'**
  String get independentTitleDeedforEachUnit;

  /// No description provided for @ireadTermsandiagreeit.
  ///
  /// In en, this message translates to:
  /// **'I have read the terms and conditions and agree to them'**
  String get ireadTermsandiagreeit;

  /// No description provided for @theagemustbemorethan18years.
  ///
  /// In en, this message translates to:
  /// **'Your age must be 18 years or older'**
  String get theagemustbemorethan18years;

  /// No description provided for @cartisEmptyYouCannotpay.
  ///
  /// In en, this message translates to:
  /// **'cart is empty you can\'t go to payment'**
  String get cartisEmptyYouCannotpay;

  /// No description provided for @erroInPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment was not successful. Please try again'**
  String get erroInPayment;

  /// No description provided for @noamount.
  ///
  /// In en, this message translates to:
  /// **'The number of units required is greater than the number available'**
  String get noamount;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @service_not_found.
  ///
  /// In en, this message translates to:
  /// **'The service is currently unavailable'**
  String get service_not_found;

  /// No description provided for @policy.
  ///
  String get show_details;


  String get policy;
  String get privacy;
  String get conditionsWarning;
  String get support;
  String get support_time;
  String get whatsapp_contact;
  String get common_questions;
  String get x;
  String get call;

  String get q1;
  String get a1;
  String get q2;
  String get a2;
  String get q3;
  String get a3;
  String get q4;
  String get a4;
  String get q5;
  String get a5;
  String get q6;
  String get a6;
  String get q7;
  String get a7;
  String get q8;
  String get a8;
  String get contact_via_whatsapp;
  String get license_number;
  String get support_and_assist;
  String get message_title;
  String get message;

  String get contact_times;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
