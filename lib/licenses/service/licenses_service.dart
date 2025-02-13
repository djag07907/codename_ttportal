import 'package:cdbi/licenses/model/company_model.dart';
import 'package:cdbi/licenses/model/license_model.dart';
import 'package:cdbi/factory/client_factory.dart';
import 'package:cdbi/factory/guess_factory.dart';
import 'package:cdbi/resources/api_constants.dart';
import 'package:dio/dio.dart';

class LicensesService {
  Dio client;
  Dio authClient;

  LicensesService()
      : client = GuessFactory.buildClient(),
        authClient = ClientFactory.buildClient();

  LicensesService.withClient(
    this.client,
    this.authClient,
  );

  Future<List<License>> createLicense({required License license}) async {
    final response = await authClient.post(
      createCompanyLicensesPath,
      data: license.toJson(),
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    List<dynamic> dataList = response.data['data'];
    return dataList.map((json) => License.fromJson(json)).toList();
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
