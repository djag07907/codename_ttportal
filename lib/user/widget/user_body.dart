import 'package:codename_ttportal/common/user_dialog.dart';
import 'package:codename_ttportal/user/bloc/user_bloc.dart';
import 'package:codename_ttportal/user/bloc/user_event.dart';
import 'package:codename_ttportal/user/bloc/user_state.dart';
import 'package:codename_ttportal/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBody extends StatefulWidget {
  const UserBody({super.key});
  @override
  State<UserBody> createState() => _UserBodyState();
}

class _UserBodyState extends State<UserBody> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const FetchUsersEvent());
  }

  void _addUser() {
    final parentContext = context;
    showDialog(
      context: parentContext,
      builder: (context) => UserDialog(
        onSave: (User user) {
          parentContext.read<UserBloc>().add(
                CreateUserEvent(user),
              );
        },
      ),
    ).then((_) {
      parentContext.read<UserBloc>().add(
            const FetchUsersEvent(),
          );
    });
  }

  void _editUser(User user) {
    showDialog(
      context: context,
      builder: (context) => UserDialog(
        user: user,
        onSave: (User updatedUser) {
          context.read<UserBloc>().add(CreateUserEvent(updatedUser));
        },
      ),
    ).then((_) {
      context.read<UserBloc>().add(
            const FetchUsersEvent(),
          );
    });
  }

  void _deleteUser(String userId) {}

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
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserOperationInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UsersFetchSuccess) {
            final users = state.users;
            if (users.isEmpty) {
              return const Center(
                child: Text('There is no data yet.'),
              );
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
          } else if (state is UsersFetchError) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}
