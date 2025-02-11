import 'package:codename_ttportal/common/bloc/base_state.dart';
import 'package:codename_ttportal/common/loader/loader.dart';
import 'package:codename_ttportal/companies/bloc/companies_bloc.dart';
import 'package:codename_ttportal/companies/model/company_model.dart';
import 'package:codename_ttportal/resources/colors.dart';
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
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              //TODO: Implement deletion logic
              Navigator.pop(context);
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
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editCompany(company),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
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
        child: const Icon(Icons.add),
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
    companyName = widget.company?.companyName ?? '';
    dashboardName = widget.company?.dashboardName ?? '';
    dashboardCode = widget.company?.dashboardCode ?? '';
    dashboardLink = widget.company?.dashboardLink ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.company == null ? 'Add Company' : 'Edit Company'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: companyName,
                decoration: const InputDecoration(labelText: 'Company Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a company name'
                    : null,
                onSaved: (value) => companyName = value!,
              ),
              TextFormField(
                initialValue: dashboardName,
                decoration: const InputDecoration(labelText: 'Dashboard Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a dashboard name'
                    : null,
                onSaved: (value) => dashboardName = value!,
              ),
              TextFormField(
                initialValue: dashboardCode,
                decoration: const InputDecoration(labelText: 'Dashboard Code'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a dashboard code'
                    : null,
                onSaved: (value) => dashboardCode = value!,
              ),
              TextFormField(
                initialValue: dashboardLink,
                decoration: const InputDecoration(labelText: 'Dashboard Link'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a dashboard link'
                    : null,
                onSaved: (value) => dashboardLink = value!,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
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
          child: const Text('Save'),
        ),
      ],
    );
  }
}
