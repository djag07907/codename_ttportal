import 'package:codename_ttportal/dashboard/bloc/dashboards_bloc.dart';
import 'package:codename_ttportal/dashboard/bloc/dashboards_event.dart';
import 'package:codename_ttportal/dashboard/bloc/dashboards_state.dart';
import 'package:codename_ttportal/dashboard/model/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  _DashboardBodyState createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  // final _formKey = GlobalKey<FormState>();
  late String name, id, dashboardCode, link;
  List<Dashboard> dashboards = [];

  @override
  void initState() {
    super.initState();
    _loadDashboards();
  }

  Future<void> _loadDashboards() async {
    context.read<DashboardsBloc>().add(
          const FetchDashboardsEvent(),
        );
  }

  void _addDashboard() {
    showDialog(
      context: context,
      builder: (context) => _DashboardDialog(
        onSave: (Dashboard dashboard) async {
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Manage Dashboards',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<DashboardsBloc, DashboardsState>(
        builder: (context, state) {
          if (state is DashboardsInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is DashboardsFetchSuccess) {
            final dashboards = state.dashboard;
            if (dashboards.isEmpty) {
              return const Center(
                child: Text(
                  'There is no data yet.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: dashboards.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dashboards[index].name),
                  subtitle: Text(dashboards[index].dashboardCode),
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
            );
          }
          if (state is DashboardsFetchError) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          }
          return const SizedBox();
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
  late String dashboardCode;
  late String link;

  @override
  void initState() {
    super.initState();
    name = widget.dashboard?.name ?? '';
    dashboardCode = widget.dashboard?.dashboardCode ?? '';
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
              initialValue: dashboardCode,
              decoration: const InputDecoration(labelText: 'Codename'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a dashboardCode' : null,
              onSaved: (value) => dashboardCode = value!,
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
                dashboardCode: dashboardCode,
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
