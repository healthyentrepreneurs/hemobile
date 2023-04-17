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
                  content: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.error, color: Colors.white),
                      Text("Failed To Save"),
                    ],
                  ),
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
                      backgroundColor: Colors.green.shade300,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(10),
                      content: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.add, color: Colors.white),
                                const SizedBox(
                                    width:
                                        8), // Add a little space between the icon and the text
                                Text(
                                  "survey saved",
                                  style: GoogleFonts.lato(fontSize: 16),
                                ),
                              ],
                            ),
                            const Icon(Icons.check_circle_outline,
                                color: Colors.white),
                          ],
                        ),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  )
                  .closed
                  .then((_) {
                Future.delayed(const Duration(seconds: 2), () {
                  surveyBloc.add(
                      const SurveyReset(resetSurveySaveSuccessStream: true));
                }).then((_) {
                  context.flow<SurveyState>().complete();
                });
              });
            });
          });
        } else if (showLoadingSnackBar) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.blue.shade300,
                behavior: SnackBarBehavior.floating,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.file_copy, color: Colors.white),
                        const SizedBox(
                            width:
                                8), // Add a little space between the icon and the text
                        Text(
                          'saving survey',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SpinKitWave(color: Colors.green, size: 15),
                  ],
                ),
              ),
            );
          });
        }
        return const SizedBox.shrink();
      },
    );
  }
}
