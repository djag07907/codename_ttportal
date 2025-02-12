import 'package:codename_ttportal/common/loader/loader.dart';
import 'package:codename_ttportal/repository/respository_constants.dart';
import 'package:codename_ttportal/resources/colors.dart';
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
      title: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: tectransblue,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          widget.user == null ? 'Add User' : 'Edit User',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'Username',
                  initialValue: username,
                  icon: Icons.person_outline,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter a name'
                      : null,
                  onSaved: (value) => username = value!,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Email',
                  initialValue: email,
                  icon: Icons.email_outlined,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter an email'
                      : null,
                  onSaved: (value) => email = value!,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Password',
                  initialValue: password,
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter a password'
                      : null,
                  onSaved: (value) => password = value!,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
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
                    activeColor: tectransblue,
                    contentPadding: const EdgeInsets.all(16),
                  ),
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
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<String>(
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
                              if (!isAdmin &&
                                  (value == null || value.isEmpty)) {
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
                        ),
                ],
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
          onPressed: _save,
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
    bool obscureText = false,
    bool isPassword = false,
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
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: grayBackground,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
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
        obscureText: isPassword && obscureText,
      ),
    );
  }
}
