import 'dart:io';
import 'package:clothes_store/utils/show_message.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';

import '../core/services/localization/language_service.dart';

class HelperFunctions {
  static changeAppStatus(ThemeMode theme) {
    final color =
        theme == ThemeMode.dark
            ? const Color(0xFF191C1D)
            : const Color(0xFFFBFDFD);
    final brightness =
        theme == ThemeMode.light ? Brightness.dark : Brightness.light;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarIconBrightness: brightness,
      ),
    );
  }


  static Future<bool> lostInternetConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result == ConnectivityResult.none;
  }

  // static Future<MediaInfo?> compressVideo({
  //   required String videoPath,
  //   required VideoQuality quality,
  // }) async {
  //   try {
  //     await VideoCompress.setLogLevel(0);
  //     return await VideoCompress.compressVideo(
  //       videoPath,
  //       includeAudio: true,
  //       quality: quality, // Adjust quality (Low, Medium, High)
  //       deleteOrigin: false, // Keep original file
  //     );
  //   } catch (e) {
  //     print(e);
  //     VideoCompress.cancelCompression();
  //   }
  // }
  //
  // static Future<MediaInfo> getVideoInfo({required String videoPath}) async {
  //   return await VideoCompress.getMediaInfo(videoPath);
  // }
  //
  // static deleteCompressedVideos() async {
  //   VideoCompress.deleteAllCache();
  // }

  static Future<String> changeSvgColor(String svgPath, String newColor) async {
    String svgCode = await rootBundle.loadString(svgPath);

    svgCode = svgCode.replaceAll("CC3333", newColor.toUpperCase());
    return svgCode;
  }


  static Route createRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static String getTheFirstTwoLettersOfName(String name) {
    return name.split(' ').length == 2
        ? name.split(' ')[0][0] + name.split(' ')[1][0]
        : name.split(' ').first.length > 1
        ? (name.split(' ')[0][0] + name.split(' ')[0][1])
        : name.split(' ').first;
  }

  static String replaceArabicNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
  }

  static Locale getInitLocale() {
    return mpaLanguageCodeToLocale['ar']!;
    // final PrefsRepository prefsRepository = GetIt.I<PrefsRepository>();
    // final devicelang = prefsRepository.languageCode ?? WidgetsBinding.instance.window.locale.languageCode;
    // return mpaLanguageCodeToLocale[devicelang] ?? defaultLocal ;
  }

  static DateTime getZonedDate(DateTime date) {
    return date.toLocal();
  }

  static String getTimeInFormat(Duration duration) {
    String? hours =
        duration.inHours > 0 ? twoDigits(duration.inHours.remainder(60)) : null;
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${hours ?? ''}$minutes:$seconds';
  }


  static String twoDigits(int n) => n.toString().padLeft(2, "0");

  static String getTimeInHMSFormat({required Duration seconds}) {
    String twoDigitMinutes = twoDigits(seconds.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(seconds.inSeconds.remainder(60).abs());
    return "${twoDigits(seconds.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }



  static whatsapp() async {
    String contact = "963968203343";
    String text = "مرحباً, أود طرح سؤال";
    String androidUrl = "whatsapp://send?phone=$contact&text=${Uri.encodeFull(text)}";
    String iosUrl = "https://wa.me/$contact?text=${Uri.encodeFull(text)}";
    String webUrl = 'https://api.whatsapp.com/send/?phone=$contact&text=${Uri.encodeFull(text)}';
    try {
      if (Platform.isIOS) {
        if (await canLaunchUrl(Uri.parse(iosUrl))) {
          await launchUrl(Uri.parse(iosUrl) );
        }
      } else {
        if (await canLaunchUrl(Uri.parse(iosUrl))) {
          await launchUrl(Uri.parse(iosUrl));
        }
      }
    } catch (e) {
      showMessage(e.toString());
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
      print('object ${e.toString()}');
    }
  }


  static Future<bool> urlLauncherBrowser(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
        webViewConfiguration: const WebViewConfiguration(
          enableDomStorage: true,
          enableJavaScript: true,
        ),
      );
    } else {
      throw Exception('Unable to launch url');
    }
  }

  static Future<bool> urlLauncher(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri , mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Unable to launch url');
    }
  }

  static _getFileFromGoogleDrive() {
    urlLauncherBrowser(
      'https://drive.google.com/file/d/1im1-7Bmx5Qi9cTsVIvGnZIvNY7vSKQLj/view?usp=drivesdk',
    );
  }

  // _openStoreUrl() {
  //   StoreRedirect.redirect(
  //     androidAppId: 'ae.clearance.app',
  //     iOSAppId: '1637100307',
  //   );
  // }

  static navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  static slidingNavigation(
    BuildContext context,
    Widget page, {
    int milliseconds = 300,
  }) {
    Navigator.of(context).push(
      new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return page;
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new SlideTransition(
            child: child,
            position: new Tween<Offset>(
              begin: const Offset(1, 0), //// navigation from right
              end: Offset.zero,
            ).animate(animation),
          );
        },
      ),
    );
  }

  static String getYearNameByNumber(int year) {
    switch (year) {
      case 1:
        return "الأولى";
      case 2:
        return "الثانية";
      case 3:
        return "الثالثة";
      case 4:
        return "الرابعة";
      case 5:
        return "الخامسة";
      case 6:
        return "السادسة";
    }
    return "غير محدد";
  }
}
