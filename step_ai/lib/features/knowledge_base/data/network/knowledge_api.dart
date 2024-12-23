import 'package:dio/dio.dart';
import 'package:step_ai/config/constants.dart';

class KnowledgeApi {
  final Dio _dio = Dio();
  // final secureStorageHelper = getIt<SecureStorageHelper>();
  // final ApiService _apiService = ApiService(Constant.apiBaseUrl);
  // RefreshTokenUseCase refreshTokenUseCase = getIt<RefreshTokenUseCase>();
  String? accessKnowledgeToken;
  String? refreshKnowledgeToken;

  KnowledgeApi() {
    _dio.options.baseUrl = 'https://knowledge-api.jarvis.cx'; // Base URL API

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print(
            "\n-----------------------------OnRequest--------------------------------1");
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
        print(
            "-----------------------------OnResponse--------------------------------2");
        print("Response: ${response.data}");
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        print(
            "\n-----------------------------Error--------------------------------3");
        print("Error: ${error.response?.statusCode}");
        print("Error: ${error.response?.data}");
        return handler.next(error);
      },
    ));
  }

  //initialize tokens
  Future<void> _initializeTokens() async {
    // accessKnowledgeToken = await secureStorageHelper.accessToken;
    // refreshKnowledgeToken = await secureStorageHelper.refreshToken;
    accessKnowledgeToken =
        Constant.KB_accessToken;
    refreshKnowledgeToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImJlZjgxMDA4LTg4MTktNGM5NS1iNzZjLWQwODA3YzU0MTNiNSIsImVtYWlsIjoibmd1eWVuYm9jaGFAZ21haWwuY29tIiwiaWF0IjoxNzMzNTYwOTc5LCJleHAiOjE3MzM2NDczNzl9.o2OKhw4pGkrQZXSMTguF6imMgjZ3MpaeWEQvYR9fLHk";
  }

  // Call API to make a new access token and saved it in RefreshTokenUseCase
  // Future<void> _refreshToken() async {
  //   print("------------refreshToken------------");
  //   try {
  //     // int statusCode = await refreshTokenUseCase.call(params: null);
  //     var myResponse = await _apiService
  //         .get('${Constant.refreshTokenPartEndpoint}$refreshToken');

  //     if (myResponse.statusCode == 200) {
  //       print("*****************Làm mới token thành công");
  //       TokenModel token;
  //       token = TokenModel.fromJson(
  //           jsonDecode(await myResponse.stream.bytesToString()));
  //       await secureStorageHelper.saveAccessToken(token.accessToken);
  //       //lưu để gọi lại sau
  //       accessToken = await secureStorageHelper.accessToken;
  //       //_dio.options.headers['Authorization'] = 'Bearer $accessToken';
  //     } else {
  //       print("*****************Làm mới token thất bại");
  //       throw Exception('Không thể làm mới token');
  //     }
  //   } catch (e) {
  //     print("*****************Không thể làm mới token");
  //     throw Exception('Không thể làm mới token');
  //   }
  // }

  //Request again with new access token
  // Future<Response> _retryRequest(RequestOptions requestOptions) async {
  //   print("retryRequest");
  //   final options = Options(
  //     method: requestOptions.method,
  //     headers: requestOptions.headers,
  //   );
  //   return _dio.request(
  //     requestOptions.path,
  //     options: options,
  //     data: requestOptions.data,
  //     queryParameters: requestOptions.queryParameters,
  //   );
  // }

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
