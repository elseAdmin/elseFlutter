class FeedBack{

  String id;
  String subject;
  bool typeOfFeedBack;
  double feedbackIntensity;
  String content;
  List imageUrls;
  int feedbackStatus;
  DateTime createdDate;
  DateTime updatedDate;


  FeedBack(this.subject, this.typeOfFeedBack, this.feedbackIntensity,
      this.content, this.imageUrls, this.feedbackStatus, this.createdDate,
      this.updatedDate);

  FeedBack.fromMap(Map snapshot, String id) :
      id = id ?? '',
      subject = snapshot['subject'] ?? '',
      typeOfFeedBack = snapshot['typeOfFeedBack'] ?? '',
      feedbackIntensity = snapshot['feedbackIntensity'] ?? '',
      content = snapshot['content'] ?? '',
      imageUrls = snapshot['imageUrls'] ?? '',
      feedbackStatus = snapshot['feedbackStatus'] ?? '',
      createdDate = snapshot['createdDate'].toDate(),
      updatedDate = snapshot['updatedDate'].toDate();

  toJson(){
    return{
      "subject":subject,
      "typeOfFeedBack":typeOfFeedBack,
      "feedbackIntensity":feedbackIntensity,
      "content":content,
      "imageUrls":imageUrls,
      "feedbackStatus":feedbackStatus,
      "createdDate":createdDate,
      "updatedDate":updatedDate
    };
  }

}