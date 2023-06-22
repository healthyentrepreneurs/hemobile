ClipRRect(
key: UniqueKey(),
borderRadius: BorderRadius.circular(30.0),
child: isValidUrl(photo)
? FadeInImage.memoryNetwork(
width: 50,
height: 50,
placeholder: kTransparentImage,
image: photo!,
imageErrorBuilder: (context, error, stackTrace) {
debugPrint('HeIconOnline@imageErrorBuilder');
return const CircleAvatar(
radius: _iconSize,
child: Icon(Icons.broken_image),
);
},
)
: const CircleAvatar(
radius: _iconSize,
child: Icon(Icons.broken_image),
),
)