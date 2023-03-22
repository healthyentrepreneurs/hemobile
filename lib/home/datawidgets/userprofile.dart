import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/app/bloc/app_bloc.dart';

const _onboardingInfoHeroTag = '__onboarding_info_hero_tag__';

enum OnboardingState {
  initial,
  welcomeComplete,
  usageComplete,
  onboardingComplete,
}

class UserProfile extends StatelessWidget {
  final String userid;
  final FlowController<AppState> flowController;
  const UserProfile(
      {Key? key, required this.userid, required this.flowController})
      : super(key: key);

  static Page page(
      {required String userid,
      required FlowController<AppState> flowController}) {
    return MaterialPage(
      child: UserProfile(userid: userid, flowController: flowController),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlowBuilder<AppState>(
      controller: flowController,
      state: context.select((AppBloc bloc) => bloc.state),
      onGeneratePages: (state, pages) {
        switch (state.status) {
          default:
            return [
              OnboardingWelcome.page(),
            ];
        }
        // Add your onGeneratePages logic here for UserProfile
      },
    );
  }
}

class OnboardingWelcome extends StatelessWidget {
  const OnboardingWelcome._();

  static Page<void> page() => const MyPage<void>(child: OnboardingWelcome._());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.flow<OnboardingState>().complete(),
        ),
        title: const Text('Welcome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome Text',
                    style: theme.textTheme.headline3,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: FloatingActionButton(
                heroTag: _onboardingInfoHeroTag,
                backgroundColor: Colors.orange,
                child: const Icon(Icons.info),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 0,
            onPressed: () => context.flow<OnboardingState>().complete(),
            child: const Icon(Icons.clear),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            heroTag: 1,
            onPressed: () {
              context
                  .flow<OnboardingState>()
                  .update((_) => OnboardingState.welcomeComplete);
            },
            child: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }
}

class MyPage<T> extends Page<T> {
  const MyPage({required this.child, super.key});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
