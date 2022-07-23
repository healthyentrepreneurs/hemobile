import 'package:flutter/material.dart';
import 'package:he/coursedetail/widgets/video_widget.dart';
import 'package:he/formsapi/view/linkedlabelcheckbox.dart';
import 'package:he/formsapi/view/linkedlabelradio.dart';
import 'package:he/objects/googleforms/imageitem.dart';
import 'package:he/objects/googleforms/item.dart';
import 'package:he/objects/googleforms/option.dart';
import 'package:he/objects/googleforms/questionitem.dart';
import 'package:he/objects/googleforms/videoitem.dart';

class QuestionInstance extends StatefulWidget {
  const QuestionInstance({Key? key, this.item}) : super(key: key);
  final Item? item;
  @override
  _QuestionInstance createState() => _QuestionInstance();
}

class _QuestionInstance extends State<QuestionInstance> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.5,
          // padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.item?.title != null
                  ? Text(widget.item!.title)
                  : Container(),
              widget.item?.questionItem != null
                  ? widgetQuestionItem(widget.item!.questionItem!, context)
                  : Container(),
              widget.item?.videoItem != null
                  ? widgetVideoItem(widget.item!.videoItem!, context)
                  : Container(),
              widget.item?.imageItem != null
                  ? widgetImageItem(widget.item!.imageItem!)
                  : Container(),
            ],
          ),
        ),
      ),
    );
    // return ;
  }

  Widget widgetQuestionItem(QuestionItem questionItem, BuildContext context) {
    String? typeQuestion = questionItem.question?.choiceQuestion.type;
    switch (typeQuestion) {
      case "RADIO":
        List<Option> options = questionItem.question!.choiceQuestion.options;
        return GFormRadioBoxStatefulWidget(optionsRadioBox: options);
      case "CHECKBOX":
        List<Option> options = questionItem.question!.choiceQuestion.options;
        List<bool> checked = List.filled(options.length, false);
        return GFormCheckboxStatefulWidget(
            optionsCheckbox: options, checkedParams: checked);
      // return Column(
      //   children: [
      //     for (var i = 0; i < lengthCheckbox; i += 1)
      //       GFormCheckboxStatefulWidget(labelName: options[i].value),
      //   ],
      // );
      default:
        return Text("QuestionItem Type " + typeQuestion!);
      // do something else
    }
  }

  Widget widgetVideoItem(VideoItem videoItem, BuildContext context) {
    // return VideoApp(videourl: videoItem.video.youtubeUri);
    return _htmlVideoCardFromOnline(videoItem.video.youtubeUri, context);
  }

  Widget _htmlVideoCardFromOnline(String videoUrl, BuildContext context) {
    // print("Online video display ... $videoUrl");
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChewieVideoViewOnline(
                      videoUrl: videoUrl,
                      courseId: "3",
                    )));
      },
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.width * .97,
                height: MediaQuery.of(context).size.height * .32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white38),
                child: ChewieVideoViewOnline(
                  videoUrl: videoUrl,
                  courseId: "3",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetImageItem(ImageItem imageItem) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        imageItem.image.contentUri,
        height: imageItem.image.properties?.height != null
            ? imageItem.image.properties!.height! * 0.65
            : 150.0,
        width: imageItem.image.properties?.width != null
            ? imageItem.image.properties!.width! * 0.65
            : 100.0,
      ),
    );
  }
}
