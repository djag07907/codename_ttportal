import 'package:cdbi/admin/widget/admin_body.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  final String userName;
  const AdminScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return AdminBody(userName: userName);
  }
}
