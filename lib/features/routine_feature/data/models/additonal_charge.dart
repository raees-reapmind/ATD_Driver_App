class AdditionCharge {
  final String label;
  final double value;
  final String breakUpType;

  AdditionCharge({
    required this.label,
    required this.value,
    required this.breakUpType,
  });

  factory AdditionCharge.fromMap(Map<String, dynamic> data) {
    return AdditionCharge(
      label: data['label'].toString(),
      value: double.parse(data['value'].toString()),
      breakUpType: data['breakup_type'],
    );
  }

  @override
  String toString() {
    return 'AdditionCharge{label: $label, value: $value, breakUpType: $breakUpType}';
  }
}
