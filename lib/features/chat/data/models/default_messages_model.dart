class DefaultMessagesModel {
  final List<String> messages;
  DefaultMessagesModel({required this.messages});

  static DefaultMessagesModel getDefault() {
    return DefaultMessagesModel(
      messages: [
        'إزيك يا معلم',
       'صباحوووو'
        'أهلاا بيك',
        'صباح الفل',
        'مساء الخير',
        'وحشتنا',
        'متيجي ',
        'إيه الكلاااام',
        'يلااا الجونه',
        'يلا بينا',
      ],
    );
  }
}
