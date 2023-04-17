import 'package:dartz/dartz.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he/survey/bloc/survey_bloc.dart';

class SaveSurveyWidget extends StatelessWidget {
  final BuildContext scaffoldContext;
  final bool showLoadingSnackBar;
  final Function onSaveSuccess;
  final Function(String) onSaveFailure;
  const SaveSurveyWidget({
    Key? key,
    required this.scaffoldContext,
    required this.showLoadingSnackBar,
    required this.onSaveSuccess,
    required this.onSaveFailure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final surveyBloc = BlocProvider.of<SurveyBloc>(context);
    return StreamBuilder<Either<Failure, String>?>(
      stream: surveyBloc.surveySaveResultStream,
      builder: (BuildContext context,
          AsyncSnapshot<Either<Failure, String>?> snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data;
          result?.fold((failure) {
            // Call the onSaveFailure function when an error occurs
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(failure.message),
                  duration: const Duration(days: 365),
                  action: SnackBarAction(
                    label: 'Exit',
                    textColor: Colors.white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      context.flow<SurveyState>().complete();
                    },
                  ),
                ),
              );
            });
          }, (successId) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              ScaffoldMessenger.of(scaffoldContext)
                  .showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(50),
                      content: Text("Saved survey ID: $successId",
                          style: GoogleFonts.lato()),
                      duration: const Duration(seconds: 2),
                    ),
                  )
                  .closed
                  .then((_) {
                Future.delayed(const Duration(seconds: 2), () {
                  // Change this line
                  surveyBloc.add(
                      const SurveyReset(resetSurveySaveSuccessStream: true));
                }).then((_) {
                  context.flow<SurveyState>().complete();
                });
              });
            });
            // Handle the success case
          });
        } else if (showLoadingSnackBar) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  backgroundColor: Colors.blueAccent,
                  content: SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      child: Center(child: SpinKitWave(color: Colors.green)),
                    ),
                    // width: 60,
                    // height: 60,
                  )),
            );
          });
        }
        return const SizedBox.shrink();
      },
    );
  }
}
