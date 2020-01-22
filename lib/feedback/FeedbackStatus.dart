enum Status {
  PENDING,
  IN_PROCESS,
  COMPLETED,
  INVALID,
  ACKNOWLEDGED
}

class StatusString{
  static getString(Status status){
    switch(status){
      case Status.PENDING : return 'PENDING';
      case Status.IN_PROCESS : return 'IN_PROCESS';
      case Status.COMPLETED : return 'COMPLETED';
      case Status.INVALID : return 'INVALID';
      case Status.ACKNOWLEDGED : return 'ACKNOWLEDGED';
    }
  }
}