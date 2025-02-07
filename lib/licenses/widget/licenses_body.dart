import 'package:codename_ttportal/companies/model/company_model.dart';
import 'package:codename_ttportal/companies/service/companies_service.dart';
import 'package:codename_ttportal/licenses/bloc/licenses_bloc.dart';
import 'package:codename_ttportal/licenses/bloc/licenses_event.dart';
import 'package:codename_ttportal/licenses/model/license_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LicensesBody extends StatefulWidget {
  const LicensesBody({super.key});
  @override
  _LicensesBodyState createState() => _LicensesBodyState();
}

class _LicensesBodyState extends State<LicensesBody> {
  List<Company> companies = [];
  bool isLoadingCompanies = true;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    try {
      companies =
          await CompanyService().getCompanies(pageNumber: 1, pageSize: 100);
    } catch (error) {
      // Handle error accordingly.
    } finally {
      setState(() {
        isLoadingCompanies = false;
      });
    }
  }

  Future<void> _showLicenseCountForCompany(Company company) async {
    final licensesData = await context
        .read<LicensesBloc>()
        .service
        .getLicenses(pageNumber: 1, pageSize: 1000);
    final count = licensesData.results
        .where((lic) => lic.companyId == company.companyName)
        .length;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Licenses for ${company.companyName}"),
        content: Text("There are $count licenses assigned."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Widget _buildCreateLicenseDialog(BuildContext context) {
    return _CreateLicenseDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Licenses',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: isLoadingCompanies
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(companies[index].companyName),
                  onTap: () => _showLicenseCountForCompany(companies[index]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _buildCreateLicenseDialog(context),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CreateLicenseDialog extends StatefulWidget {
  @override
  __CreateLicenseDialogState createState() => __CreateLicenseDialogState();
}

class __CreateLicenseDialogState extends State<_CreateLicenseDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedCompanyId;
  int? amountOfLicenses;
  DateTime? expirationDate;
  List<Company> companies = [];
  bool isLoadingCompanies = true;

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  Future<void> _fetchCompanies() async {
    try {
      companies =
          await CompanyService().getCompanies(pageNumber: 1, pageSize: 100);
    } catch (e) {
      // Handle error accordingly.
    } finally {
      setState(() {
        isLoadingCompanies = false;
      });
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        expirationDate = picked;
      });
    }
  }

  void _createLicense() {
    if (_formKey.currentState!.validate() && expirationDate != null) {
      _formKey.currentState!.save();
      final license = License(
        companyId: selectedCompanyId!,
        amountOfLicenses: amountOfLicenses!,
        expirationDate: expirationDate!,
      );
      context.read<LicensesBloc>().add(CreateLicenseEvent(license));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create License"),
      content: isLoadingCompanies
          ? const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      hint: const Text("Select Company"),
                      value: selectedCompanyId,
                      items: companies.map((company) {
                        return DropdownMenuItem(
                          value: company.companyName,
                          child: Text(company.companyName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCompanyId = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? "Please select a company" : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Amount of Licenses"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter an amount";
                        }
                        if (int.tryParse(value) == null) {
                          return "Enter a valid number";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        amountOfLicenses = int.tryParse(value!);
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(expirationDate == null
                              ? "Select Expiration Date"
                              : expirationDate!
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]),
                        ),
                        IconButton(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_today),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _createLicense,
          child: const Text("Create"),
        ),
      ],
    );
  }
}
