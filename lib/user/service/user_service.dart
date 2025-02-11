import 'package:codename_ttportal/factory/client_factory.dart';
import 'package:codename_ttportal/factory/guess_factory.dart';
import 'package:codename_ttportal/resources/api_constants.dart';
import 'package:codename_ttportal/user/model/company_model.dart';
import 'package:codename_ttportal/user/model/user_model.dart';
import 'package:dio/dio.dart';

class UserService {
  Dio client;
  Dio authClient;

  UserService()
      : client = GuessFactory.buildClient(),
        authClient = ClientFactory.buildClient();

  UserService.withClient(this.client, this.authClient);

  Future<User> createUser({required User user}) async {
    final response = await authClient.post(
      createUserPath,
      data: user.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    if (response.data['code'] != 200 && response.data['code'] != 201) {
      throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['message']);
    }
    return User.fromJson(response.data['data']);
  }

  Future<List<User>> getUsers({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final response = await authClient.get(
      getUsersPath,
      queryParameters: {
        'PageNumber': pageNumber,
        'PageSize': pageSize,
      },
    );
    final dynamic responseData = response.data['data'];
    List<dynamic> dataList;
    if (responseData is List) {
      dataList = responseData;
    } else if (responseData is Map && responseData.containsKey('results')) {
      dataList = responseData['results'];
    } else {
      dataList = [];
    }
    return dataList.map((json) => User.fromJson(json)).toList();
  }

  Future<List<Company>> getCompanies({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final response = await authClient.get(
      getCompaniesPath,
      queryParameters: {
        'PageNumber': pageNumber,
        'PageSize': pageSize,
      },
    );
    final dynamic responseData = response.data['data'];
    List<dynamic> dataList;
    if (responseData is List) {
      dataList = responseData;
    } else if (responseData is Map &&
        responseData.containsKey(
          'results',
        )) {
      dataList = responseData['results'];
    } else {
      dataList = [];
    }

    return dataList.map((json) => Company.fromJson(json)).toList();
  }
}
