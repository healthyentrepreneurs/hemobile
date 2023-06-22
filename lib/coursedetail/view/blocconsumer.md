`BlocConsumer<SectionBloc, SectionState>(
// Njovu
listener: (context, state) {
if (state.glistBookChapters.isEmpty) {
Navigator.pop(context);
}
}, builder: (context, state) {
// final sectionBloc = BlocProvider.of<SectionBloc>(context);
if (state.glistBookChapters.isNotEmpty) {
List<BookContent> _bookContent = state.glistBookChapters;
initializeCoursePagerList(_bookContent);
//Start Here @phila two
return Stack(
children: [
Container(
padding: const EdgeInsets.only(bottom: 50),
child: PageView.builder(
itemCount: _coursePagerList.length,
// controller: _pageController,
scrollDirection: Axis.horizontal,
itemBuilder: (context, index) {
return ChapterDisplay(
courseId: widget.courseId,
coursePage: _coursePagerList[index],
courseContents: _bookContent,
courseModule: widget.book,
);
},
onPageChanged: (i) {
setState(() {
_currentPage = i;
});
saveChapterDetails(i);
},
),
),
Align(
alignment: Alignment.bottomCenter,
child: DotPagination(
itemCount: _coursePagerList.length,
activeIndex: _currentPage,
),
)
],
);
} else {
return const Center(
child: CircularProgressIndicator(),
);
}
})`