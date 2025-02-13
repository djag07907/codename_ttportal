import 'package:cdbi/companies/bloc/companies_bloc.dart';
import 'package:cdbi/companies/widget/companies_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompaniesScreen extends StatelessWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CompanyBloc(),
      child: const CompaniesBody(),
    );
  }
}
