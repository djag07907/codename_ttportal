import 'package:codename_ttportal/common/utils/token_decryptor.dart';
import 'package:codename_ttportal/home/bloc/home_bloc.dart';
import 'package:codename_ttportal/home/bloc/home_event.dart';
import 'package:codename_ttportal/home/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:codename_ttportal/login/model/user.dart';
import 'package:codename_ttportal/common/dashboard_card.dart';
import 'package:codename_ttportal/login/login_screen.dart';
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
  late User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    final userId = TokenDecryptor.getUserId(user.token);
    print("User ID: $userId");

    if (userId != null) {
      print("Fetching user details for User ID: $userId");
      context.read<HomeBloc>().add(
            FetchUserDetailsById(
              userId,
            ),
          );
    } else {
      print("User ID is null. Please check the user token.");
    }

    print("User: $user");
    print("User Token: ${user.token}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user.userName}'),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is UserDetailsFetchSuccess) {
            context.read<HomeBloc>().add(
                  FetchDashboardsByCompanyId(
                    state.companyId,
                  ),
                );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
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
            return const Center(
              child: Text('Error loading dashboards'),
            );
          },
        ),
      ),
    );
  }
}
