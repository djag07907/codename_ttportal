import 'package:codename_ttportal/factory/client_factory.dart';
import 'package:codename_ttportal/factory/guess_factory.dart';
import 'package:codename_ttportal/home/model/dashboard_model.dart';
import 'package:codename_ttportal/home/model/user_details_model.dart';
import 'package:codename_ttportal/resources/api_constants.dart';
import 'package:dio/dio.dart';

class HomeService {
  Dio client;
  Dio authClient;

  HomeService()
      : client = GuessFactory.buildClient(),
        authClient = ClientFactory.buildClient();

  HomeService.withClient(
    this.client,
    this.authClient,
  );

  Future<UserDetails> getUserDetailsById(String userId) async {
    final response = await authClient.get(
      '$getUserDetailsPath$userId',
    );
    return UserDetails.fromJson(response.data['data']['results'][0]);
  }

  Future<List<Dashboard>> getDashboardsByCompanyId(
    String companyId,
  ) async {
    final response = await authClient.get(
      '$getDashboardByCompanyIdPath$companyId',
    );
    final dynamic responseData = response.data['data'];
    List<dynamic> dataList = responseData is List ? responseData : [];
    return dataList.map((json) => Dashboard.fromJson(json)).toList();
  }
}
