// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
// import 'package:step_ai/core/di/service_locator.dart';
// import 'package:step_ai/shared/usecase/refresh_token_usecase.dart';

// class ApiClientChat {
//   final Dio _dio = Dio();
//   final secureStorageHelper = getIt<SecureStorageHelper>();
//   RefreshTokenUseCase refreshTokenUseCase = getIt<RefreshTokenUseCase>();
//   String? accessToken;
//   String? refreshToken;

//   ApiClientChat() {
//     _initializeTokens();
//     _dio.options.baseUrl = 'https://api.jarvis.cx'; // Base URL API
//     // _dio.options.connectTimeout = const Duration(seconds: 15);
//     // _dio.options.receiveTimeout = const Duration(seconds: 15);

//     _dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) {
//         options.headers['x-jarvis-guid'] = '';
//         if (accessToken != null) {
//           options.headers['Authorization'] = 'Bearer $accessToken';
//         }
//         return handler.next(options);
//       },
//       onResponse: (response, handler) {
//         return handler.next(response);
//       },
//       onError: (DioException error, handler) async {
//         if (error.response?.statusCode == 401) {
//           //token expired, refresh token
//           try {
//             await _refreshToken();

//             final retryResponse = await _retryRequest(error.requestOptions);
//             return handler.resolve(retryResponse);
//           } catch (e) {
//             // Refresh token failed, handle the error
//             return handler.reject(error);
//           }
//         }
//         return handler.next(error);
//       },
//     ));
//   }

//   //initialize tokens
//   Future<void> _initializeTokens() async {
//     accessToken = await secureStorageHelper.accessToken;
//     refreshToken = await secureStorageHelper.refreshToken;
//     print('----------------->accessToken: $accessToken');
//   }

//   // Call API to make a new access token and saved it in RefreshTokenUseCase
//   Future<void> _refreshToken() async {
//     try {
//       int statusCode = await refreshTokenUseCase.call(params: null);

//       accessToken = await secureStorageHelper.accessToken;
//       _dio.options.headers['Authorization'] = 'Bearer $accessToken';
//       if (statusCode == 401) {
//         throw Exception('Không thể làm mới token');
//       }
//     } catch (e) {
//       throw Exception('Không thể làm mới token');
//     }
//   }

//   //Request again with new access token
//   Future<Response> _retryRequest(RequestOptions requestOptions) async {
//     final options = Options(
//       method: requestOptions.method,
//       headers: requestOptions.headers,
//     );
//     return _dio.request(
//       requestOptions.path,
//       options: options,
//       data: requestOptions.data,
//       queryParameters: requestOptions.queryParameters,
//     );
//   }

//   // Các phương thức API
//   Future<Response> sendMessage(String path, {dynamic data}) {
//     return _dio.post(
//       path,
//       data: data,
//       options: Options(
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       ),
//     );
//   }

//   // Method to get message history (requires query parameters)
//   Future<Response> getHistoryList(String path,
//       {Map<String, String>? queryParams}) {
//     return _dio.get(
//       path,
//       queryParameters: queryParams,
//     );
//   }
// }

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/data/model/token_model.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/shared/usecase/refresh_token_usecase.dart';

class ApiClientChat {
  final Dio _dio = Dio();
  final secureStorageHelper = getIt<SecureStorageHelper>();
  final ApiService _apiService = ApiService(Constant.apiBaseUrl);
  // RefreshTokenUseCase refreshTokenUseCase = getIt<RefreshTokenUseCase>();
  String? accessToken;
  String? refreshToken;

  ApiClientChat() {
    _initializeTokens();
    _dio.options.baseUrl = 'https://api.jarvis.cx'; // Base URL API
    // _dio.options.connectTimeout = const Duration(seconds: 15);
    // _dio.options.receiveTimeout = const Duration(seconds: 15);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['x-jarvis-guid'] = '';
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImJlZjgxMDA4LTg4MTktNGM5NS1iNzZjLWQwODA3YzU0MTNiNSIsImVtYWlsIjoibmd1eWVuYm9jaGFAZ21haWwuY29tIiwiaWF0IjoxNzMxOTYyOTc2LCJleHAiOjE3MzE5NjQ3NzZ9.h4U1raHyJpeq_yz3OVRKSFN6KQDgoNKueOMO8_xiLCY';
      print("accessToken: $accessToken");
      print("-----------------------------ok--------------------------------") ;
        // In ra headers
      print("Headers: ${options.headers}");
      
      // In ra body (payload)
      if (options.data != null) {
        print("Body: ${options.data}");
      } else {
        print("Body: null");
      }
       print("-----------------------------ok--------------------------------") ;

        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        print("Error: ${error.response?.statusCode}");
        if (error.response?.statusCode == 401) {
          //token expired, refresh token
          try {
            await _refreshToken();

            final retryResponse = await _retryRequest(error.requestOptions);
            return handler.resolve(retryResponse);
          } catch (e) {
            // Refresh token failed, handle the error
            return handler.reject(error);
          }
        }
        return handler.next(error);
      },
    ));
  }

  //initialize tokens
  Future<void> _initializeTokens() async {
    accessToken = await secureStorageHelper.accessToken;
    refreshToken = await secureStorageHelper.refreshToken;
    print('----------------->accessToken: $accessToken');
  }

  // Call API to make a new access token and saved it in RefreshTokenUseCase
  Future<void> _refreshToken() async {
    try {
      // int statusCode = await refreshTokenUseCase.call(params: null);
      var myResponse = await _apiService
          .get('${Constant.refreshTokenPartEndpoint}$refreshToken');

      if (myResponse.statusCode == 200) {
        TokenModel token;
        token = TokenModel.fromJson(
            jsonDecode(await myResponse.stream.bytesToString()));
        await secureStorageHelper.saveAccessToken(token.accessToken);
        //lưu để gọi lại sau
        accessToken = await secureStorageHelper.accessToken;
        _dio.options.headers['Authorization'] = 'Bearer $accessToken';
      }
    } catch (e) {
      throw Exception('Không thể làm mới token');
    }
  }

  //Request again with new access token
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request(
      requestOptions.path,
      options: options,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }

  // Các phương thức API
  Future<Response> sendMessage(String path, {dynamic data}) {
    return _dio.post(
      path,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  // Method to get message history (requires query parameters)
  Future<Response> getHistoryList(String path,
      {Map<String, String>? queryParams}) {
    return _dio.get(
      path,
      queryParameters: queryParams,
    );
  }
}
