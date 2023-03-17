// class ChapterDisplay extends StatelessWidget {
//   final String videoUrl;
//
//   ChapterDisplay({required this.videoUrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chapter Video'),
//       ),
//       body: Center(
//         child: AspectRatio(
//           aspectRatio: 16 / 9, // Modify this ratio according to your needs
//           child: ChewieVideoView(
//             videoUrl: videoUrl,
//             courseId: 'sample_course_id',
//             heNetworkState: HenetworkStatus.noInternet, // Change this according to the network status
//           ),
//         ),
//       ),
//     );
//   }
// }
