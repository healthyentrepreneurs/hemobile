import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:he/survey/bloc/survey_bloc.dart';

import '../../objects/blocs/blocs.dart';

class SaveSurveyWidget extends StatelessWidget {
  final BuildContext scaffoldContext;
  final Function onSaveSuccess;
  final Function(String) onSaveFailure;

  const SaveSurveyWidget({
    Key? key,
    required this.scaffoldContext,
    required this.onSaveSuccess,
    required this.onSaveFailure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveyBloc, SurveyState>(
      builder: (BuildContext context, SurveyState state) {
        final saveError = state.saveError;
        final surveySavedId = state.surveySavedId;
        if (saveError != null) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "Failed To Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    MaterialButton(
                      color: Colors.red,
                      elevation: 4, // Set the desired elevation value
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        'Exit',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        context.flow<SurveyState>().complete();
                      },
                    ),
                  ],
                ),
                duration: const Duration(days: 365),
              ),
            );
          });
        } else if (surveySavedId != null) {
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
                    duration: const Duration(seconds: 1),
                  ),
                )
                .closed
                .then((_) {
              Future.delayed(const Duration(seconds: 0), () {
                // BlocProvider.of<DatabaseBloc>(context)
                context
                    .read<StatisticsBloc>()
                    .add(const ListSurveyTesting(isPending: true));
                context
                    .read<SurveyBloc>()
                    .add(const SurveyReset(resetSurveySaveSuccess: true));
              }).then((_) {
                context.flow<SurveyState>().complete();
              });
            });
          });
        }
        return const SizedBox.shrink();
      },
    );
  }
}
