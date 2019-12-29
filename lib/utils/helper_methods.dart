class HelperMethods {
  String getMonthNameForMonth(String mon) {
      if (int.parse(mon) == 1) {
        return "Jan";
      }
      if (int.parse(mon) == 2) {
        return "Feb";
      }
      if (int.parse(mon) == 3) {
        return "March";
      }
      if (int.parse(mon) == 4) {
        return "April";
      }
      if (int.parse(mon) == 5) {
        return "May";
      }
      if (int.parse(mon) == 6) {
        return "June";
      }
      if (int.parse(mon) == 7) {
        return "July";
      }
      if (int.parse(mon) == 8) {
        return "Aug";
      }
      if (int.parse(mon) == 9) {
        return "Sep";
      }
      if (int.parse(mon) == 10) {
        return "Oct";
      }
      if (int.parse(mon) == 11) {
        return "Nov";
      }
      if (int.parse(mon) == 12) {
        return "Dec";
    }
      return "None";
  }

  bool isTimestampForToday(int timestamp) {
    DateTime receivedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime currentDate = DateTime.now();
    if(currentDate.day==receivedDate.day && currentDate.month==receivedDate.month && currentDate.year==receivedDate.year){
      return true;
    }
    return false;
  }

  bool isTimestampForThisWeek(timestamp) {
    DateTime recievedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime currentDate = DateTime.now();
    if(DateTime.now().millisecondsSinceEpoch - timestamp < 604800000){ ///604800000 milisec = 7 days
      return true;
    }
    return false;
  }
}