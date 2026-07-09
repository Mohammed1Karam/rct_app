import 'package:flutter/material.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view/home_screen.dart';
import '../common copounents/locale_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    final provider = Provider.of<LocaleProvider>(context);
    final currentLocale = provider.locale;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0, scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Image.asset(
          "assets/images/photo_2024-09-16_00-14-11.jpg",
          fit: BoxFit.contain,
          width: 100,
          height: 100,
        ),
        // backgroundColor: primaryColor,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          ListTile(
            title: Text(local.arabic),
            trailing:
                CacheHelper.getData(key: "lang") == 'ar' ? Icon(Icons.check) : null,
            onTap: () {
              provider.setLocale(Locale('ar'));
            },
          ),
          const Divider(),
          ListTile(
            title: Text(local.english),
            trailing:
            CacheHelper.getData(key: "lang") == 'en' ? Icon(Icons.check) : null,
            onTap: () {
              provider.setLocale(Locale('en'));
            },
          ),
        ],
      ),
    );
  }
}
