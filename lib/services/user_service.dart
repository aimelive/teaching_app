import 'package:dio/dio.dart';
import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/utils/exception.dart';
import '../utils/keys.dart';

class UserService {
  final dio = Dio();

  //Login to account
  Future<dynamic> login(
    String email,
    String pwd,
  ) async {
    try {
      final uri = "$backendApiUrl/auth/login";
      final result = await dio.post(uri, data: {
        "email": email,
        "password": pwd,
      });
      return result.data;
    } on DioError catch (e) {
      ApiError.dio(e);
    } catch (e) {
      ApiError.unknown(e);
    }
  }

  //Getting user account informations
  Future<UserAccount?> getUser(String email, String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      final result = await dio.get(
        "$backendApiUrl/user/$email",
      );

      return UserAccount.fromJson(result.data);
    } on DioError catch (e) {
      ApiError.dio(e);
      return null;
    } catch (e) {
      ApiError.unknown(e);
      return null;
    }
  }
}
