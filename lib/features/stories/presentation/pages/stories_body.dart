import 'package:flutter/material.dart';
import 'package:job/features/stories/presentation/pages/story_viewer_page.dart';
import '../../data/models/story_model.dart';
import 'dart:io';

class StoriesBody extends StatelessWidget {
  final List<StoryModel> stories;
  final void Function(StoryModel) onViewStory;
  final void Function(String type)? onAddStory;
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
          SizedBox(
            height: 170,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _addStatusBox(),
                // _whatsappStatusBox(),
                ...stories
                    .map((story) => _storyBox(story, onViewStory, context))
                    .toList(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              'Channels',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: 350,
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                channelTile(
                  'وظائف السعودية',
                  'مطلوب 4 سائقين حافلة في جدة تفاصيل ...',
                  '7:14 pm',
                  69,
                ),
                channelTile(
                  'tawzeefy | توظيفي',
                  'شاغر وظيفي لدى إحدى مكاتب التسويق...',
                  '6:58 pm',
                  140,
                ),
                channelTile(
                  'Job Hunters 🚀🔥',
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
          ),
        ],
      ),
    );
  }

  Widget _addStatusBox() {
    return GestureDetector(
      onTap: () {
        if (onAddStory != null) {
          onAddStory!('image');
        }
      },
      child: Container(
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
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

  Widget _storyBox(
    StoryModel story,
    void Function(StoryModel) onViewStory,
    BuildContext context,
  ) {
    double boxSize = 100;
    double imageSize = 121;
    Widget mediaWidget;
    if (story.mediaPath.isEmpty) {
      mediaWidget = Container(
        width: imageSize,
        height: 180,
        color: Colors.grey,
        child: Icon(
          story.mediaType == 'image'
              ? Icons.image_not_supported
              : Icons.videocam,
          color: Colors.white,
          size: 32,
        ),
      );
    } else if (story.mediaType == 'image') {
      if (story.mediaPath.startsWith('http')) {
        mediaWidget = Image.network(
          story.mediaPath,
          fit: BoxFit.cover,
          width: imageSize,
          height: 151,
          errorBuilder: (context, error, stackTrace) => Container(
            width: imageSize,
            height: imageSize,
            color: Colors.grey,
            child: Icon(Icons.broken_image, color: Colors.white, size: 32),
          ),
        );
      } else {
        mediaWidget = Image.file(
          File(story.mediaPath),
          fit: BoxFit.cover,
          width: imageSize,
          height: 150,
          errorBuilder: (context, error, stackTrace) => Container(
            width: imageSize,
            height: imageSize,
            color: Colors.grey,
            child: Icon(Icons.broken_image, color: Colors.white, size: 32),
          ),
        );
      }
    } else {
      mediaWidget = Stack(
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            color: Colors.grey,
            child: Icon(Icons.videocam, color: Colors.white, size: 32),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Icon(Icons.play_circle_fill, color: Colors.white, size: 28),
          ),
        ],
      );
    }
    String displayName = story.name ?? story.userId;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => StoryViewerPage(story: story)),
        );
      },
      child: Container(
        width: boxSize,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: story.isViewed ? Colors.grey : Color(0xFF25D366),
        //     width: 1.2,
        //   ),
        //   borderRadius: BorderRadius.circular(18),
        //   color: Colors.black,
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: mediaWidget,
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      displayName,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget channelTile(String name, String desc, String time, int count) {
  final Map<String, String> channelImages = {
    'وظائف السعودية': 'https://randomuser.me/api/portraits/men/11.jpg',
    'tawzeefy | توظيفي': 'https://randomuser.me/api/portraits/men/12.jpg',
    'Job Hunters 🚀🔥': 'https://randomuser.me/api/portraits/men/13.jpg',
    'Real Madrid C.F.':
        'https://i.pinimg.com/736x/e3/6d/c0/e36dc00f0747a942eb74d90c2f24d3bb.jpg',
    'المجموعة المعالي للتوظيف':
        'https://randomuser.me/api/portraits/men/14.jpg',
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

String _extractYouTubeId(String url) {
  final uri = Uri.parse(url);
  if (uri.host.contains('youtube.com') && uri.queryParameters['v'] != null) {
    return uri.queryParameters['v']!;
  } else if (uri.host.contains('youtu.be')) {
    return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
  }
  return '';
}
