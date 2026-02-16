// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get enter {
    return Intl.message(
      'Enter',
      name: 'enter',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get doNotHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'doNotHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get createAccount {
    return Intl.message(
      'Create account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during login`
  String get loginError {
    return Intl.message(
      'An error occurred during login',
      name: 'loginError',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Choose Image`
  String get chooseImage {
    return Intl.message(
      'Choose Image',
      name: 'chooseImage',
      desc: '',
      args: [],
    );
  }

  /// `Have an account?`
  String get haveAccount {
    return Intl.message(
      'Have an account?',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editFile {
    return Intl.message(
      'Edit Profile',
      name: 'editFile',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message(
      'Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message(
      'About Us',
      name: 'aboutUs',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get termsConditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'termsConditions',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get deleteAccount {
    return Intl.message(
      'Delete account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Calculator and Projects`
  String get calculatorProjects {
    return Intl.message(
      'Calculator and Projects',
      name: 'calculatorProjects',
      desc: '',
      args: [],
    );
  }

  /// `Approximate cost details and fees:`
  String get approximateCostDetails {
    return Intl.message(
      'Approximate cost details and fees:',
      name: 'approximateCostDetails',
      desc: '',
      args: [],
    );
  }

  /// `Construction + Consultation + Plans + Insurance + Fence and tank works + Sanitation + Excavation and backfilling + Removal and transport. All products used are of high quality with necessary guarantees provided.`
  String get constructionConsultationPlansInsurance {
    return Intl.message(
      'Construction + Consultation + Plans + Insurance + Fence and tank works + Sanitation + Excavation and backfilling + Removal and transport. All products used are of high quality with necessary guarantees provided.',
      name: 'constructionConsultationPlansInsurance',
      desc: '',
      args: [],
    );
  }

  /// `Plans and Designs`
  String get plansDesigns {
    return Intl.message(
      'Plans and Designs',
      name: 'plansDesigns',
      desc: '',
      args: [],
    );
  }

  /// `Success Partners`
  String get successPartners {
    return Intl.message(
      'Success Partners',
      name: 'successPartners',
      desc: '',
      args: [],
    );
  }

  /// `Total Land Area`
  String get totalLandArea {
    return Intl.message(
      'Total Land Area',
      name: 'totalLandArea',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the total area`
  String get pleaseEnterTotalArea {
    return Intl.message(
      'Please enter the total area',
      name: 'pleaseEnterTotalArea',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred, please try again`
  String get errorPleaseTryAgain {
    return Intl.message(
      'An error occurred, please try again',
      name: 'errorPleaseTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the required information`
  String get pleaseEnterRequiredInformation {
    return Intl.message(
      'Please enter the required information',
      name: 'pleaseEnterRequiredInformation',
      desc: '',
      args: [],
    );
  }

  /// `Building Mechanism`
  String get buildingMechanism {
    return Intl.message(
      'Building Mechanism',
      name: 'buildingMechanism',
      desc: '',
      args: [],
    );
  }

  /// `Choose Building Mechanism`
  String get choosebuildingMechanism {
    return Intl.message(
      'Choose Building Mechanism',
      name: 'choosebuildingMechanism',
      desc: '',
      args: [],
    );
  }

  /// `Choose Type`
  String get chooseType {
    return Intl.message(
      'Choose Type',
      name: 'chooseType',
      desc: '',
      args: [],
    );
  }

  /// `Residential Complex`
  String get residentialComplex {
    return Intl.message(
      'Residential Complex',
      name: 'residentialComplex',
      desc: '',
      args: [],
    );
  }

  /// `Number of Floors`
  String get numberOfFloors {
    return Intl.message(
      'Number of Floors',
      name: 'numberOfFloors',
      desc: '',
      args: [],
    );
  }

  /// `Enter Number of Floors`
  String get enterNumberOfFloors {
    return Intl.message(
      'Enter Number of Floors',
      name: 'enterNumberOfFloors',
      desc: '',
      args: [],
    );
  }

  /// `Number of Apartments`
  String get numberOfApartments {
    return Intl.message(
      'Number of Apartments',
      name: 'numberOfApartments',
      desc: '',
      args: [],
    );
  }

  /// `Enter Number of Apartments`
  String get enterNumberOfApartments {
    return Intl.message(
      'Enter Number of Apartments',
      name: 'enterNumberOfApartments',
      desc: '',
      args: [],
    );
  }

  /// `Request sent successfully`
  String get requestSentSuccessfully {
    return Intl.message(
      'Request sent successfully',
      name: 'requestSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `The request will be reviewed soon, you can check the notifications`
  String get requestWillBeReviewed {
    return Intl.message(
      'The request will be reviewed soon, you can check the notifications',
      name: 'requestWillBeReviewed',
      desc: '',
      args: [],
    );
  }

  /// `Electronic Deed *`
  String get electronicDeed {
    return Intl.message(
      'Electronic Deed *',
      name: 'electronicDeed',
      desc: '',
      args: [],
    );
  }

  /// `Add Soil Test Report `
  String get addSoilTestReport {
    return Intl.message(
      'Add Soil Test Report ',
      name: 'addSoilTestReport',
      desc: '',
      args: [],
    );
  }

  /// `If not available, there will be an additional cost of 2000 SAR`
  String get additionalCostIfNotAvailable {
    return Intl.message(
      'If not available, there will be an additional cost of 2000 SAR',
      name: 'additionalCostIfNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Property Location`
  String get propertyLocation {
    return Intl.message(
      'Property Location',
      name: 'propertyLocation',
      desc: '',
      args: [],
    );
  }

  /// `Or enter the site link`
  String get enterSiteLink {
    return Intl.message(
      'Or enter the site link',
      name: 'enterSiteLink',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Request`
  String get cancelRequest {
    return Intl.message(
      'Cancel Request',
      name: 'cancelRequest',
      desc: '',
      args: [],
    );
  }

  /// `Reply sent successfully`
  String get replySentSuccessfully {
    return Intl.message(
      'Reply sent successfully',
      name: 'replySentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `You will receive a notification about payment`
  String get paymentNotification {
    return Intl.message(
      'You will receive a notification about payment',
      name: 'paymentNotification',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `The request will be canceled, are you sure you want to cancel?`
  String get cancelRequestConfirmation {
    return Intl.message(
      'The request will be canceled, are you sure you want to cancel?',
      name: 'cancelRequestConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get reject {
    return Intl.message(
      'Reject',
      name: 'reject',
      desc: '',
      args: [],
    );
  }

  /// `Type of Building`
  String get typeOfBuilding {
    return Intl.message(
      'Type of Building',
      name: 'typeOfBuilding',
      desc: '',
      args: [],
    );
  }

  /// `Total Cost of the Project`
  String get totalProjectCost {
    return Intl.message(
      'Total Cost of the Project',
      name: 'totalProjectCost',
      desc: '',
      args: [],
    );
  }

  /// `Agree to `
  String get agreeToTermsAndConditions {
    return Intl.message(
      'Agree to ',
      name: 'agreeToTermsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Please choose the design or plan`
  String get pleaseChooseDesignOrPlan {
    return Intl.message(
      'Please choose the design or plan',
      name: 'pleaseChooseDesignOrPlan',
      desc: '',
      args: [],
    );
  }

  /// `Other details or information`
  String get otherDetailsOrInformation {
    return Intl.message(
      'Other details or information',
      name: 'otherDetailsOrInformation',
      desc: '',
      args: [],
    );
  }

  /// `Please write any other details`
  String get pleaseWriteOtherDetails {
    return Intl.message(
      'Please write any other details',
      name: 'pleaseWriteOtherDetails',
      desc: '',
      args: [],
    );
  }

  /// `Enter request number`
  String get enterRequestNumber {
    return Intl.message(
      'Enter request number',
      name: 'enterRequestNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please choose request number`
  String get pleaseChooseRequestNumber {
    return Intl.message(
      'Please choose request number',
      name: 'pleaseChooseRequestNumber',
      desc: '',
      args: [],
    );
  }

  /// `Submit request`
  String get submitRequest {
    return Intl.message(
      'Submit request',
      name: 'submitRequest',
      desc: '',
      args: [],
    );
  }

  /// `No requests`
  String get noRequests {
    return Intl.message(
      'No requests',
      name: 'noRequests',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Plans`
  String get plans {
    return Intl.message(
      'Plans',
      name: 'plans',
      desc: '',
      args: [],
    );
  }

  /// `Designs`
  String get designs {
    return Intl.message(
      'Designs',
      name: 'designs',
      desc: '',
      args: [],
    );
  }

  /// `Custom Plans and Designs`
  String get customPlansAndDesigns {
    return Intl.message(
      'Custom Plans and Designs',
      name: 'customPlansAndDesigns',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during loading, please try again`
  String get loadingError {
    return Intl.message(
      'An error occurred during loading, please try again',
      name: 'loadingError',
      desc: '',
      args: [],
    );
  }

  /// `No notifications`
  String get noNotifications {
    return Intl.message(
      'No notifications',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Expires in 3 days`
  String get expiresIn3Days {
    return Intl.message(
      'Expires in 3 days',
      name: 'expiresIn3Days',
      desc: '',
      args: [],
    );
  }

  /// `Attach Transfer Receipt`
  String get attachTransferReceipt {
    return Intl.message(
      'Attach Transfer Receipt',
      name: 'attachTransferReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Ahmed Abdullah`
  String get ahmedAbdullah {
    return Intl.message(
      'Ahmed Abdullah',
      name: 'ahmedAbdullah',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get enterYourName {
    return Intl.message(
      'Enter your name',
      name: 'enterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter phone number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter email`
  String get enterEmail {
    return Intl.message(
      'Enter email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `SAR`
  String get sar {
    return Intl.message(
      'SAR',
      name: 'sar',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Order Number`
  String get orderNumber {
    return Intl.message(
      'Order Number',
      name: 'orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `RCT`
  String get page1Title {
    return Intl.message(
      'RCT',
      name: 'page1Title',
      desc: '',
      args: [],
    );
  }

  /// `We build your dreams and turn them into reality`
  String get page1Description {
    return Intl.message(
      'We build your dreams and turn them into reality',
      name: 'page1Description',
      desc: '',
      args: [],
    );
  }

  /// `Rent now and own later`
  String get page2Title {
    return Intl.message(
      'Rent now and own later',
      name: 'page2Title',
      desc: '',
      args: [],
    );
  }

  /// `Without interest and without hidden fees`
  String get page2Description {
    return Intl.message(
      'Without interest and without hidden fees',
      name: 'page2Description',
      desc: '',
      args: [],
    );
  }

  /// `Join RCT`
  String get page3Title {
    return Intl.message(
      'Join RCT',
      name: 'page3Title',
      desc: '',
      args: [],
    );
  }

  /// `Achieve long-term profits without risks`
  String get page3Description {
    return Intl.message(
      'Achieve long-term profits without risks',
      name: 'page3Description',
      desc: '',
      args: [],
    );
  }

  /// `Real estate offers`
  String get page4Title {
    return Intl.message(
      'Real estate offers',
      name: 'page4Title',
      desc: '',
      args: [],
    );
  }

  /// `Browse exclusive real estate offers`
  String get page4Description {
    return Intl.message(
      'Browse exclusive real estate offers',
      name: 'page4Description',
      desc: '',
      args: [],
    );
  }

  /// `Calculator & Construction`
  String get page5Title {
    return Intl.message(
      'Calculator & Construction',
      name: 'page5Title',
      desc: '',
      args: [],
    );
  }

  /// `The app provides a full cost calculation, enabling users to choose the most suitable offer`
  String get page5Description {
    return Intl.message(
      'The app provides a full cost calculation, enabling users to choose the most suitable offer',
      name: 'page5Description',
      desc: '',
      args: [],
    );
  }

  /// `Designs & Services`
  String get page6Title {
    return Intl.message(
      'Designs & Services',
      name: 'page6Title',
      desc: '',
      args: [],
    );
  }

  /// `A single app that brings you the best real estate and construction solutions with flexibility and ease`
  String get page6Description {
    return Intl.message(
      'A single app that brings you the best real estate and construction solutions with flexibility and ease',
      name: 'page6Description',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Is there a soil test report?`
  String get landcheck {
    return Intl.message(
      'Is there a soil test report?',
      name: 'landcheck',
      desc: '',
      args: [],
    );
  }

  /// `Real Estate Offers`
  String get realestate {
    return Intl.message(
      'Real Estate Offers',
      name: 'realestate',
      desc: '',
      args: [],
    );
  }

  /// `Please complete sections`
  String get completeMessage {
    return Intl.message(
      'Please complete sections',
      name: 'completeMessage',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `District`
  String get district {
    return Intl.message(
      'District',
      name: 'district',
      desc: '',
      args: [],
    );
  }

  /// `Enter district name`
  String get enterDistrict {
    return Intl.message(
      'Enter district name',
      name: 'enterDistrict',
      desc: '',
      args: [],
    );
  }

  /// ` Choose City`
  String get chooseCity {
    return Intl.message(
      ' Choose City',
      name: 'chooseCity',
      desc: '',
      args: [],
    );
  }

  /// `Filtering`
  String get filter {
    return Intl.message(
      'Filtering',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Main Photo `
  String get mainPhoto {
    return Intl.message(
      'Main Photo ',
      name: 'mainPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Section Photos `
  String get sectionPhotos {
    return Intl.message(
      'Section Photos ',
      name: 'sectionPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Add Estate `
  String get addEstate {
    return Intl.message(
      'Add Estate ',
      name: 'addEstate',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Write a summary about Estate `
  String get estateSummary {
    return Intl.message(
      'Write a summary about Estate ',
      name: 'estateSummary',
      desc: '',
      args: [],
    );
  }

  /// `Estate Type `
  String get estateType {
    return Intl.message(
      'Estate Type ',
      name: 'estateType',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Space`
  String get space {
    return Intl.message(
      'Space',
      name: 'space',
      desc: '',
      args: [],
    );
  }

  /// `Residential`
  String get residential {
    return Intl.message(
      'Residential',
      name: 'residential',
      desc: '',
      args: [],
    );
  }

  /// `Commercial`
  String get commercial {
    return Intl.message(
      'Commercial',
      name: 'commercial',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get discreption {
    return Intl.message(
      'Description',
      name: 'discreption',
      desc: '',
      args: [],
    );
  }

  /// `ReFilter`
  String get refilter {
    return Intl.message(
      'ReFilter',
      name: 'refilter',
      desc: '',
      args: [],
    );
  }

  /// `Don't Found`
  String get dontFound {
    return Intl.message(
      'Don\'t Found',
      name: 'dontFound',
      desc: '',
      args: [],
    );
  }

  /// `House Name`
  String get estateName {
    return Intl.message(
      'House Name',
      name: 'estateName',
      desc: '',
      args: [],
    );
  }

  /// `Collaboration and Development`
  String get cooperationAndPartnership {
    return Intl.message(
      'Collaboration and Development',
      name: 'cooperationAndPartnership',
      desc: '',
      args: [],
    );
  }

  /// ` Complete Request`
  String get completeRequest {
    return Intl.message(
      ' Complete Request',
      name: 'completeRequest',
      desc: '',
      args: [],
    );
  }

  /// `Real Estate Orders`
  String get realEstateOrders {
    return Intl.message(
      'Real Estate Orders',
      name: 'realEstateOrders',
      desc: '',
      args: [],
    );
  }

  /// `Calculator and Projects Orders`
  String get calculatorAndProjectsOrders {
    return Intl.message(
      'Calculator and Projects Orders',
      name: 'calculatorAndProjectsOrders',
      desc: '',
      args: [],
    );
  }

  /// `Old Buildings Orders`
  String get oldBuildingsOrders {
    return Intl.message(
      'Old Buildings Orders',
      name: 'oldBuildingsOrders',
      desc: '',
      args: [],
    );
  }

  /// `RawLands Orders`
  String get rawLandsOrders {
    return Intl.message(
      'RawLands Orders',
      name: 'rawLandsOrders',
      desc: '',
      args: [],
    );
  }

  /// ` schema Orders`
  String get schemaOrders {
    return Intl.message(
      ' schema Orders',
      name: 'schemaOrders',
      desc: '',
      args: [],
    );
  }

  /// `Move to payment`
  String get payment {
    return Intl.message(
      'Move to payment',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Location`
  String get confirmlocation {
    return Intl.message(
      'Confirm Location',
      name: 'confirmlocation',
      desc: '',
      args: [],
    );
  }

  /// `Add Pool`
  String get addpool {
    return Intl.message(
      'Add Pool',
      name: 'addpool',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favourite {
    return Intl.message(
      'Favorites',
      name: 'favourite',
      desc: '',
      args: [],
    );
  }

  /// `Chances`
  String get chances {
    return Intl.message(
      'Chances',
      name: 'chances',
      desc: '',
      args: [],
    );
  }

  /// `Property`
  String get presentestate {
    return Intl.message(
      'Property',
      name: 'presentestate',
      desc: '',
      args: [],
    );
  }

  /// `Raw Land`
  String get rowland {
    return Intl.message(
      'Raw Land',
      name: 'rowland',
      desc: '',
      args: [],
    );
  }

  /// `Join RCT`
  String get joinRCT {
    return Intl.message(
      'Join RCT',
      name: 'joinRCT',
      desc: '',
      args: [],
    );
  }

  /// `Choose Building Type`
  String get choosebuidingType {
    return Intl.message(
      'Choose Building Type',
      name: 'choosebuidingType',
      desc: '',
      args: [],
    );
  }

  /// `Birth Date`
  String get birthDate {
    return Intl.message(
      'Birth Date',
      name: 'birthDate',
      desc: '',
      args: [],
    );
  }

  /// `Commercial Registry`
  String get commercialRegister {
    return Intl.message(
      'Commercial Registry',
      name: 'commercialRegister',
      desc: '',
      args: [],
    );
  }

  /// `Old Buildings`
  String get oldBuildings {
    return Intl.message(
      'Old Buildings',
      name: 'oldBuildings',
      desc: '',
      args: [],
    );
  }

  /// `Plans`
  String get sketches {
    return Intl.message(
      'Plans',
      name: 'sketches',
      desc: '',
      args: [],
    );
  }

  /// `Please log in`
  String get pleaselogin {
    return Intl.message(
      'Please log in',
      name: 'pleaselogin',
      desc: '',
      args: [],
    );
  }

  /// `Please contact the RCT team to complete your request.`
  String get pleasecontacttheRCTteam {
    return Intl.message(
      'Please contact the RCT team to complete your request.',
      name: 'pleasecontacttheRCTteam',
      desc: '',
      args: [],
    );
  }

  /// `Please Select Building Type`
  String get pleaseSelectBuilingType {
    return Intl.message(
      'Please Select Building Type',
      name: 'pleaseSelectBuilingType',
      desc: '',
      args: [],
    );
  }

  /// `to contact via whatsapp`
  String get tocontactviaWhatsApp {
    return Intl.message(
      'to contact via whatsapp',
      name: 'tocontactviaWhatsApp',
      desc: '',
      args: [],
    );
  }

  /// `Building`
  String get building {
    return Intl.message(
      'Building',
      name: 'building',
      desc: '',
      args: [],
    );
  }

  /// `Villa`
  String get villa {
    return Intl.message(
      'Villa',
      name: 'villa',
      desc: '',
      args: [],
    );
  }

  /// `Complex`
  String get complex {
    return Intl.message(
      'Complex',
      name: 'complex',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get alert {
    return Intl.message(
      'Alert',
      name: 'alert',
      desc: '',
      args: [],
    );
  }

  /// `ID Number`
  String get iDNumber {
    return Intl.message(
      'ID Number',
      name: 'iDNumber',
      desc: '',
      args: [],
    );
  }

  /// `National ID`
  String get nationalID {
    return Intl.message(
      'National ID',
      name: 'nationalID',
      desc: '',
      args: [],
    );
  }

  /// `Please upload the National ID or Commercial registry`
  String get uploadNationalIdOrCommercialRegister {
    return Intl.message(
      'Please upload the National ID or Commercial registry',
      name: 'uploadNationalIdOrCommercialRegister',
      desc: '',
      args: [],
    );
  }

  /// `Please upload the Commercial Registery`
  String get uploadCommercialRegister {
    return Intl.message(
      'Please upload the Commercial Registery',
      name: 'uploadCommercialRegister',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the birth date`
  String get enterBirthDate {
    return Intl.message(
      'Please enter the birth date',
      name: 'enterBirthDate',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the ID Number`
  String get enterNationalId {
    return Intl.message(
      'Please enter the ID Number',
      name: 'enterNationalId',
      desc: '',
      args: [],
    );
  }

  /// `The National ID must be at least 10 digits`
  String get nationalIdMustBeAtLeast10 {
    return Intl.message(
      'The National ID must be at least 10 digits',
      name: 'nationalIdMustBeAtLeast10',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm the location`
  String get confirmLocation {
    return Intl.message(
      'Please confirm the location',
      name: 'confirmLocation',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `One street`
  String get oneStreetFencePercentage {
    return Intl.message(
      'One street',
      name: 'oneStreetFencePercentage',
      desc: '',
      args: [],
    );
  }

  /// `Two streets`
  String get twoStreetsFencePercentage {
    return Intl.message(
      'Two streets',
      name: 'twoStreetsFencePercentage',
      desc: '',
      args: [],
    );
  }

  /// `Three streets`
  String get threeStreetsFencePercentage {
    return Intl.message(
      'Three streets',
      name: 'threeStreetsFencePercentage',
      desc: '',
      args: [],
    );
  }

  /// `Four streets`
  String get fourStreetsFencePercentage {
    return Intl.message(
      'Four streets',
      name: 'fourStreetsFencePercentage',
      desc: '',
      args: [],
    );
  }

  /// `Decorative facade`
  String get decorativeFacade {
    return Intl.message(
      'Decorative facade',
      name: 'decorativeFacade',
      desc: '',
      args: [],
    );
  }

  /// `Stone facade`
  String get stoneFacade {
    return Intl.message(
      'Stone facade',
      name: 'stoneFacade',
      desc: '',
      args: [],
    );
  }

  /// `Two stone facades`
  String get twoStoneFacades {
    return Intl.message(
      'Two stone facades',
      name: 'twoStoneFacades',
      desc: '',
      args: [],
    );
  }

  /// `Three stone facades`
  String get threeStoneFacades {
    return Intl.message(
      'Three stone facades',
      name: 'threeStoneFacades',
      desc: '',
      args: [],
    );
  }

  /// `Four stone facades`
  String get fourStoneFacades {
    return Intl.message(
      'Four stone facades',
      name: 'fourStoneFacades',
      desc: '',
      args: [],
    );
  }

  /// `First floor area`
  String get firstFloorArea {
    return Intl.message(
      'First floor area',
      name: 'firstFloorArea',
      desc: '',
      args: [],
    );
  }

  /// `Repeated floors area`
  String get repeatedFloorsArea {
    return Intl.message(
      'Repeated floors area',
      name: 'repeatedFloorsArea',
      desc: '',
      args: [],
    );
  }

  /// `Annex area`
  String get annexArea {
    return Intl.message(
      'Annex area',
      name: 'annexArea',
      desc: '',
      args: [],
    );
  }

  /// `No Stone`
  String get noStone {
    return Intl.message(
      'No Stone',
      name: 'noStone',
      desc: '',
      args: [],
    );
  }

  /// `Exterior finishing`
  String get exteriorfinishing {
    return Intl.message(
      'Exterior finishing',
      name: 'exteriorfinishing',
      desc: '',
      args: [],
    );
  }

  /// `Land details`
  String get landdetails {
    return Intl.message(
      'Land details',
      name: 'landdetails',
      desc: '',
      args: [],
    );
  }

  /// `Building details`
  String get buildingdetails {
    return Intl.message(
      'Building details',
      name: 'buildingdetails',
      desc: '',
      args: [],
    );
  }

  /// `Exterior Finishing`
  String get exteriorFinishing {
    return Intl.message(
      'Exterior Finishing',
      name: 'exteriorFinishing',
      desc: '',
      args: [],
    );
  }

  /// `Land Details`
  String get landDetails {
    return Intl.message(
      'Land Details',
      name: 'landDetails',
      desc: '',
      args: [],
    );
  }

  /// `Building Details`
  String get buildingDetails {
    return Intl.message(
      'Building Details',
      name: 'buildingDetails',
      desc: '',
      args: [],
    );
  }

  /// `Water Tank`
  String get waterTank {
    return Intl.message(
      'Water Tank',
      name: 'waterTank',
      desc: '',
      args: [],
    );
  }

  /// `Sewage Tank`
  String get sewageTank {
    return Intl.message(
      'Sewage Tank',
      name: 'sewageTank',
      desc: '',
      args: [],
    );
  }

  /// `Fence`
  String get fence {
    return Intl.message(
      'Fence',
      name: 'fence',
      desc: '',
      args: [],
    );
  }

  /// `Inverted Beams`
  String get invertedBeams {
    return Intl.message(
      'Inverted Beams',
      name: 'invertedBeams',
      desc: '',
      args: [],
    );
  }

  /// `Swimming Pool`
  String get swimmingPool {
    return Intl.message(
      'Swimming Pool',
      name: 'swimmingPool',
      desc: '',
      args: [],
    );
  }

  /// `Soil Testing`
  String get soilTesting {
    return Intl.message(
      'Soil Testing',
      name: 'soilTesting',
      desc: '',
      args: [],
    );
  }

  /// `Floor Area`
  String get floorArea {
    return Intl.message(
      'Floor Area',
      name: 'floorArea',
      desc: '',
      args: [],
    );
  }

  /// `Total Building Area`
  String get totalBuildingArea {
    return Intl.message(
      'Total Building Area',
      name: 'totalBuildingArea',
      desc: '',
      args: [],
    );
  }

  /// `Excavation and Backfill Charges`
  String get excavationandBackfillCharges {
    return Intl.message(
      'Excavation and Backfill Charges',
      name: 'excavationandBackfillCharges',
      desc: '',
      args: [],
    );
  }

  /// `No real estate listing matches the search.`
  String get norealestatelistingmatchesthesearch {
    return Intl.message(
      'No real estate listing matches the search.',
      name: 'norealestatelistingmatchesthesearch',
      desc: '',
      args: [],
    );
  }

  /// `Account created successfully.`
  String get registerSuccess {
    return Intl.message(
      'Account created successfully.',
      name: 'registerSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number.`
  String get pleaseenteravalidphonenumber {
    return Intl.message(
      'Please enter a valid phone number.',
      name: 'pleaseenteravalidphonenumber',
      desc: '',
      args: [],
    );
  }

  /// `Riyadh`
  String get riyadh {
    return Intl.message(
      'Riyadh',
      name: 'riyadh',
      desc: '',
      args: [],
    );
  }

  /// `Jeddah`
  String get jeddah {
    return Intl.message(
      'Jeddah',
      name: 'jeddah',
      desc: '',
      args: [],
    );
  }

  /// `Makkah Al-Mukarramah`
  String get makkahAlMukarramah {
    return Intl.message(
      'Makkah Al-Mukarramah',
      name: 'makkahAlMukarramah',
      desc: '',
      args: [],
    );
  }

  /// `Madinah Al-Munawwarah`
  String get madinahAlMunawwarah {
    return Intl.message(
      'Madinah Al-Munawwarah',
      name: 'madinahAlMunawwarah',
      desc: '',
      args: [],
    );
  }

  /// `Dammam`
  String get dammam {
    return Intl.message(
      'Dammam',
      name: 'dammam',
      desc: '',
      args: [],
    );
  }

  /// `Khobar`
  String get khobar {
    return Intl.message(
      'Khobar',
      name: 'khobar',
      desc: '',
      args: [],
    );
  }

  /// `Al-Ahsa`
  String get alAhsa {
    return Intl.message(
      'Al-Ahsa',
      name: 'alAhsa',
      desc: '',
      args: [],
    );
  }

  /// `Dhahran`
  String get dhahran {
    return Intl.message(
      'Dhahran',
      name: 'dhahran',
      desc: '',
      args: [],
    );
  }

  /// `Qassim`
  String get qassim {
    return Intl.message(
      'Qassim',
      name: 'qassim',
      desc: '',
      args: [],
    );
  }

  /// `Abha`
  String get abha {
    return Intl.message(
      'Abha',
      name: 'abha',
      desc: '',
      args: [],
    );
  }

  /// `Hail`
  String get hail {
    return Intl.message(
      'Hail',
      name: 'hail',
      desc: '',
      args: [],
    );
  }

  /// `Tabuk`
  String get tabuk {
    return Intl.message(
      'Tabuk',
      name: 'tabuk',
      desc: '',
      args: [],
    );
  }

  /// `Al-Jouf`
  String get alJouf {
    return Intl.message(
      'Al-Jouf',
      name: 'alJouf',
      desc: '',
      args: [],
    );
  }

  /// `Gurayat`
  String get gurayat {
    return Intl.message(
      'Gurayat',
      name: 'gurayat',
      desc: '',
      args: [],
    );
  }

  /// `Khamis Mushait`
  String get khamisMushait {
    return Intl.message(
      'Khamis Mushait',
      name: 'khamisMushait',
      desc: '',
      args: [],
    );
  }

  /// `Jazan`
  String get jazan {
    return Intl.message(
      'Jazan',
      name: 'jazan',
      desc: '',
      args: [],
    );
  }

  /// `Najran`
  String get najran {
    return Intl.message(
      'Najran',
      name: 'najran',
      desc: '',
      args: [],
    );
  }

  /// `Yanbu`
  String get yanbu {
    return Intl.message(
      'Yanbu',
      name: 'yanbu',
      desc: '',
      args: [],
    );
  }

  /// `Al-Hofuf`
  String get alHofuf {
    return Intl.message(
      'Al-Hofuf',
      name: 'alHofuf',
      desc: '',
      args: [],
    );
  }

  /// `Qatif`
  String get qatif {
    return Intl.message(
      'Qatif',
      name: 'qatif',
      desc: '',
      args: [],
    );
  }

  /// `Buraydah`
  String get buraydah {
    return Intl.message(
      'Buraydah',
      name: 'buraydah',
      desc: '',
      args: [],
    );
  }

  /// `Unayzah`
  String get unayzah {
    return Intl.message(
      'Unayzah',
      name: 'unayzah',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel the order?`
  String get areyousureyouwanttocanceltheorder {
    return Intl.message(
      'Are you sure you want to cancel the order?',
      name: 'areyousureyouwanttocanceltheorder',
      desc: '',
      args: [],
    );
  }

  /// `Please upload the electronic deed`
  String get pleaseuploadtheelectronicdeed {
    return Intl.message(
      'Please upload the electronic deed',
      name: 'pleaseuploadtheelectronicdeed',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the price`
  String get pleaseentertheprice {
    return Intl.message(
      'Please enter the price',
      name: 'pleaseentertheprice',
      desc: '',
      args: [],
    );
  }

  /// `Please select a city`
  String get pleaseselectacity {
    return Intl.message(
      'Please select a city',
      name: 'pleaseselectacity',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the neighborhood name`
  String get pleaseentertheneighborhoodname {
    return Intl.message(
      'Please enter the neighborhood name',
      name: 'pleaseentertheneighborhoodname',
      desc: '',
      args: [],
    );
  }

  /// `Please select the location via the map or enter the link`
  String get pleaseselectthelocationviathemaporenterthelink {
    return Intl.message(
      'Please select the location via the map or enter the link',
      name: 'pleaseselectthelocationviathemaporenterthelink',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm the location`
  String get pleaseconfirmthelocation {
    return Intl.message(
      'Please confirm the location',
      name: 'pleaseconfirmthelocation',
      desc: '',
      args: [],
    );
  }

  /// `No special`
  String get nospecial {
    return Intl.message(
      'No special',
      name: 'nospecial',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get delete {
    return Intl.message(
      'Remove',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `description`
  String get description {
    return Intl.message(
      'description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Stores`
  String get stores {
    return Intl.message(
      'Stores',
      name: 'stores',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get services {
    return Intl.message(
      'Services',
      name: 'services',
      desc: '',
      args: [],
    );
  }

  /// `The service is currently unavailable`
  String get theserviceiscurrentlyunavailable {
    return Intl.message(
      'The service is currently unavailable',
      name: 'theserviceiscurrentlyunavailable',
      desc: '',
      args: [],
    );
  }

  /// `The order has been successfully deleted`
  String get theorderhasbeensuccessfullydeleted {
    return Intl.message(
      'The order has been successfully deleted',
      name: 'theorderhasbeensuccessfullydeleted',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete the order. Please try again later`
  String get failedtodeletetheorderPleasetryagainlater {
    return Intl.message(
      'Failed to delete the order. Please try again later',
      name: 'failedtodeletetheorderPleasetryagainlater',
      desc: '',
      args: [],
    );
  }

  /// `Deleting...`
  String get deleting {
    return Intl.message(
      'Deleting...',
      name: 'deleting',
      desc: '',
      args: [],
    );
  }

  /// `Cancel order`
  String get canceltheorder {
    return Intl.message(
      'Cancel order',
      name: 'canceltheorder',
      desc: '',
      args: [],
    );
  }

  /// `Please Download File`
  String get pleaseDownloadFile {
    return Intl.message(
      'Please Download File',
      name: 'pleaseDownloadFile',
      desc: '',
      args: [],
    );
  }

  /// `I have read and agree to the terms and conditions.`
  String get ihavereadandagreetothetermsandconditions {
    return Intl.message(
      'I have read and agree to the terms and conditions.',
      name: 'ihavereadandagreetothetermsandconditions',
      desc: '',
      args: [],
    );
  }

  /// `You have rejected the terms and conditions.`
  String get youhaverejectedthetermsandconditions {
    return Intl.message(
      'You have rejected the terms and conditions.',
      name: 'youhaverejectedthetermsandconditions',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred, please try again.`
  String get anerroroccurredpleasetryagain {
    return Intl.message(
      'An error occurred, please try again.',
      name: 'anerroroccurredpleasetryagain',
      desc: '',
      args: [],
    );
  }

  /// `Your response has been successfully submitted. Thank you`
  String get yourresponsehasbeensuccessfully {
    return Intl.message(
      'Your response has been successfully submitted. Thank you',
      name: 'yourresponsehasbeensuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Saving....`
  String get saving {
    return Intl.message(
      'Saving....',
      name: 'saving',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the name matching the ID`
  String get pleaseenterthenamematchingtheID {
    return Intl.message(
      'Please enter the name matching the ID',
      name: 'pleaseenterthenamematchingtheID',
      desc: '',
      args: [],
    );
  }

  /// `Agree to the terms and conditions.`
  String get agreetothetermsandconditions {
    return Intl.message(
      'Agree to the terms and conditions.',
      name: 'agreetothetermsandconditions',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the mobile number`
  String get pleaseenterthephonenumber {
    return Intl.message(
      'Please enter the mobile number',
      name: 'pleaseenterthephonenumber',
      desc: '',
      args: [],
    );
  }

  /// `The opportunity is complete. You cannot complete the request.`
  String get theopportunityiscomplete {
    return Intl.message(
      'The opportunity is complete. You cannot complete the request.',
      name: 'theopportunityiscomplete',
      desc: '',
      args: [],
    );
  }

  /// `Remaining opportunities : `
  String get remainingopportunities {
    return Intl.message(
      'Remaining opportunities : ',
      name: 'remainingopportunities',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Opportunity duration :`
  String get opportunityduration {
    return Intl.message(
      'Opportunity duration :',
      name: 'opportunityduration',
      desc: '',
      args: [],
    );
  }

  /// `Financial revenue : `
  String get financialrevenue {
    return Intl.message(
      'Financial revenue : ',
      name: 'financialrevenue',
      desc: '',
      args: [],
    );
  }

  /// `Opportunity Price : `
  String get opportunityPrice {
    return Intl.message(
      'Opportunity Price : ',
      name: 'opportunityPrice',
      desc: '',
      args: [],
    );
  }

  /// `Total Price : `
  String get totalPrice {
    return Intl.message(
      'Total Price : ',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `The verification code has been sent to the number ending with`
  String get theverificationcodehasbeensenttthenumberendingwith {
    return Intl.message(
      'The verification code has been sent to the number ending with',
      name: 'theverificationcodehasbeensenttthenumberendingwith',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Phone Number`
  String get confirmPhone {
    return Intl.message(
      'Confirm Phone Number',
      name: 'confirmPhone',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the verification code?`
  String get didntreceivetheverificationcode {
    return Intl.message(
      'Didn\'t receive the verification code?',
      name: 'didntreceivetheverificationcode',
      desc: '',
      args: [],
    );
  }

  /// `Resend verification code`
  String get resendverificationcode {
    return Intl.message(
      'Resend verification code',
      name: 'resendverificationcode',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the activation code`
  String get pleaseentertheactivationcode {
    return Intl.message(
      'Please enter the activation code',
      name: 'pleaseentertheactivationcode',
      desc: '',
      args: [],
    );
  }

  /// `The activation code has been resent successfully`
  String get theactivationcodehasbeenresentsuccessfully {
    return Intl.message(
      'The activation code has been resent successfully',
      name: 'theactivationcodehasbeenresentsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Log in using your mobile number`
  String get loginusingyourmobilenumber {
    return Intl.message(
      'Log in using your mobile number',
      name: 'loginusingyourmobilenumber',
      desc: '',
      args: [],
    );
  }

  /// `The phone number is incorrect or already in use`
  String get thephonenumberisincorrectoralreadyinuse {
    return Intl.message(
      'The phone number is incorrect or already in use',
      name: 'thephonenumberisincorrectoralreadyinuse',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get pleaseenteravalidemailaddress {
    return Intl.message(
      'Please enter a valid email address',
      name: 'pleaseenteravalidemailaddress',
      desc: '',
      args: [],
    );
  }

  /// `Account deleted successfully`
  String get accDeletedSuccess {
    return Intl.message(
      'Account deleted successfully',
      name: 'accDeletedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the account? Please note that deleting the account will remove all data and previous orders`
  String get areyousureyouwanttodeleteAcc {
    return Intl.message(
      'Are you sure you want to delete the account? Please note that deleting the account will remove all data and previous orders',
      name: 'areyousureyouwanttodeleteAcc',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the password.`
  String get pleaseenterthepassword {
    return Intl.message(
      'Please enter the password.',
      name: 'pleaseenterthepassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get passwordsdonotmatch {
    return Intl.message(
      'Passwords do not match.',
      name: 'passwordsdonotmatch',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm the password.`
  String get pleaseconfirmthepassword {
    return Intl.message(
      'Please confirm the password.',
      name: 'pleaseconfirmthepassword',
      desc: '',
      args: [],
    );
  }

  /// `cost wasn't selected yet`
  String get amountWasntSelected {
    return Intl.message(
      'cost wasn\'t selected yet',
      name: 'amountWasntSelected',
      desc: '',
      args: [],
    );
  }

  /// `File is selected successfully`
  String get fileselectedSuccess {
    return Intl.message(
      'File is selected successfully',
      name: 'fileselectedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `No matching search results`
  String get nomatchingsearchresults {
    return Intl.message(
      'No matching search results',
      name: 'nomatchingsearchresults',
      desc: '',
      args: [],
    );
  }

  /// `Please choose service`
  String get pleaseChooseService {
    return Intl.message(
      'Please choose service',
      name: 'pleaseChooseService',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get service {
    return Intl.message(
      'Services',
      name: 'service',
      desc: '',
      args: [],
    );
  }

  /// `Products and Services`
  String get productsandservices {
    return Intl.message(
      'Products and Services',
      name: 'productsandservices',
      desc: '',
      args: [],
    );
  }

  /// `Type of service`
  String get typeofservice {
    return Intl.message(
      'Type of service',
      name: 'typeofservice',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load services`
  String get failedtoloadservices {
    return Intl.message(
      'Failed to load services',
      name: 'failedtoloadservices',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `product added successfully to cart `
  String get productaddedtocart {
    return Intl.message(
      'product added successfully to cart ',
      name: 'productaddedtocart',
      desc: '',
      args: [],
    );
  }

  /// `Upon adding this product, the previous store's products in the cart will be removed.`
  String get youcanmotaddproductsfromdifferntseller {
    return Intl.message(
      'Upon adding this product, the previous store\'s products in the cart will be removed.',
      name: 'youcanmotaddproductsfromdifferntseller',
      desc: '',
      args: [],
    );
  }

  /// `Adding to cart....`
  String get addingtocart {
    return Intl.message(
      'Adding to cart....',
      name: 'addingtocart',
      desc: '',
      args: [],
    );
  }

  /// `Add to cart + `
  String get addtocart {
    return Intl.message(
      'Add to cart + ',
      name: 'addtocart',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Tax`
  String get tax {
    return Intl.message(
      'Tax',
      name: 'tax',
      desc: '',
      args: [],
    );
  }

  /// `Total cost`
  String get totalcost {
    return Intl.message(
      'Total cost',
      name: 'totalcost',
      desc: '',
      args: [],
    );
  }

  /// `Product details`
  String get productDetails {
    return Intl.message(
      'Product details',
      name: 'productDetails',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get category {
    return Intl.message(
      'Categories',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// ` Enter category `
  String get enterCategory {
    return Intl.message(
      ' Enter category ',
      name: 'enterCategory',
      desc: '',
      args: [],
    );
  }

  /// `Show all`
  String get showAll {
    return Intl.message(
      'Show all',
      name: 'showAll',
      desc: '',
      args: [],
    );
  }

  /// `Best seller`
  String get betSeller {
    return Intl.message(
      'Best seller',
      name: 'betSeller',
      desc: '',
      args: [],
    );
  }

  /// `Show store `
  String get visitStore {
    return Intl.message(
      'Show store ',
      name: 'visitStore',
      desc: '',
      args: [],
    );
  }

  /// `Thanks For Order From Store of `
  String get thanksfororderFrom {
    return Intl.message(
      'Thanks For Order From Store of ',
      name: 'thanksfororderFrom',
      desc: '',
      args: [],
    );
  }

  /// `Coupon`
  String get coupon {
    return Intl.message(
      'Coupon',
      name: 'coupon',
      desc: '',
      args: [],
    );
  }

  /// `Orders List`
  String get orderList {
    return Intl.message(
      'Orders List',
      name: 'orderList',
      desc: '',
      args: [],
    );
  }

  /// `Request is confirmed successfully `
  String get confirmRequest {
    return Intl.message(
      'Request is confirmed successfully ',
      name: 'confirmRequest',
      desc: '',
      args: [],
    );
  }

  /// `product type`
  String get productType {
    return Intl.message(
      'product type',
      name: 'productType',
      desc: '',
      args: [],
    );
  }

  /// `Delivery cost`
  String get extra {
    return Intl.message(
      'Delivery cost',
      name: 'extra',
      desc: '',
      args: [],
    );
  }

  /// `The selected code is invalid`
  String get theselectedcodeisinvalid {
    return Intl.message(
      'The selected code is invalid',
      name: 'theselectedcodeisinvalid',
      desc: '',
      args: [],
    );
  }

  /// `try another code`
  String get retry {
    return Intl.message(
      'try another code',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Real Estate`
  String get realestateorders {
    return Intl.message(
      'Real Estate',
      name: 'realestateorders',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `No order Number`
  String get noordernumber {
    return Intl.message(
      'No order Number',
      name: 'noordernumber',
      desc: '',
      args: [],
    );
  }

  /// `Discount done ☑ `
  String get discountMessage {
    return Intl.message(
      'Discount done ☑ ',
      name: 'discountMessage',
      desc: '',
      args: [],
    );
  }

  /// `cart is empty`
  String get cartisEmpty {
    return Intl.message(
      'cart is empty',
      name: 'cartisEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Sorting Units`
  String get sortingUnite {
    return Intl.message(
      'Sorting Units',
      name: 'sortingUnite',
      desc: '',
      args: [],
    );
  }

  /// `Enter the number of units`
  String get enterUnitNumber {
    return Intl.message(
      'Enter the number of units',
      name: 'enterUnitNumber',
      desc: '',
      args: [],
    );
  }

  /// `Store`
  String get store {
    return Intl.message(
      'Store',
      name: 'store',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Information`
  String get deliveryInformation {
    return Intl.message(
      'Delivery Information',
      name: 'deliveryInformation',
      desc: '',
      args: [],
    );
  }

  /// `(Independent Title Deed for Each Unit)`
  String get independentTitleDeedforEachUnit {
    return Intl.message(
      '(Independent Title Deed for Each Unit)',
      name: 'independentTitleDeedforEachUnit',
      desc: '',
      args: [],
    );
  }

  /// `I have read the terms and conditions and agree to them`
  String get ireadTermsandiagreeit {
    return Intl.message(
      'I have read the terms and conditions and agree to them',
      name: 'ireadTermsandiagreeit',
      desc: '',
      args: [],
    );
  }

  /// `Your age must be 18 years or older`
  String get theagemustbemorethan18years {
    return Intl.message(
      'Your age must be 18 years or older',
      name: 'theagemustbemorethan18years',
      desc: '',
      args: [],
    );
  }

  /// `cart is empty you can't go to payment`
  String get cartisEmptyYouCannotpay {
    return Intl.message(
      'cart is empty you can\'t go to payment',
      name: 'cartisEmptyYouCannotpay',
      desc: '',
      args: [],
    );
  }

  /// `Payment was not successful. Please try again`
  String get erroInPayment {
    return Intl.message(
      'Payment was not successful. Please try again',
      name: 'erroInPayment',
      desc: '',
      args: [],
    );
  }

  /// `The number of units required is greater than the number available`
  String get noamount {
    return Intl.message(
      'The number of units required is greater than the number available',
      name: 'noamount',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `The service is currently unavailable`
  String get service_not_found {
    return Intl.message(
      'The service is currently unavailable',
      name: 'service_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Show details to the General Authority for Real Estate`
  String get show_details {
    return Intl.message(
      'Show details to the General Authority for Real Estate',
      name: 'show_details',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get support {
    return Intl.message(
      'Contact us',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Service hours: 8 AM – 5 PM\nRequests are processed within 24 working hours.`
  String get support_time {
    return Intl.message(
      'Service hours: 8 AM – 5 PM\nRequests are processed within 24 working hours.',
      name: 'support_time',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp`
  String get whatsapp_contact {
    return Intl.message(
      'WhatsApp',
      name: 'whatsapp_contact',
      desc: '',
      args: [],
    );
  }

  /// `X`
  String get x {
    return Intl.message(
      'X',
      name: 'x',
      desc: '',
      args: [],
    );
  }

  /// `Common Questions`
  String get common_questions {
    return Intl.message(
      'Common Questions',
      name: 'common_questions',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get call {
    return Intl.message(
      'Contact us',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `1. Can I add my property to the app?`
  String get q1 {
    return Intl.message(
      '1. Can I add my property to the app?',
      name: 'q1',
      desc: '',
      args: [],
    );
  }

  /// `No, as the properties implemented by the application are displayed exclusively or the properties of partners.`
  String get a1 {
    return Intl.message(
      'No, as the properties implemented by the application are displayed exclusively or the properties of partners.',
      name: 'a1',
      desc: '',
      args: [],
    );
  }

  /// `2. Does the app offer ready-to-view and select properties?`
  String get q2 {
    return Intl.message(
      '2. Does the app offer ready-to-view and select properties?',
      name: 'q2',
      desc: '',
      args: [],
    );
  }

  /// `Yes, the app includes real estate listings for sale and rent that are continuously updated by our team.`
  String get a2 {
    return Intl.message(
      'Yes, the app includes real estate listings for sale and rent that are continuously updated by our team.',
      name: 'a2',
      desc: '',
      args: [],
    );
  }

  /// `3. What is the Project and Construction Calculator service?`
  String get q3 {
    return Intl.message(
      '3. What is the Project and Construction Calculator service?',
      name: 'q3',
      desc: '',
      args: [],
    );
  }

  /// `It’s a smart tool that helps you estimate project costs and construction plans to simplify the planning process.`
  String get a3 {
    return Intl.message(
      'It’s a smart tool that helps you estimate project costs and construction plans to simplify the planning process.',
      name: 'a3',
      desc: '',
      args: [],
    );
  }

  /// `4. Can I participate in partnerships or investment opportunities?`
  String get q4 {
    return Intl.message(
      '4. Can I participate in partnerships or investment opportunities?',
      name: 'q4',
      desc: '',
      args: [],
    );
  }

  /// `Yes, the app provides investment and real estate partnership opportunities in collaboration with our market partners.`
  String get a4 {
    return Intl.message(
      'Yes, the app provides investment and real estate partnership opportunities in collaboration with our market partners.',
      name: 'a4',
      desc: '',
      args: [],
    );
  }

  /// `5. Can I choose or upload a plan and design through the app?`
  String get q5 {
    return Intl.message(
      '5. Can I choose or upload a plan and design through the app?',
      name: 'q5',
      desc: '',
      args: [],
    );
  }

  /// `Yes, you can select a ready-made plan or design from within the app, or upload your own custom plan and design.`
  String get a5 {
    return Intl.message(
      'Yes, you can select a ready-made plan or design from within the app, or upload your own custom plan and design.',
      name: 'a5',
      desc: '',
      args: [],
    );
  }

  /// `6. Is the app available in two languages?`
  String get q6 {
    return Intl.message(
      '6. Is the app available in two languages?',
      name: 'q6',
      desc: '',
      args: [],
    );
  }

  /// `Yes, the app supports both Arabic and English to suit different users.`
  String get a6 {
    return Intl.message(
      'Yes, the app supports both Arabic and English to suit different users.',
      name: 'a6',
      desc: '',
      args: [],
    );
  }

  /// `7. Are the property details I see safe and reliable?`
  String get q7 {
    return Intl.message(
      '7. Are the property details I see safe and reliable?',
      name: 'q7',
      desc: '',
      args: [],
    );
  }

  /// `Yes, all data is entered by our team according to clear policies that ensure reliability and transparency.`
  String get a7 {
    return Intl.message(
      'Yes, all data is entered by our team according to clear policies that ensure reliability and transparency.',
      name: 'a7',
      desc: '',
      args: [],
    );
  }

  /// `8. How can I contact support if I have a problem or inquiry?`
  String get q8 {
    return Intl.message(
      '8. How can I contact support if I have a problem or inquiry?',
      name: 'q8',
      desc: '',
      args: [],
    );
  }

  /// `You can contact our technical support team directly through the app or via the communication channels listed on the support page.`
  String get a8 {
    return Intl.message(
      'You can contact our technical support team directly through the app or via the communication channels listed on the support page.',
      name: 'a8',
      desc: '',
      args: [],
    );
  }

  /// `Contact via WhatsApp`
  String get contact_via_whatsapp {
    return Intl.message(
      'Contact via WhatsApp',
      name: 'contact_via_whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `License Number`
  String get license_number {
    return Intl.message(
      'License Number',
      name: 'license_number',
      desc: '',
      args: [],
    );
  }

  /// `Support and assistance`
  String get support_and_assist {
    return Intl.message(
      'Support and assistance',
      name: 'support_and_assist',
      desc: '',
      args: [],
    );
  }

  /// `Message Title:`
  String get message_title {
    return Intl.message(
      'Message Title:',
      name: 'message_title',
      desc: '',
      args: [],
    );
  }

  /// `Message:`
  String get message {
    return Intl.message(
      'Message:',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Technical support is provided within a period not exceeding (24 working hours) from the date of receiving the assistance request.`
  String get contact_times {
    return Intl.message(
      'Technical support is provided within a period not exceeding (24 working hours) from the date of receiving the assistance request.',
      name: 'contact_times',
      desc: '',
      args: [],
    );
  }

  /// `National ID or Commercial Register *`
  String get nationalIdOrCommercialRegister {
    return Intl.message(
      'National ID or Commercial Register *',
      name: 'nationalIdOrCommercialRegister',
      desc: '',
      args: [],
    );
  }

  /// `to contact via WhatsApp`
  String get whatsapp {
    return Intl.message(
      'to contact via WhatsApp',
      name: 'whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `Cooperation and Partnership Orders`
  String get cooperationAndPartenershipOrders {
    return Intl.message(
      'Cooperation and Partnership Orders',
      name: 'cooperationAndPartenershipOrders',
      desc: '',
      args: [],
    );
  }

  /// `Upload Payment Receipt`
  String get uploadPayMentRecipt {
    return Intl.message(
      'Upload Payment Receipt',
      name: 'uploadPayMentRecipt',
      desc: '',
      args: [],
    );
  }

  /// `RNOL`
  String get renter {
    return Intl.message(
      'RNOL',
      name: 'renter',
      desc: '',
      args: [],
    );
  }

  /// `Calculator and Projects Orders`
  String get collaborationAndPartenershipOrders {
    return Intl.message(
      'Calculator and Projects Orders',
      name: 'collaborationAndPartenershipOrders',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get language {
    return Intl.message(
      'Arabic',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Property Age:`
  String get renter_age {
    return Intl.message(
      'Property Age:',
      name: 'renter_age',
      desc: '',
      args: [],
    );
  }

  /// `Payment Plan`
  String get payment_plan {
    return Intl.message(
      'Payment Plan',
      name: 'payment_plan',
      desc: '',
      args: [],
    );
  }

  /// `Payment Duration`
  String get payment_duration {
    return Intl.message(
      'Payment Duration',
      name: 'payment_duration',
      desc: '',
      args: [],
    );
  }

  /// `Number of Units`
  String get num_of_units {
    return Intl.message(
      'Number of Units',
      name: 'num_of_units',
      desc: '',
      args: [],
    );
  }

  /// `First Installment`
  String get first_batch {
    return Intl.message(
      'First Installment',
      name: 'first_batch',
      desc: '',
      args: [],
    );
  }

  /// `Property Value`
  String get renter_value {
    return Intl.message(
      'Property Value',
      name: 'renter_value',
      desc: '',
      args: [],
    );
  }

  /// `Property Details`
  String get renter_details {
    return Intl.message(
      'Property Details',
      name: 'renter_details',
      desc: '',
      args: [],
    );
  }

  /// `Own Now`
  String get own_now {
    return Intl.message(
      'Own Now',
      name: 'own_now',
      desc: '',
      args: [],
    );
  }

  /// `Rent now and own later contract`
  String get renter_contract {
    return Intl.message(
      'Rent now and own later contract',
      name: 'renter_contract',
      desc: '',
      args: [],
    );
  }

  /// `This contract is executed between:`
  String get contract_m1 {
    return Intl.message(
      'This contract is executed between:',
      name: 'contract_m1',
      desc: '',
      args: [],
    );
  }

  /// `First Party: RCT Company (Service Provider).`
  String get contract_m2 {
    return Intl.message(
      'First Party: RCT Company (Service Provider).',
      name: 'contract_m2',
      desc: '',
      args: [],
    );
  }

  /// `Pursuant to this contract, both parties acknowledge the following:`
  String get contract_m3 {
    return Intl.message(
      'Pursuant to this contract, both parties acknowledge the following:',
      name: 'contract_m3',
      desc: '',
      args: [],
    );
  }

  /// `Property Type`
  String get renter_type {
    return Intl.message(
      'Property Type',
      name: 'renter_type',
      desc: '',
      args: [],
    );
  }

  /// `Property Location`
  String get renter_location {
    return Intl.message(
      'Property Location',
      name: 'renter_location',
      desc: '',
      args: [],
    );
  }

  /// `Property Area`
  String get renter_area {
    return Intl.message(
      'Property Area',
      name: 'renter_area',
      desc: '',
      args: [],
    );
  }

  /// `First Installment Date`
  String get first_batch_date {
    return Intl.message(
      'First Installment Date',
      name: 'first_batch_date',
      desc: '',
      args: [],
    );
  }

  /// `First Installment Value`
  String get first_batch_value {
    return Intl.message(
      'First Installment Value',
      name: 'first_batch_value',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Amount`
  String get monthly_value {
    return Intl.message(
      'Monthly Amount',
      name: 'monthly_value',
      desc: '',
      args: [],
    );
  }

  /// `The Second Party acknowledges that they have reviewed all the property details and the payment plan, and that ownership of the property is transferred to them after completing all installments according to the service terms and conditions.`
  String get contract_m4 {
    return Intl.message(
      'The Second Party acknowledges that they have reviewed all the property details and the payment plan, and that ownership of the property is transferred to them after completing all installments according to the service terms and conditions.',
      name: 'contract_m4',
      desc: '',
      args: [],
    );
  }

  /// `Legal Note:`
  String get logecl_note {
    return Intl.message(
      'Legal Note:',
      name: 'logecl_note',
      desc: '',
      args: [],
    );
  }

  /// `This is an electronic contract issued by the RCT platform, and the user may keep an electronic copy of it. In the event of any legal dispute, this contract shall be a legal reference between the two parties.`
  String get contract_m5 {
    return Intl.message(
      'This is an electronic contract issued by the RCT platform, and the user may keep an electronic copy of it. In the event of any legal dispute, this contract shall be a legal reference between the two parties.',
      name: 'contract_m5',
      desc: '',
      args: [],
    );
  }

  /// `Once the user approves this contract via the application, they are considered to have agreed to all`
  String get contract_m6 {
    return Intl.message(
      'Once the user approves this contract via the application, they are considered to have agreed to all',
      name: 'contract_m6',
      desc: '',
      args: [],
    );
  }

  /// `of RCT.`
  String get contract_m7 {
    return Intl.message(
      'of RCT.',
      name: 'contract_m7',
      desc: '',
      args: [],
    );
  }

  /// `Read and Approve the Contract`
  String get contract_m8 {
    return Intl.message(
      'Read and Approve the Contract',
      name: 'contract_m8',
      desc: '',
      args: [],
    );
  }

  /// `Please approve the contract to proceed`
  String get agree_the_contract {
    return Intl.message(
      'Please approve the contract to proceed',
      name: 'agree_the_contract',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to Pay`
  String get continue_to_pay {
    return Intl.message(
      'Proceed to Pay',
      name: 'continue_to_pay',
      desc: '',
      args: [],
    );
  }

  /// `Second Party: The User:`
  String get contract_m9 {
    return Intl.message(
      'Second Party: The User:',
      name: 'contract_m9',
      desc: '',
      args: [],
    );
  }

  /// `Rent now and own later`
  String get renter_message {
    return Intl.message(
      'Rent now and own later',
      name: 'renter_message',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Next Payment Date`
  String get next_payment_date {
    return Intl.message(
      'Next Payment Date',
      name: 'next_payment_date',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message(
      'Active',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  /// `Inactive`
  String get in_active {
    return Intl.message(
      'Inactive',
      name: 'in_active',
      desc: '',
      args: [],
    );
  }

  /// `Project Name`
  String get project_name {
    return Intl.message(
      'Project Name',
      name: 'project_name',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Number`
  String get subscripe_number {
    return Intl.message(
      'Subscription Number',
      name: 'subscripe_number',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Date`
  String get subscripe_date {
    return Intl.message(
      'Subscription Date',
      name: 'subscripe_date',
      desc: '',
      args: [],
    );
  }

  /// `Opportunity Price`
  String get opportunity_price {
    return Intl.message(
      'Opportunity Price',
      name: 'opportunity_price',
      desc: '',
      args: [],
    );
  }

  /// `Return Type`
  String get return_type {
    return Intl.message(
      'Return Type',
      name: 'return_type',
      desc: '',
      args: [],
    );
  }

  /// `Next Distribution Date`
  String get return_date {
    return Intl.message(
      'Next Distribution Date',
      name: 'return_date',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Type`
  String get subscription_type {
    return Intl.message(
      'Subscription Type',
      name: 'subscription_type',
      desc: '',
      args: [],
    );
  }

  /// `Number of Opportunities`
  String get opportunities_number {
    return Intl.message(
      'Number of Opportunities',
      name: 'opportunities_number',
      desc: '',
      args: [],
    );
  }

  /// `Project Duration`
  String get project_duration {
    return Intl.message(
      'Project Duration',
      name: 'project_duration',
      desc: '',
      args: [],
    );
  }

  /// `Real estate`
  String get my_renter {
    return Intl.message(
      'Real estate',
      name: 'my_renter',
      desc: '',
      args: [],
    );
  }

  /// `Share Now`
  String get share_now {
    return Intl.message(
      'Share Now',
      name: 'share_now',
      desc: '',
      args: [],
    );
  }

  /// `final return`
  String get final_return {
    return Intl.message(
      'final return',
      name: 'final_return',
      desc: '',
      args: [],
    );
  }

  /// `monthly return`
  String get monthly_return {
    return Intl.message(
      'monthly return',
      name: 'monthly_return',
      desc: '',
      args: [],
    );
  }

  /// `Choose number of units`
  String get choose_num_unit {
    return Intl.message(
      'Choose number of units',
      name: 'choose_num_unit',
      desc: '',
      args: [],
    );
  }

  /// `Enter valid card number`
  String get enter_card_number {
    return Intl.message(
      'Enter valid card number',
      name: 'enter_card_number',
      desc: '',
      args: [],
    );
  }

  /// `Card Number`
  String get card_number {
    return Intl.message(
      'Card Number',
      name: 'card_number',
      desc: '',
      args: [],
    );
  }

  /// `Choose number of opportunities`
  String get choose_num_opportunity {
    return Intl.message(
      'Choose number of opportunities',
      name: 'choose_num_opportunity',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `View location on map`
  String get view_on_map {
    return Intl.message(
      'View location on map',
      name: 'view_on_map',
      desc: '',
      args: [],
    );
  }

  /// `View project location`
  String get open_project_location {
    return Intl.message(
      'View project location',
      name: 'open_project_location',
      desc: '',
      args: [],
    );
  }

  /// `View project file`
  String get open_project_file {
    return Intl.message(
      'View project file',
      name: 'open_project_file',
      desc: '',
      args: [],
    );
  }

  /// `File not found`
  String get file_not_found {
    return Intl.message(
      'File not found',
      name: 'file_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed_opportunities {
    return Intl.message(
      'Completed',
      name: 'completed_opportunities',
      desc: '',
      args: [],
    );
  }

  /// `Please choose design or plan`
  String get should_choose_design {
    return Intl.message(
      'Please choose design or plan',
      name: 'should_choose_design',
      desc: '',
      args: [],
    );
  }

  /// `ادخل رقم IBAN صحيح`
  String get iban {
    return Intl.message(
      'ادخل رقم IBAN صحيح',
      name: 'iban',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
