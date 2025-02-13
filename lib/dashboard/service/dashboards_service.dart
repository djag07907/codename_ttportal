import 'package:cdbi/dashboard/model/dashboard_model.dart';
import 'package:cdbi/factory/client_factory.dart';
import 'package:cdbi/factory/guess_factory.dart';
import 'package:cdbi/resources/api_constants.dart';
import 'package:dio/dio.dart';

class DashboardsService {
  Dio client;
  Dio authClient;

  DashboardsService()
      : client = GuessFactory.buildClient(),
        authClient = ClientFactory.buildClient();

  DashboardsService.withClient(this.client, this.authClient);

  Future<List<Dashboard>> getDashboards({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final response = await authClient.get(
      getDashboardsPath,
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
    return dataList.map((json) => Dashboard.fromJson(json)).toList();
  }
}
