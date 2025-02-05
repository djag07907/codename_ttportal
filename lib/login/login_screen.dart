import 'package:codename_ttportal/login/bloc/login_bloc.dart';
import 'package:codename_ttportal/login/widget/login_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: const LoginBody(),
    );
  }
}
