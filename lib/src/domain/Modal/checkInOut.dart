class CheckInOut {
  final int id;
  final String title;
  final String checkin;
  final String checkout;
  final String hours;

  CheckInOut({
    required this.id,
    required this.title,
    required this.checkin,
    required this.checkout,
    required this.hours,
  });

  factory CheckInOut.fromMap(Map<String, dynamic> map) {
    return CheckInOut(
      id: map['id'],
      title: map['title'],
      checkin: map['checkin'],
      checkout: map['checkout'],
      hours: map['hours'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'checkin': checkin,
      'checkout': checkout,
      'hours': hours,
    };
  }
}