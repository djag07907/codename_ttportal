import 'package:codename_ttportal/home/widget/home_body.dart';
import 'package:codename_ttportal/login/model/user.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return HomeBody(user: user);
  }
}
