import 'package:codename_ttportal/dashboard/model/dashboard_model.dart';
import 'package:codename_ttportal/user/model/user_model.dart';
import 'package:flutter/material.dart';

class UserDialog extends StatefulWidget {
  final User? user;
  final Function(User) onSave;
  final List<Dashboard> availableDashboards;

  const UserDialog({
    super.key,
    this.user,
    required this.onSave,
    required this.availableDashboards,
  });

  @override
  _UserDialogState createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  late bool isAdmin;
  late List<String> assignedDashboardIds;

  @override
  void initState() {
    super.initState();
    email = widget.user?.email ?? '';
    password = widget.user?.password ?? '';
    isAdmin = widget.user?.isAdmin ?? false;
    assignedDashboardIds = widget.user?.assignedDashboardIds ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an email' : null,
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                initialValue: password,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a password' : null,
                onSaved: (value) => password = value!,
              ),
              CheckboxListTile(
                title: const Text('Admin'),
                value: isAdmin,
                onChanged: (value) => setState(() => isAdmin = value!),
              ),
              const SizedBox(height: 10),
              const Text('Assigned Dashboards:'),
              ...widget.availableDashboards.map((dashboard) {
                return CheckboxListTile(
                  title: Text(dashboard.name),
                  value: assignedDashboardIds.contains(dashboard.id),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        assignedDashboardIds.add(dashboard.id);
                      } else {
                        assignedDashboardIds.remove(dashboard.id);
                      }
                    });
                  },
                );
              }).toList(),
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
              final user = User(
                id: widget.user?.id ?? DateTime.now().toString(),
                email: email,
                password: password,
                isAdmin: isAdmin,
                assignedDashboardIds: assignedDashboardIds,
              );
              widget.onSave(user);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
