import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
class ApiService {
  static late Dio _dio;
  static const String baseUrl = 'http://ecommerceapplicationv2.runasp.net'; // server url
  static late Uri baseUri;
  static String? token ;
  static String prefix = '/api/';
  static  init() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
    print(token);
    baseUri = Uri.parse(baseUrl);
    print('host ${baseUri.host}');
    print('scheme ${baseUri.scheme}');
    Map<String , dynamic> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if(token != null){
      headers.addAll({HttpHeaders.authorizationHeader : 'Bearer $token'});
    }
    BaseOptions options = BaseOptions(headers: headers,
      contentType: 'application/json',
      responseType: ResponseType.json,
    baseUrl: baseUrl,
    );
    _dio = Dio(options);
  }
  // /stories/public/api/v1/stories/users_stories ToDo end point to test
  //end point means the suffix string after the server url

  static Future<Response> postMethod(
      {required String endPoint,
      Map<String, dynamic>? queryParameters,
        String? bodyAsString,
        dynamic form ,
      Map<String, dynamic>? body}) async {
    Uri uri = Uri(
      host: baseUri.host,
      scheme: baseUri.scheme,
      path: prefix + endPoint,
      queryParameters: queryParameters,
    );
     return _dio.postUri(uri, data: form ?? bodyAsString ?? body);
  }

  static Future<Response> putMethod(
      {required String endPoint,
      Map<String, dynamic>? queryParameters,
        String? bodyAsString,
      Map<String, dynamic>? body}) async {
    Uri uri = Uri(
      host: baseUri.host,
      scheme: baseUri.scheme,
      path: prefix + endPoint,
      queryParameters: queryParameters,
    );
    return _dio.putUri(uri, data: bodyAsString ?? body);
  }

  static Future<Response> getMethod(
      {required String endPoint, Map<String, dynamic>? queryParameters}) async {
    Uri uri = Uri(
      host: baseUri.host,
      scheme: baseUri.scheme,
      path: prefix + endPoint,
      queryParameters: queryParameters,
    );
    return _dio.getUri(uri); // get request does not contain a body
  }

  static Future<Response> deleteMethod(
      {required String endPoint, Map<String, dynamic>? queryParameters}) async {
    Uri uri = Uri(
      host: baseUri.host,
      scheme: baseUri.scheme,
      path:prefix +  endPoint,
      queryParameters: queryParameters,
    );
    return _dio.deleteUri(uri); // delete request does not contain a body
  }
  static Future<Response> patchMethod(
      {required String endPoint, Map<String, dynamic>? body}) async {
    Uri uri = Uri(
      host: baseUri.host,
      scheme: baseUri.scheme,
      path: prefix + endPoint,
    );
    return _dio.patchUri(uri,data: body); // get request does not contain a body
  }
  // static Future<Response> patchMethodForImage(
  //     {required String endPoint, required File file}) async {
  //   String fileName = file.path.split('/').last;
  //   String mimeType = mime(fileName) ?? '';
  //   String mimee = mimeType.split('/')[0];
  //   String type = mimeType.split('/')[1];
  //   Uri uri = Uri(
  //     host: baseUri.host,
  //     port: 9000,
  //     scheme: baseUri.scheme,
  //     path: prefix + endPoint,
  //   );
  //   return _dio.patchUri(uri,data: FormData.fromMap(
  //       {
  //         "photo": await MultipartFile.fromFile(
  //           file.path,
  //           filename: fileName,
  //           contentType: MediaType(mimee, type),
  //         ),
  //       }
  //   )); // get request does not contain a body
  // }
}
