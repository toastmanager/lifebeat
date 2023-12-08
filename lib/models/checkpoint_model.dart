class CheckpointModel {
  final int id;
  bool value;
  final String text;

  CheckpointModel({
    required this.id,
    required this.value,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value ? 1 : 0,
      'text': text,
    };
  }
}
