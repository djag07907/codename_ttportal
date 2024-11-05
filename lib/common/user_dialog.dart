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
  late String username;
  late String email;
  late String password;
  late bool isAdmin;
  late List<String> assignedDashboardIds;

  @override
  void initState() {
    super.initState();
    username = widget.user?.username ?? '';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: username,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => username = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an email' : null,
                onSaved: (value) => email = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: password,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a password' : null,
                onSaved: (value) => password = value!,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Admin'),
                value: isAdmin,
                onChanged: (value) => setState(() => isAdmin = value),
              ),
              const SizedBox(height: 16),
              const Text('Assigned Dashboards:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                username: username,
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
