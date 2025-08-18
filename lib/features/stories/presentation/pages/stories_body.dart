// صندوق ستوري بشكل مستطيل بحواف دائرية
import '../../data/models/story_model.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

Widget _whatsappStoryBox(
  StoryModel story,
  void Function(StoryModel) onViewStory,
  BuildContext context,
) {
  double boxWidth = 100;
  Widget imageWidget;
  if (story.mediaPath.isEmpty) {
    imageWidget = Container(
      width: boxWidth,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.image_not_supported, color: Colors.white, size: 32),
    );
  } else if (story.mediaPath.startsWith('http')) {
    imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        story.mediaPath,
        width: boxWidth,
        height: 170,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: boxWidth,
          height: 170,
          color: Colors.grey,
          child: Icon(Icons.broken_image, color: Colors.white, size: 32),
        ),
      ),
    );
  } else {
    imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        File(story.mediaPath),
        width: boxWidth,
        height: 170,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: boxWidth,
          height: 170,
          color: Colors.grey,
          child: Icon(Icons.broken_image, color: Colors.white, size: 32),
        ),
      ),
    );
  }
  return GestureDetector(
    onTap: () => onViewStory(story),
    child: Container(
      width: boxWidth,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [imageWidget, SizedBox(height: 6)],
          ),
          Positioned(
            bottom: 22,
            left: 8,
            right: 8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(137, 90, 86, 86),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  story.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class StoriesBody extends StatelessWidget {
  final List<StoryModel> stories;
  final void Function(StoryModel) onViewStory;
  final void Function(String type, String path)? onAddStory;
  const StoriesBody({
    required this.stories,
    required this.onViewStory,
    this.onAddStory,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          SizedBox(
            height: 195,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _addStatusBox(context),
                ...stories
                    .map(
                      (story) => _whatsappStoryBox(story, onViewStory, context),
                    )
                    .toList(),
              ],
            ),
          ),
          SizedBox(height: 24),
          channelTile(
            'Job Hunters ',
            'We\'re hiring: Quality Control Eng...',
            '6:50 pm',
            687,
          ),
          channelTile(
            'Real Madrid C.F.',
            'Ready for our LaLiga debut!',
            '6:48 pm',
            439,
          ),
          channelTile(
            'المجموعة المعالي للتوظيف',
            'فرص عمل جديدة في السعودية...',
            '6:45 pm',
            52,
          ),
          channelTile(
            'Job Hunters ',
            'We\'re hiring: Quality Control Eng...',
            '6:50 pm',
            687,
          ),
          channelTile(
            'Job Hunters ',
            'We\'re hiring: Quality Control Eng...',
            '6:50 pm',
            687,
          ),
          channelTile(
            'Real Madrid C.F.',
            'Ready for our LaLiga debut!',
            '6:48 pm',
            439,
          ),
          channelTile(
            'المجموعة المعالي للتوظيف',
            'فرص عمل جديدة في السعودية...',
            '6:45 pm',
            52,
          ),
        ],
      ),
    );
  }

  Widget _addStatusBox(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (onAddStory != null) {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.any, // allow all formats
            allowMultiple: false,
          );
          if (result != null && result.files.isNotEmpty) {
            final file = result.files.first;
            final ext = file.extension?.toLowerCase() ?? '';
            final isImage = [
              'jpg',
              'jpeg',
              'png',
              'gif',
              'bmp',
              'webp',
            ].contains(ext);
            if (isImage) {
              onAddStory!('image', file.path!);
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('يرجى اختيار صورة فقط')));
            }
          }
        }
      },
      child: Container(
        width: 110,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.4),
          borderRadius: BorderRadius.circular(18),
          color: Colors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/1.jpg',
                  ),
                ),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xFF25D366),
                  child: Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              'My Status',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _whatsappStatusBox() {
  //   return Container(
  //     width: 100,
  //     margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.grey, width: 2),
  //       borderRadius: BorderRadius.circular(18),
  //       color: Colors.black,
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Stack(
  //           alignment: Alignment.bottomRight,
  //           children: [
  //             CircleAvatar(
  //               radius: 32,
  //               backgroundImage: NetworkImage(
  //                 'https://randomuser.me/api/portraits/men/1.jpg',
  //               ),
  //             ),
  //             CircleAvatar(
  //               radius: 12,
  //               backgroundColor: Color(0xFF25D366),
  //               child: Icon(Icons.add, color: Colors.white, size: 16),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 6),
  //         Text(
  //           'My status',
  //           style: TextStyle(color: Colors.white, fontSize: 13),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

Widget channelTile(String name, String desc, String time, int count) {
  final Map<String, String> channelImages = {
    'وظائف السعودية': 'https://randomuser.me/api/portraits/men/11.jpg',
    'tawzeefy | توظيفي': 'https://randomuser.me/api/portraits/men/12.jpg',
    'Job Hunters ': 'https://randomuser.me/api/portraits/men/13.jpg',
    'Real Madrid C.F.':
        'https://i.pinimg.com/736x/e3/6d/c0/e36dc00f0747a942eb74d90c2f24d3bb.jpg',
    'امجموعة المعالي للتوظيف': 'https://randomuser.me/api/portraits/men/14.jpg',
  };
  return ListTile(
    leading: CircleAvatar(
      backgroundImage: NetworkImage(
        channelImages[name] ?? 'https://randomuser.me/api/portraits/men/15.jpg',
      ),
      radius: 22,
    ),
    title: Text(
      name,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
    subtitle: Text(
      desc,
      style: TextStyle(color: Colors.white70),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(time, style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
        SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF222E35),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Text(
              '$count',
              style: TextStyle(color: Colors.greenAccent, fontSize: 12),
            ),
          ),
        ),
      ],
    ),
  );
}
