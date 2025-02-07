import 'package:codename_ttportal/companies/model/company_model.dart';
import 'package:codename_ttportal/factory/client_factory.dart';
import 'package:codename_ttportal/factory/guess_factory.dart';
import 'package:codename_ttportal/resources/api_constants.dart';
import 'package:dio/dio.dart';

class CompanyService {
  Dio client;
  Dio authClient;

  CompanyService()
      : client = GuessFactory.buildClient(),
        authClient = ClientFactory.buildClient();

  CompanyService.withClient(this.client, this.authClient);

  Future<Company> createCompany({required Company company}) async {
    final response = await authClient.post(
      createCompanyPath,
      data: company.toJson(),
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    return Company.fromJson(response.data['data']);
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
