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
        backgroundColor: tectransblue,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ),
          side: const BorderSide(
            color: white,
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.addchart,
          size: 30,
          color: white,
        ),
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
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: tectransblue,
              width: 2.0,
            ),
          ),
        ),
        child: const Text(
          "Create License",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: tectransblue,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: 450,
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDropdownField(
                  label: "Select Company",
                  value: selectedCompanyId,
                  icon: Icons.business,
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
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: "Amount of Licenses",
                  icon: Icons.format_list_numbered,
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          expirationDate == null
                              ? "Select Expiration Date"
                              : expirationDate!
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                          style: const TextStyle(
                            color: grayBackground,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _pickDate,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: white,
                        backgroundColor: tectransblue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: gray,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _createLicense,
          style: ElevatedButton.styleFrom(
            foregroundColor: white,
            backgroundColor: tectransblue,
          ),
          child: const Text("Create"),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextInputType keyboardType,
    required IconData icon,
    required String? Function(String?)? validator,
    required void Function(String?)? onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: tectransblue,
          ),
          labelStyle: const TextStyle(
            color: grayBackground,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: tectransblue,
          ),
          labelStyle: const TextStyle(
            color: grayBackground,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        value: value,
        items: items,
        onChanged: onChanged,
        validator: (value) => value == null ? "Please select a company" : null,
      ),
    );
  }
}
