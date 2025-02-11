import 'package:codename_ttportal/common/bloc/base_state.dart';
import 'package:codename_ttportal/common/loader/loader.dart';
import 'package:codename_ttportal/licenses/bloc/licenses_bloc.dart';

import 'package:codename_ttportal/licenses/model/company_model.dart';
import 'package:codename_ttportal/licenses/model/license_model.dart';
import 'package:codename_ttportal/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LicensesBody extends StatefulWidget {
  const LicensesBody({super.key});

  @override
  _LicensesBodyState createState() => _LicensesBodyState();
}

class _LicensesBodyState extends State<LicensesBody> {
  late LicensesBloc _licensesBloc;

  // @override
  // void initState() {
  //   super.initState();
  //   context.read<LicensesBloc>().add(
  //         FetchCompaniesEvent(
  //           pageNumber: 1,
  //           pageSize: 100,
  //         ),
  //       );
  //   context.read<LicensesBloc>().add(
  //         FetchLicensesEvent(
  //           pageNumber: 1,
  //           pageSize: 100,
  //         ),
  //       );
  // }
  @override
  void initState() {
    super.initState();
    _licensesBloc = context.read<LicensesBloc>();
    _fetchCompanies();
  }

  void _fetchCompanies() {
    _licensesBloc.add(
      const FetchCompaniesEvent(
        pageNumber: 1,
        pageSize: 100,
      ),
    );
  }

  void _createLicense(List<Company> companies) {
    showDialog(
      context: context,
      builder: (dialogContext) => _CreateLicenseDialog(
        onSave: (License newLicense) {
          context.read<LicensesBloc>().add(
                CreateLicenseEvent(
                  newLicense,
                ),
              );
        },
        companies: companies,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Licenses Management',
          style: TextStyle(
            color: black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: transparent,
      ),
      body: BlocListener<LicensesBloc, BaseState>(
        listener: (context, state) {
          if (state is LicenseCreationSuccess) {
            _fetchCompanies();
          }
          if (state is CompaniesFetchError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
              ),
            );
          }
        },
        child: BlocBuilder<LicensesBloc, BaseState>(
          builder: (context, state) {
            if (state is LicensesInProgress) {
              return const Loader();
            }
            if (state is CompaniesFetchSuccess) {
              return ListView.builder(
                itemCount: state.companies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      state.companies[index].companyName,
                    ),
                  );
                },
              );
            }
            // if (state is CompaniesFetchError) {
            //   return Center(
            //     child: Text('Error fetching companies: ${state.error}'),
            //   );
            // }
            return const Center(
              child: Text('No companies available.'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final state = context.read<LicensesBloc>().state;
          if (state is CompaniesFetchSuccess) {
            _createLicense(state.companies);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CreateLicenseDialog extends StatefulWidget {
  final Function(License) onSave;
  final List<Company> companies;

  const _CreateLicenseDialog({
    required this.onSave,
    required this.companies,
  });

  @override
  __CreateLicenseDialogState createState() => __CreateLicenseDialogState();
}

class __CreateLicenseDialogState extends State<_CreateLicenseDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedCompanyId;
  int? amountOfLicenses;
  DateTime? expirationDate;

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
      widget.onSave(license);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create License"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                hint: const Text("Select Company"),
                value: selectedCompanyId,
                items: widget.companies.map((company) {
                  return DropdownMenuItem<String>(
                    value: company.companyId.toString(),
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
                  labelText: "Amount of Licenses",
                ),
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
                    child: Text(
                      expirationDate == null
                          ? "Select Expiration Date"
                          : expirationDate!.toLocal().toString().split(' ')[0],
                    ),
                  ),
                  IconButton(
                    onPressed: _pickDate,
                    icon: const Icon(
                      Icons.calendar_today,
                    ),
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
