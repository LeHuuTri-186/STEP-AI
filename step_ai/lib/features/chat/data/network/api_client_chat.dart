import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/data/model/token_model.dart';
import 'package:step_ai/core/di/service_locator.dart';

class ApiClientChat {
  final Dio _dio = Dio();
  final secureStorageHelper = getIt<SecureStorageHelper>();
  final ApiService _apiService = ApiService(Constant.apiBaseUrl);
  // RefreshTokenUseCase refreshTokenUseCase = getIt<RefreshTokenUseCase>();
  String? accessToken;
  String? refreshToken;

  ApiClientChat() {
    _dio.options.baseUrl = Constant.apiBaseUrl; // Base URL API

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // print(
        //     "\n-----------------------------OnRequest--------------------------------1");
        await _initializeTokens();
        options.headers['x-jarvis-guid'] = '';
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        // In ra headers
        //print("Headers: ${options.headers}");

        // // In ra body (payload)
        // if (options.data != null) {
        //   print("Body: ${options.data}");
        // } else {
        //   print("Body: null");
        // }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // print(
        //     "-----------------------------OnResponse--------------------------------2");
        // print("Response: ${response.data}");
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        // print(
        //     "\n-----------------------------Error--------------------------------3");
        // print("Error: ${error.response?.statusCode}");
        // print("Error: ${error.response?.data}");
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
  }

  // Call API to make a new access token and saved it in RefreshTokenUseCase
  Future<void> _refreshToken() async {
    // print("------------refreshToken------------");
    try {
      // int statusCode = await refreshTokenUseCase.call(params: null);
      var myResponse = await _apiService
          .get('${Constant.refreshTokenPartEndpoint}$refreshToken');

      if (myResponse.statusCode == 200) {
        //print("*****************Làm mới token thành công");
        TokenModel token;
        token = TokenModel.fromJson(
            jsonDecode(await myResponse.stream.bytesToString()));
        await secureStorageHelper.saveAccessToken(token.accessToken);
        //lưu để gọi lại sau
        accessToken = await secureStorageHelper.accessToken;
        //_dio.options.headers['Authorization'] = 'Bearer $accessToken';
      } else {
        //print("*****************Làm mới token thất bại");
        throw Exception('Không thể làm mới token');
      }
    } catch (e) {
      //print("*****************Không thể làm mới token");
      throw Exception('Không thể làm mới token');
    }
  }

  //Request again with new access token
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    // print("retryRequest");
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
      {Map<String, dynamic>? queryParams}) {
        // print("ABCD++++++++ getHistoryList in ChatApiClient");
    return _dio.get(
      path,
      queryParameters: queryParams,
    );
  }

  Future<Response> getUsageToken(String path) {
    return _dio.get(path);
  }

  Future<Response> getMessagesByConversationId(String path,
      {Map<String, dynamic>? queryParams}) {
    // print("getMessagesByConversationId in ChatApiClient");
    return _dio.get(
      path,
      queryParameters: queryParams,
    );
  }
    Future<Response> getCurrentUser(String path,
      {Map<String, dynamic>? queryParams}) {
    // print("getMessagesByConversationId in ChatApiClient");
    return _dio.get(
      path,
    );
  }
}
