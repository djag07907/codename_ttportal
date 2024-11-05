import 'package:codename_ttportal/common/user_dialog.dart';
import 'package:codename_ttportal/dashboard/model/dashboard_model.dart';
import 'package:codename_ttportal/services/local_storage.dart';
import 'package:codename_ttportal/user/model/user_model.dart';
import 'package:flutter/material.dart';

class UserBody extends StatefulWidget {
  const UserBody({super.key});

  @override
  State<UserBody> createState() => _UserBodyState();
}

class _UserBodyState extends State<UserBody> {
  final LocalStorageService _storageService = LocalStorageService();
  List<User> users = [];
  List<Dashboard> dashboards = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    users = await _storageService.getUsers();
    setState(() {});
  }

  void _addUser() {
    showDialog(
      context: context,
      builder: (context) => UserDialog(
        availableDashboards: dashboards,
        onSave: (User user) async {
          await _storageService.addUser(user);
          _loadUsers();
        },
      ),
    );
  }

  void _editUser(User user) {
    showDialog(
      context: context,
      builder: (context) => UserDialog(
        user: user,
        availableDashboards: dashboards,
        onSave: (User updatedUser) async {
          await _storageService.updateUser(updatedUser);
          _loadUsers();
        },
      ),
    );
  }

  void _deleteUser(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.email}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _storageService.deleteUser(user.id);
              Navigator.pop(context);
              _loadUsers();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadData() async {
    users = await _storageService.getUsers();
    dashboards = await _storageService.getDashboards();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Management Users',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: users.isEmpty
          ? const Center(
              child: Text(
                'There is no users data yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final assignedDashboards = dashboards
                    .where((d) => user.assignedDashboardIds.contains(d.id))
                    .toList();
                return ExpansionTile(
                  title: Text(user.email),
                  subtitle: Text(user.isAdmin ? 'Admin' : 'Regular User'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editUser(user),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteUser(user),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Assigned Dashboards:'),
                          ...assignedDashboards.map((d) => Text('- ${d.name}')),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}
