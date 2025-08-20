import 'package:flutter/material.dart';
import 'package:job/constants/colors.dart';
import 'package:job/constants/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../data/models/message_model.dart';
import 'dart:io';

class ChatTile extends StatelessWidget {
  final UserModel user;
  final dynamic chatModel;
  final List<MessageModel> chatMessages;
  final Widget lastMsgWidget;
  final VoidCallback onTap;
  final VoidCallback onAvatarTap;
  final bool isDark;

  const ChatTile({
    Key? key,
    required this.user,
    required this.chatModel,
    required this.chatMessages,
    required this.lastMsgWidget,
    required this.onTap,
    required this.onAvatarTap,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onAvatarTap,
          child: Padding(
            padding: EdgeInsets.only(
              left: AppConstants.chatAvatarPadding,
              right: 0,
            ),
            child: CircleAvatar(
              backgroundImage: user.avatarPath.startsWith('http')
                  ? NetworkImage(user.avatarPath)
                  : FileImage(File(user.avatarPath)) as ImageProvider,
              radius: AppConstants.chatAvatarRadius,
            ),
          ),
        ),
        SizedBox(width: AppConstants.chatTileSpacing),
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 0, right: 8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    user.name,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.whatsappDarkBg,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (chatModel.unreadCount > 0)
                      Container(
                        margin: EdgeInsets.only(bottom: 2),
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whatsappGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${chatModel.unreadCount}',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            subtitle: Row(
              children: [
                SizedBox(width: 4),
                Icon(
                  Icons.done_all,
                  color: chatModel.unreadCount == 0
                      ? (isDark ? Colors.white : AppColors.whatsappGreen)
                      : AppColors.whatsappGreen,
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(child: lastMsgWidget),
              ],
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
