import 'package:dio/dio.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';

class KnowledgeApi {
  final Dio _dio = Dio();
  // final secureStorageHelper = getIt<SecureStorageHelper>();
  // final ApiService _apiService = ApiService(Constant.apiBaseUrl);
  // RefreshTokenUseCase refreshTokenUseCase = getIt<RefreshTokenUseCase>();
  String? accessKnowledgeToken;
  String? refreshKnowledgeToken;
  SecureStorageHelper secureStorageHelper;

  KnowledgeApi(this.secureStorageHelper) {
    _dio.options.baseUrl = Constant.kbApiUrl; // Base URL API

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // print(
        //     "\n-----------------------------OnRequest--------------------------------1");
        await _initializeTokens();
        options.headers['x-jarvis-guid'] = '';
        if (accessKnowledgeToken != null) {
          options.headers['Authorization'] = 'Bearer $accessKnowledgeToken';
        }
        // In ra headers
        //print("Headers: ${options.headers}");

        // In ra body (payload)
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
        return handler.next(error);
      },
    ));
  }

  //initialize tokens
  Future<void> _initializeTokens() async {
    // accessKnowledgeToken = await secureStorageHelper.accessToken;
    // refreshKnowledgeToken = await secureStorageHelper.refreshToken;
    accessKnowledgeToken = await secureStorageHelper.kbAccessToken;
  }


  // Các phương thức API

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
