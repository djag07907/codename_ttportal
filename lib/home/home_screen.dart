import 'package:codename_ttportal/home/bloc/home_bloc.dart';
import 'package:codename_ttportal/home/widget/home_body.dart';
import 'package:codename_ttportal/login/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: HomeBody(user: user),
    );
  }
}
