import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/course/section/view/view.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/home/datawidgets/userlanding.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he_api/he_api.dart';
import '../../course/section/bloc/section_bloc.dart';
import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import '../../survey/bloc/survey_bloc.dart';
import '../../survey/widgets/surveypagebrowser.dart';
import '../flow_models/user_prof_model.dart';
import '../widgets/widgets.dart';

List<Page<dynamic>> onGenerateProfilePages(
  UserProfileModel profile,
  List<Page<dynamic>> pages,
) {
  return [
    const MaterialPage<void>(child: UserProfile(), name: '/userprofile'),
    if (profile.subscription!.isNotEmpty) const MaterialPage<void>(child: ProfileAgeForm()),
    if (profile.subscription!.isEmpty)
      const MaterialPage<void>(child: ProfileWeightForm()),
  ];
}

class ProfileFlow extends StatelessWidget {
  const ProfileFlow._();

  static Route<UserProfileModel> route() {
    return MaterialPageRoute(builder: (_) => const ProfileFlow._());
  }

  @override
  Widget build(BuildContext context) {
    return const FlowBuilder<UserProfileModel>(
      state: UserProfileModel(),
      onGeneratePages: onGenerateProfilePages,
    );
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _ProfileNameFormState();
}

class _ProfileNameFormState extends State<UserProfile> {
  var _name = '';

  void _continuePressed() {
    final henetwork = BlocProvider.of<HenetworkBloc>(context).state.status;
    context
        .flow<UserProfileModel>()
        .update((profile) => profile.copyWith(henetworkStatus: henetwork));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.flow<UserProfileModel>().complete(),
        ),
        title: const Text('Name'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (value) => setState(() => _name = value),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'John Doe',
                ),
              ),
              ElevatedButton(
                onPressed: _name.isNotEmpty ? _continuePressed : null,
                child: const Text('Continue'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileAgeForm extends StatefulWidget {
  const ProfileAgeForm({super.key});

  @override
  State<ProfileAgeForm> createState() => _ProfileAgeFormState();
}

class _ProfileAgeFormState extends State<ProfileAgeForm> {
  int? _age;

  void _continuePressed() {
    context.flow<UserProfileModel>().update((profile) => profile.copyWith(subscription: Subscription.empty));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (value) => setState(() => _age = int.parse(value)),
                decoration: const InputDecoration(
                  labelText: 'Age',
                  hintText: '42',
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: _age != null ? _continuePressed : null,
                child: const Text('Continue'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileWeightForm extends StatefulWidget {
  const ProfileWeightForm({super.key});

  @override
  State<ProfileWeightForm> createState() => _ProfileWeightFormState();
}

class _ProfileWeightFormState extends State<ProfileWeightForm> {
  int? _weight;

  void _continuePressed() {
    context
        .flow<UserProfileModel>()
        .complete((profile) => profile.copyWith(subscription: Subscription.empty));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weight')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() => _weight = int.tryParse(value));
                },
                decoration: const InputDecoration(
                  labelText: 'Weight (lbs)',
                  hintText: '170',
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: _weight != null ? _continuePressed : null,
                child: const Text('Continue'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
