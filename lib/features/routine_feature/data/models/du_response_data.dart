class DuResponseData {
  final int length;
  final String stateCode;
  final String description;
  final int seconds;
  final int minutes;
  final int hours;
  final int date;
  final int month;
  final int day;
  final int year;
  final int checksum;

  DuResponseData({
    required this.length,
    required this.stateCode,
    required this.description,
    required this.seconds,
    required this.minutes,
    required this.hours,
    required this.date,
    required this.month,
    required this.day,
    required this.year,
    required this.checksum,
  });

  factory DuResponseData.fromJson(Map<String, dynamic> json) {
    return DuResponseData(
      length: json['length'],
      stateCode: json['stateCode'],
      description: json['description'],
      seconds: json['seconds'],
      minutes: json['minutes'],
      hours: json['hours'],
      date: json['date'],
      month: json['month'],
      day: json['day'],
      year: json['year'],
      checksum: json['checksum'],
    );
  }
}
