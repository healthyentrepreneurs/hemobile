import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/home/home.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';

class UnsentSurveysWidget extends StatelessWidget {
  const UnsentSurveysWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        child: BlocBuilder<DatabaseBloc, DatabaseState>(
          builder: (BuildContext context, DatabaseState state) {
            String prefixText = 'You have ';
            String unsentSurveysCountText;
            String suffixText = ' unsent surveys';

            if (state.fetchError != null) {
              unsentSurveysCountText = 'Error';
            } else if (state.surveyTotalCount == null) {
              unsentSurveysCountText = 'Loading... ';
              context.read<DatabaseBloc>().add(const DbCountSurveyEvent());
            } else {
              int? unsentSurveysCount = state.surveyTotalCount;
              unsentSurveysCountText = '$unsentSurveysCount';
            }
            return ListTile(
              title: const MenuItemHe().iconRichTextItemGreen(
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: prefixText),
                      TextSpan(
                          text: unsentSurveysCountText,
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                      TextSpan(text: suffixText),
                    ],
                    style: DefaultTextStyle.of(context).style,
                  ),
                ),
                Icons.sync,
              ),
            );
          },
        ),
      ),
    );
  }
}
