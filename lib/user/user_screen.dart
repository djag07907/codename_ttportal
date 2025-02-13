import 'package:cdbi/user/bloc/user_bloc.dart';
import 'package:cdbi/user/widget/user_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(),
      child: const UserBody(),
    );
  }
}
