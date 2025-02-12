import 'package:codename_ttportal/common/bloc/base_state.dart';
import 'package:codename_ttportal/common/loader/loader.dart';
import 'package:codename_ttportal/common/dialogs/user_dialog.dart';
import 'package:codename_ttportal/repository/respository_constants.dart';
import 'package:codename_ttportal/resources/colors.dart';
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
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _userBloc = context.read<UserBloc>();
    _fetchUsers();
  }

  void _fetchUsers() {
    _userBloc.add(
      const FetchUsersEvent(
        pageNumber: 1,
        pageSize: 100,
      ),
    );
  }

  void _addUser() {
    showDialog(
      context: context,
      builder: (context) => UserDialog(
        userBloc: _userBloc,
        onSave: (User user) {
          _userBloc.add(
            CreateUserEvent(
              user,
            ),
          );
        },
      ),
    );
  }

  void _editUser(User user) {
    showDialog(
      context: context,
      builder: (context) => UserDialog(
        userBloc: _userBloc,
        user: user,
        onSave: (User updatedUser) {},
      ),
    );
  }

  void _deleteUser(String userId) {
    // TODO: Implement user delete logic
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
          'Users Management',
          style: TextStyle(
            color: black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: transparent,
      ),
      body: BlocListener<UserBloc, BaseState>(
        listener: (context, state) {
          if (state is UserCreationSuccess) {
            _fetchUsers();
          }
          if (state is UsersFetchError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
              ),
            );
          }
        },
        child: BlocBuilder<UserBloc, BaseState>(
          builder: (context, state) {
            if (state is UserInProgress) {
              return const Loader();
            }
            if (state is UsersFetchSuccess) {
              users = state.users;
              if (users.isEmpty) {
                return const Center(
                  child: Text('There is no data yet.'),
                );
              }
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(user.email),
                        subtitle: Text(user.isAdmin ? 'Admin' : 'Regular User'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: tectransblue,
                              ),
                              onPressed: () => _editUser(user),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: red,
                              ),
                              onPressed: () =>
                                  _deleteUser(user.id ?? emptyString),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                        child: Text(
                          'Additional Info: ${user.companyName}',
                          style: const TextStyle(
                            color: grayBackground,
                          ),
                        ),
                      ),
                    ],
                  );
                },
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
        backgroundColor: tectransblue,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ),
          side: const BorderSide(
            color: white,
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.person_add_alt,
          size: 30,
          color: white,
        ),
      ),
    );
  }
}
