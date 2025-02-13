import 'package:cdbi/common/bloc/base_state.dart';
import 'package:cdbi/common/loader/loader.dart';
import 'package:cdbi/common/utils/token_decryptor.dart';
import 'package:cdbi/home/bloc/home_bloc.dart';
import 'package:cdbi/repository/user_repository.dart';
import 'package:cdbi/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:cdbi/login/model/user.dart';
import 'package:cdbi/common/cards/dashboard_card.dart';
import 'package:cdbi/login/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBody extends StatefulWidget {
  final User user;

  const HomeBody({
    super.key,
    required this.user,
  });

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late HomeBloc _homeBloc;
  late User user;

  @override
  void initState() {
    super.initState();
    _homeBloc = context.read<HomeBloc>();
    user = widget.user;
    final userId = TokenDecryptor.getUserId(user.token);

    if (userId != null) {
      _homeBloc.add(
        FetchUserDetailsById(
          userId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user.userName}'),
        backgroundColor: tectransblue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: BlocListener<HomeBloc, BaseState>(
        listener: (context, state) {
          if (state is UserDetailsFetchSuccess) {
            _homeBloc.add(
              FetchDashboardsByCompanyId(
                state.companyId,
              ),
            );
          }
          if (state is LicenseExpiredError) {
            _showLicenseExpiredDialog();
          }
        },
        child: BlocBuilder<HomeBloc, BaseState>(
          builder: (context, state) {
            if (state is HomeInProgress) {
              return const Loader();
            }
            if (state is DashboardsFetchSuccess) {
              final dashboards = state.dashboard;
              return dashboards.isEmpty
                  ? const Center(
                      child: Text('No dashboards available for your account.'),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: dashboards.length,
                        itemBuilder: (context, index) {
                          return DashboardCard(
                            dashboard: dashboards[index],
                          );
                        },
                      ),
                    );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final userRepository = UserRepository();
    await userRepository.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _showLicenseExpiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('License Expired'),
          content: const Text(
              'Your license has expired. Please contact the provider.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
