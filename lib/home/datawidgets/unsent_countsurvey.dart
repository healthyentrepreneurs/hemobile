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
        child: BlocListener<DatabaseBloc, DatabaseState>(
          listenWhen: (previous, current) {
            final bool listLengthChanged =
                previous.listOfSurveyDataModel?.length !=
                    current.listOfSurveyDataModel?.length;

            final previousNotNull = previous.listOfSurveyDataModel != null;
            final currentNotNull = current.listOfSurveyDataModel != null;
            return previousNotNull && currentNotNull && listLengthChanged;
          },
          listener: (context, state) {
            context
                .read<DatabaseBloc>()
                .add(const ListSurveyTesting(isPending: false));
          },
          child: BlocBuilder<DatabaseBloc, DatabaseState>(
            builder: (BuildContext context, DatabaseState state) {
              String prefixText = 'You have ';
              String unsentSurveysCountText;
              String suffixText = ' unsent surveys';
              if (state.fetchError != null) {
                unsentSurveysCountText = 'Error';
              } else if (state.listOfSurveyDataModel == null) {
                unsentSurveysCountText = 'Loading... ';
                context
                    .read<DatabaseBloc>()
                    .add(const ListSurveyTesting(isPending: false));
                // context.read<DatabaseBloc>().add(const DbCountSurveyEvent());
              } else {
                int? unsentSurveysCount = state.listOfSurveyDataModel?.length;
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
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}
