class FeedBack {
  String id;
  String subject;
  bool typeOfFeedBack;
  double feedbackIntensity;
  String content;
  List imageUrls;
  int feedbackStatus;
  int createdDate;
  int updatedDate;

  FeedBack(
      this.subject,
      this.typeOfFeedBack,
      this.feedbackIntensity,
      this.content,
      this.imageUrls,
      this.feedbackStatus,
      this.createdDate,
      this.updatedDate);

  FeedBack.fromMap(Map snapshot, String id)
      : this.id = id ?? '',
        this.subject = snapshot['subject'] ?? '',
        this.typeOfFeedBack = snapshot['typeOfFeedBack'] ?? '',
        this.feedbackIntensity = snapshot['feedbackIntensity'] ?? '',
        this.content = snapshot['content'] ?? '',
        this.imageUrls = snapshot['imageUrls'] ?? '',
        this.feedbackStatus = snapshot['feedbackStatus'] ?? '',
        this.createdDate = DateTime.fromMillisecondsSinceEpoch(snapshot['createdDate']),
        this.updatedDate = DateTime.fromMillisecondsSinceEpoch(snapshot['updatedDate']);

  toJson() {
    return {
      "subject": subject,
      "typeOfFeedBack": typeOfFeedBack,
      "feedbackIntensity": feedbackIntensity,
      "content": content,
      "imageUrls": imageUrls,
      "feedbackStatus": feedbackStatus,
      "createdDate": createdDate.millisecondsSinceEpoch,
      "updatedDate": updatedDate.millisecondsSinceEpoch
    };
  }
}
