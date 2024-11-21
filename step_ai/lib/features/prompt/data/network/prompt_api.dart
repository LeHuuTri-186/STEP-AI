import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/data/model/token_model.dart';
import 'package:step_ai/core/di/service_locator.dart';

class PromptApi {
  final Dio _dio = Dio();
  final SecureStorageHelper _secureStorageHelper = getIt<SecureStorageHelper>();
  final ApiService _apiService = ApiService(Constant.apiBaseUrl);

  String? accessToken;
  String? refreshToken;

  PromptApi() {
    _dio.options.baseUrl = 'https://api.jarvis.cx'; // Base URL for API

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await _initializeTokens();
          options.headers['x-jarvis-guid'] = ''; // Add relevant value here
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          handler.next(options); // Proceed with the request
        },
        onResponse: (response, handler) {
          handler.next(response); // Pass response forward
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            // Handle token expiration by refreshing the token
            try {
              await _refreshToken();
              final retryResponse = await _retryRequest(error.requestOptions);
              return handler.resolve(retryResponse);
            } catch (e) {
              // Refresh token failed; return the original error
              return handler.reject(error);
            }
          }
          handler.next(error); // Pass error forward
        },
      ),
    );
  }

  /// Initializes tokens from secure storage.
  Future<void> _initializeTokens() async {
    accessToken = await _secureStorageHelper.accessToken;
    refreshToken = await _secureStorageHelper.refreshToken;
  }

  /// Refreshes the access token using the refresh token.
  Future<void> _refreshToken() async {
    try {
      final response = await _apiService.get(
        '${Constant.refreshTokenPartEndpoint}$refreshToken',
      );

      if (response.statusCode == 200) {
        final token = TokenModel.fromJson(
          jsonDecode(await response.stream.bytesToString()),
        );
        await _secureStorageHelper.saveAccessToken(token.accessToken);
        accessToken = token.accessToken; // Update the access token
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw Exception('Token refresh failed');
    }
  }

  /// Retries a failed request after refreshing the token.
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

  /// Sends a POST request to the API.
  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post(
      path,
      data: data,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  /// Sends a GET request to the API with optional query parameters.
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return _dio.get(
      path,
      queryParameters: queryParams,
    );
  }

  /// Sends a DELETE request to the API.
  Future<Response> delete(String path) async {
    return _dio.delete(path);
  }

  /// Sends a PATCH request to the API.
  Future<Response> patch(String path, {dynamic data}) async {
    return _dio.patch(
      path,
      data: data,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }
}
