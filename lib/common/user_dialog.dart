import 'package:codename_ttportal/common/loader/loader.dart';
import 'package:codename_ttportal/repository/respository_constants.dart';
import 'package:codename_ttportal/user/bloc/user_bloc.dart';
import 'package:codename_ttportal/user/model/company_model.dart';
import 'package:codename_ttportal/user/model/user_model.dart';
import 'package:codename_ttportal/user/service/user_service.dart';
import 'package:flutter/material.dart';

class UserDialog extends StatefulWidget {
  final User? user;
  final Function(User) onSave;
  final UserBloc userBloc;

  const UserDialog({
    super.key,
    this.user,
    required this.onSave,
    required this.userBloc,
  });

  @override
  _UserDialogState createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  final _formKey = GlobalKey<FormState>();
  late String username;
  late String email;
  late String password;
  late bool isAdmin;
  late String? selectedCompanyId;
  List<Company> companies = [];
  bool isLoadingCompanies = true;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    username = widget.user?.userName ?? emptyString;
    email = widget.user?.email ?? emptyString;
    password = widget.user?.password ?? emptyString;
    isAdmin = widget.user?.isAdmin ?? false;
    selectedCompanyId = widget.user?.companyId;
    _fetchCompanies();
  }

  Future<void> _fetchCompanies() async {
    setState(() {
      isLoadingCompanies = true;
    });
    try {
      companies = await UserService().getCompanies(
        pageNumber: 1,
        pageSize: 100,
      );
    } catch (error) {
      // Handle errors if needed
    } finally {
      setState(() {
        isLoadingCompanies = false;
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = User(
        userName: username,
        email: email,
        password: password,
        isAdmin: isAdmin,
        companyId: isAdmin ? null : selectedCompanyId,
        companyName: emptyString,
        id: widget.user?.id ?? DateTime.now().toString(),
      );
      widget.onSave(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final companyLabel =
        isAdmin ? 'Select Company (optional):' : 'Select Company (mandatory):';
    return AlertDialog(
      title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: username,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a name'
                    : null,
                onSaved: (value) => username = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter an email'
                    : null,
                onSaved: (value) => email = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a password'
                    : null,
                onSaved: (value) => password = value!,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Admin'),
                value: isAdmin,
                onChanged: (value) {
                  setState(() {
                    isAdmin = value;
                    if (isAdmin) {
                      selectedCompanyId = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              if (!isAdmin) ...[
                Text(
                  companyLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                isLoadingCompanies
                    ? const Loader()
                    : DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        hint: const Text("Choose a company"),
                        value: selectedCompanyId,
                        items: companies.map((company) {
                          return DropdownMenuItem<String>(
                            value: company.companyId,
                            child: Text(company.companyName),
                          );
                        }).toList(),
                        validator: (value) {
                          if (!isAdmin && (value == null || value.isEmpty)) {
                            return 'Please select a company';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedCompanyId = value;
                          });
                        },
                      ),
              ],
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
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
