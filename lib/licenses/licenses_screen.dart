import 'package:codename_ttportal/licenses/bloc/licenses_bloc.dart';
import 'package:codename_ttportal/licenses/widget/licenses_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LicensesScreen extends StatelessWidget {
  const LicensesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LicensesBloc(),
      child: const LicensesBody(),
    );
  }
}
