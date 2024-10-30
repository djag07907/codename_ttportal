import 'package:codename_ttportal/dashboard/model/dashboard_model.dart';
import 'package:codename_ttportal/services/local_storage.dart';
import 'package:flutter/material.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  _DashboardBodyState createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  final _formKey = GlobalKey<FormState>();
  late String name, id, codename, link;
  final LocalStorageService _storageService = LocalStorageService();
  List<Dashboard> dashboards = [];

  @override
  void initState() {
    super.initState();
    _loadDashboards();
  }

  Future<void> _loadDashboards() async {
    dashboards = await _storageService.getDashboards();
    setState(() {});
  }

  void _addDashboard() {
    showDialog(
      context: context,
      builder: (context) => _DashboardDialog(
        onSave: (Dashboard dashboard) async {
          await _storageService.addDashboard(dashboard);
          _loadDashboards();
        },
      ),
    );
  }

  void _editDashboard(Dashboard dashboard) {
    showDialog(
      context: context,
      builder: (context) => _DashboardDialog(
        dashboard: dashboard,
        onSave: (Dashboard updatedDashboard) async {
          await _storageService.updateDashboard(updatedDashboard);
          _loadDashboards();
        },
      ),
    );
  }

  void _deleteDashboard(Dashboard dashboard) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Dashboard'),
        content: Text('Are you sure you want to delete ${dashboard.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _storageService.deleteDashboard(dashboard.id);
              Navigator.pop(context);
              _loadDashboards();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Dashboards')),
      body: ListView.builder(
        itemCount: dashboards.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dashboards[index].name),
            subtitle: Text(dashboards[index].codename),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editDashboard(dashboards[index]),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteDashboard(dashboards[index]),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDashboard,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DashboardDialog extends StatefulWidget {
  final Dashboard? dashboard;
  final Function(Dashboard) onSave;

  const _DashboardDialog({this.dashboard, required this.onSave});

  @override
  __DashboardDialogState createState() => __DashboardDialogState();
}

class __DashboardDialogState extends State<_DashboardDialog> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String codename;
  late String link;

  @override
  void initState() {
    super.initState();
    name = widget.dashboard?.name ?? '';
    codename = widget.dashboard?.codename ?? '';
    link = widget.dashboard?.link ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.dashboard == null ? 'Add Dashboard' : 'Edit Dashboard'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a name' : null,
              onSaved: (value) => name = value!,
            ),
            TextFormField(
              initialValue: codename,
              decoration: const InputDecoration(labelText: 'Codename'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a codename' : null,
              onSaved: (value) => codename = value!,
            ),
            TextFormField(
              initialValue: link,
              decoration: const InputDecoration(labelText: 'Link'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a link' : null,
              onSaved: (value) => link = value!,
            ),
          ],
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
              final dashboard = Dashboard(
                id: widget.dashboard?.id ?? DateTime.now().toString(),
                name: name,
                codename: codename,
                link: link,
              );
              widget.onSave(dashboard);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
