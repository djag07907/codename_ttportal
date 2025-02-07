import 'package:codename_ttportal/companies/bloc/companies_bloc.dart';
import 'package:codename_ttportal/companies/bloc/companies_event.dart';
import 'package:codename_ttportal/companies/bloc/companies_state.dart';
import 'package:codename_ttportal/companies/model/company_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompaniesBody extends StatefulWidget {
  const CompaniesBody({super.key});

  @override
  _CompaniesBodyState createState() => _CompaniesBodyState();
}

class _CompaniesBodyState extends State<CompaniesBody> {
  List<Company> companies = [];

  void _editCompany(Company company) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<CompanyBloc>(context),
        child: _CompaniesDialog(
          company: company,
          onSave: (Company updatedCompany) {
            // For editing, you might want to implement update functionality.
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
              // Implement deletion logic if needed.
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyBloc>().add(
            const FetchCompaniesEvent(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Companies',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: BlocListener<CompanyBloc, CompanyState>(
        listener: (context, state) {
          if (state is CompanyCreationSuccess) {
            // Refetch companies after a successful creation
            context.read<CompanyBloc>().add(
                  const FetchCompaniesEvent(),
                );
          }
          if (state is CompaniesFetchSuccess) {
            setState(() {
              companies = state.companies;
            });
          }
        },
        child: companies.isEmpty
            ? const Center(
                child: Text(
                  'There are no companies data yet.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
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
  const _CompaniesDialog({this.company, required this.onSave});

  @override
  __CompaniesDialogState createState() => __CompaniesDialogState();
}

class __CompaniesDialogState extends State<_CompaniesDialog> {
  final _formKey = GlobalKey<FormState>();
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
