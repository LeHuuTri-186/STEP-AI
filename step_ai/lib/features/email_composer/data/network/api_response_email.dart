import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../config/constants.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/data/local/securestorage/secure_storage_helper.dart';
import '../../../../core/data/model/token_model.dart';
import '../../../../core/di/service_locator.dart';

class ApiResponseEmail {
  final Dio _dio = Dio();
  final secureStorageHelper = getIt<SecureStorageHelper>();
  final ApiService _apiService = ApiService(Constant.apiBaseUrl);
  // RefreshTokenUseCase refreshTokenUseCase = getIt<RefreshTokenUseCase>();
  String? accessToken;
  String? refreshToken;

  ApiResponseEmail() {
    _dio.options.baseUrl = Constant.apiBaseUrl; // Base URL API

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {

        await _initializeTokens();
        options.headers['x-jarvis-guid'] = '';
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {

        return handler.next(response);
      },
      onError: (DioException error, handler) async {

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
        //_dio.options.headers['Authorization'] = 'Bearer $accessToken';
      } else {
        throw Exception('Không thể làm mới token');
      }
    } catch (e) {
      throw Exception('Không thể làm mới token');
    }
  }


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

  Future<Response> postAiEmail(Map<String, dynamic> payload) async {
    return _dio.post("/api/v1/ai-email", data: payload);
  }

  Future<Response> postSuggestionRequest(Map<String, dynamic> payload) async {
    print(payload);
    return _dio.post("/api/v1/ai-email/reply-ideas", data: payload);
  }

  Future<Response> postComposeEmailRequest(Map<String, dynamic> payload) async {
    return _dio.post("/api/v1/ai-action", data: payload);
  }
}