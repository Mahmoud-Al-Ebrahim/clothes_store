import 'dart:convert';
import 'package:clothes_store/models/products_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref {
  // prevent making instance
  MySharedPref._();

  // get storage
  static late SharedPreferences _sharedPreferences;

  // STORING KEYS
  static const String _tokenKey = 'token';
  static const String fullName = 'fullName';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String userName = 'userName';
  static const String _fcmTokenKey = 'fcm_token';
  static const String _lightThemeKey = 'is_theme_light';
  static const String _isAdmin = 'is_admin';
  static const String _isVerified = 'IsVerified';
  static const String _language = 'language';
  static const String _favoritesKey = 'favorites';
  static const String _lastSeenKey = 'last_seen';



  /// init get storage services
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();


  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  /// set theme current type as light theme
  static Future<void> setThemeIsLight(bool lightTheme) =>
      _sharedPreferences.setBool(_lightThemeKey, lightTheme);

  /// get if the current theme type is light
  static bool getThemeIsLight() =>
      _sharedPreferences.getBool(_lightThemeKey) ?? true;

  /// save generated fcm token
  static Future<void> setFcmToken(String token) =>
      _sharedPreferences.setString(_fcmTokenKey, token);

  /// get generated fcm token
  static String? getFcmToken() =>
      _sharedPreferences.getString(_fcmTokenKey);

  /// save generated token
  static Future<void> saveToken(String token) =>
      _sharedPreferences.setString(_tokenKey, token);

  /// get generated fcm token
  static String? getToken() =>
      _sharedPreferences.getString(_tokenKey);

  /// save is admin
  static Future<void> saveIsAdmin(bool isAdmin) =>
      _sharedPreferences.setBool(_isAdmin, isAdmin);

  /// get generated is Admin
  static bool? getIsAdmin() =>
      _sharedPreferences.getBool(_isAdmin);

  /// clear all data from shared pref
  static Future<void> clear() async => await _sharedPreferences.clear();

  /// save generated language
  static Future<void> saveLanguage(String lang) =>
      _sharedPreferences.setString(_language, lang);

  /// get generated language
  static String getLanguage() =>
      _sharedPreferences.getString(_language) ?? 'en';

  /// save IsVerified
  static Future<void> saveIsVerified() =>
      _sharedPreferences.setBool(_isVerified, true);

  /// get generated IsVerified
  static bool? getIsVerified() =>
      _sharedPreferences.getBool(_isVerified);

  static String? getFullName() =>
      _sharedPreferences.getString(fullName);

  static String? getEmail() =>
      _sharedPreferences.getString(email);

  static String? getUserName() =>
      _sharedPreferences.getString(userName);

  static String? getPhone() =>
      _sharedPreferences.getString(phone);

  static Future<bool>? setImage(String url) =>
      _sharedPreferences.setString('image' , url);

  static String? getImage() =>
      _sharedPreferences.getString('image');

  // ---------------- FAVORITES ---------------- //

  /// Add product to favorites
  static Future<void> addFavorite(ProductsResponseModel product) async {
    final favorites = getFavoriteProducts();
    if (!isFavorite(product.id.toString())) {
      favorites.add(product);
      final encoded =
      favorites.map((p) => jsonEncode(p.toJson())).toList();
      await _sharedPreferences.setStringList(_favoritesKey, encoded);
    }
  }

  /// Remove product from favorites
  static Future<void> removeFavorite(String productId) async {
    final favorites = getFavoriteProducts();
    favorites.removeWhere((p) => p.id.toString() == productId);
    final encoded =
    favorites.map((p) => jsonEncode(p.toJson())).toList();
    await _sharedPreferences.setStringList(_favoritesKey, encoded);
  }

  /// Get all favorite products
  static List<ProductsResponseModel> getFavoriteProducts() {
    final List<String>? stored =
    _sharedPreferences.getStringList(_favoritesKey);
    if (stored == null) return [];
    return stored
        .map((p) => ProductsResponseModel.fromJson(jsonDecode(p)))
        .toList();
  }

  /// Check if a product is favorite
  static bool isFavorite(String productId) {
    final favorites = getFavoriteProducts();
    return favorites.any((p) => p.id.toString() == productId);
  }

  // ---------------- LAST SEEN ---------------- //

  /// Save a product to last seen list (keep only 10 latest)
  static Future<void> saveLastSeen(ProductsResponseModel product) async {
    final lastSeen = getLastSeenProducts();

    // remove if already exists
    lastSeen.removeWhere((p) => p.id == product.id);

    // insert at beginning
    lastSeen.insert(0, product);

    // lastSeen.add(product);

    // keep only 10 items
    if (lastSeen.length > 10) {
      lastSeen.removeRange(10, lastSeen.length);

      //  lastSeen.remove(lastSeen.last);
    }

    final encoded =
    lastSeen.map((p) => jsonEncode(p.toJson())).toList();
    await _sharedPreferences.setStringList(_lastSeenKey, encoded);
  }

  /// Get last seen products
  static List<ProductsResponseModel> getLastSeenProducts() {
    final List<String>? stored =
    _sharedPreferences.getStringList(_lastSeenKey);
    if (stored == null) return [];
    return stored
        .map((p) => ProductsResponseModel.fromJson(jsonDecode(p)))
        .toList();
  }

  static Future<void> toggleFavorite(ProductsResponseModel product) async {
    if (isFavorite(product.id.toString())) {
      await removeFavorite(product.id.toString());
    } else {
      await addFavorite(product);
    }
  }

}
