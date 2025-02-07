import 'package:codename_ttportal/licenses/model/license_model.dart';
import 'package:codename_ttportal/factory/client_factory.dart';
import 'package:codename_ttportal/factory/guess_factory.dart';
import 'package:codename_ttportal/resources/api_constants.dart';
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

  Future<LicensesData> getLicenses(
      {int pageNumber = 1, int pageSize = 10}) async {
    final response = await authClient.get(
      getCompanyLicensesPath,
      queryParameters: {
        'PageNumber': pageNumber,
        'PageSize': pageSize,
      },
    );
    return LicensesData.fromJson(response.data['data']);
  }
}
