import 'package:codename_ttportal/common/bloc/base_state.dart';
import 'package:codename_ttportal/common/user_dialog.dart';
import 'package:codename_ttportal/user/bloc/user_bloc.dart';
import 'package:codename_ttportal/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBody extends StatefulWidget {
  const UserBody({super.key});

  @override
  State<UserBody> createState() => _UserBodyState();
}

class _UserBodyState extends State<UserBody> {
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = context.read<UserBloc>();
    _userBloc.add(
      const FetchUsersEvent(
        pageNumber: 1,
        pageSize: 100,
      ),
    );
    _userBloc.add(
      const FetchCompaniesEvent(
        pageNumber: 1,
        pageSize: 100,
      ),
    );
  }

  void _addUser() {
    showDialog(
      context: context,
      builder: (context) => UserDialog(
        onSave: (User user) {
          context.read<UserBloc>().add(
                CreateUserEvent(user),
              );
        },
      ),
    );
  }

  void _editUser(User user) {
    showDialog(
      context: context,
      builder: (context) => UserDialog(
        user: user,
        onSave: (User updatedUser) {
          // context.read<UserBloc>().add(UpdateUserEvent(updatedUser));
        },
      ),
    );
  }

  void _deleteUser(String userId) {
    // Handle user deletion logic here
    // context.read<UserBloc>().add(DeleteUserEvent(userId));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userBloc = context.read<UserBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Management Users',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: BlocListener<UserBloc, BaseState>(
        listener: (context, state) {
          if (state is UserCreationSuccess) {
            // Fetch users again after a user is created
            context.read<UserBloc>().add(const FetchUsersEvent());
          }
          if (state is UsersFetchError) {
            // Show an error message if fetching users fails
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: BlocBuilder<UserBloc, BaseState>(
          builder: (context, state) {
            if (state is UsersFetchSuccess) {
              final users = state.users;
              if (users.isEmpty) {
                return const Center(child: Text('There is no data yet.'));
              }
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
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
                          onPressed: () => _deleteUser(user.id ?? ''),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            if (state is UsersFetchError) {
              return Center(
                child: Text('Error: ${state.error}'),
              );
            }
            return const Center(
              child: Text('No data available.'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}
