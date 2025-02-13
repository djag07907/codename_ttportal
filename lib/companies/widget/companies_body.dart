import 'package:cdbi/common/bloc/base_state.dart';
import 'package:cdbi/common/loader/loader.dart';
import 'package:cdbi/companies/bloc/companies_bloc.dart';
import 'package:cdbi/companies/model/company_model.dart';
import 'package:cdbi/repository/respository_constants.dart';
import 'package:cdbi/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompaniesBody extends StatefulWidget {
  const CompaniesBody({super.key});

  @override
  _CompaniesBodyState createState() => _CompaniesBodyState();
}

class _CompaniesBodyState extends State<CompaniesBody> {
  List<Company> companies = [];
  late CompanyBloc _companyBloc;

  @override
  void initState() {
    super.initState();
    _companyBloc = context.read<CompanyBloc>();
    _fetchCompanies();
  }

  void _fetchCompanies() {
    _companyBloc.add(
      const FetchCompaniesEvent(
        pageNumber: 1,
        pageSize: 100,
      ),
    );
  }

  void _editCompany(Company company) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<CompanyBloc>(context),
        child: _CompaniesDialog(
          company: company,
          onSave: (Company updatedCompany) {
            //TODO: Implement edit endpoint
          },
        ),
      ),
    );
  }

  void _deleteCompany(Company company) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Company'),
        content:
            Text('Are you sure you want to delete ${company.companyName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              //TODO: Implement deletion logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Companies Management',
          style: TextStyle(
            color: black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: transparent,
      ),
      body: BlocListener<CompanyBloc, BaseState>(
        listener: (context, state) {
          if (state is CompanyCreationSuccess) {
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
        child: BlocBuilder<CompanyBloc, BaseState>(
          builder: (context, state) {
            if (state is CompanyInProgress) {
              return const Loader();
            }
            if (state is CompaniesFetchSuccess) {
              companies = state.companies;
              if (companies.isEmpty) {
                return const Center(
                  child: Text('There is no data yet.'),
                );
              }
              return ListView.builder(
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  final company = companies[index];
                  return ListTile(
                    title: Text(company.companyName),
                    subtitle: Text(
                        '${company.dashboardName} - ${company.dashboardCode}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: tectransblue,
                          ),
                          onPressed: () => _editCompany(company),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: red,
                          ),
                          onPressed: () => _deleteCompany(company),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const Center(
              child: Text('No data available.'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (dialogContext) => BlocProvider.value(
              value: BlocProvider.of<CompanyBloc>(context),
              child: _CompaniesDialog(
                onSave: (Company newCompany) {
                  context.read<CompanyBloc>().add(
                        CreateCompanyEvent(newCompany),
                      );
                },
              ),
            ),
          );
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
          Icons.add_business,
          size: 30,
          color: white,
        ),
      ),
    );
  }
}

class _CompaniesDialog extends StatefulWidget {
  final Company? company;
  final Function(Company) onSave;

  const _CompaniesDialog({
    this.company,
    required this.onSave,
  });

  @override
  __CompaniesDialogState createState() => __CompaniesDialogState();
}

class __CompaniesDialogState extends State<_CompaniesDialog> {
  final _formKey = GlobalKey<FormState>();
  late int companyId;
  late String companyName;
  late String dashboardName;
  late String dashboardCode;
  late String dashboardLink;

  @override
  void initState() {
    super.initState();
    companyName = widget.company?.companyName ?? emptyString;
    dashboardName = widget.company?.dashboardName ?? emptyString;
    dashboardCode = widget.company?.dashboardCode ?? emptyString;
    dashboardLink = widget.company?.dashboardLink ?? emptyString;
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
        child: Text(
          widget.company == null ? 'Add Company' : 'Edit Company',
          style: const TextStyle(
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
                _buildTextField(
                  label: 'Company Name',
                  initialValue: companyName,
                  icon: Icons.business,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a company name'
                      : null,
                  onSaved: (value) => companyName = value!,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Dashboard Name',
                  initialValue: dashboardName,
                  icon: Icons.dashboard,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a dashboard name'
                      : null,
                  onSaved: (value) => dashboardName = value!,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Dashboard Code',
                  initialValue: dashboardCode,
                  icon: Icons.aod,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a dashboard code'
                      : null,
                  onSaved: (value) => dashboardCode = value!,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Dashboard Link',
                  initialValue: dashboardLink,
                  icon: Icons.link,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a dashboard link'
                      : null,
                  onSaved: (value) => dashboardLink = value!,
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
            'Cancel',
            style: TextStyle(
              color: gray,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final company = Company(
                companyName: companyName,
                dashboardName: dashboardName,
                dashboardCode: dashboardCode,
                dashboardLink: dashboardLink,
              );
              widget.onSave(company);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: white,
            backgroundColor: tectransblue,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
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
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: grayBackground,
          ),
          prefixIcon: Icon(
            icon,
            color: tectransblue,
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
}
