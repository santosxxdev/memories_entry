class MemoriesModel {
  final String titelMemories;
  final String decMemories;
  final DateTime dateTimeMemories;
  final String? imageMemories;
  final String? audioMemories;

  MemoriesModel({
    required this.titelMemories,
    required this.decMemories,
    required this.dateTimeMemories,
    this.imageMemories,
    this.audioMemories,
  });

  Map<String, dynamic> toMap() {
    return {
      'titelMemories': titelMemories,
      'decMemories': decMemories,
      'dateTimeMemories': dateTimeMemories.toIso8601String(),
      'imageMemories': imageMemories,
      'audioMemories': audioMemories,
    };
  }

  factory MemoriesModel.fromMap(Map<String, dynamic> map) {
    return MemoriesModel(
      titelMemories: map['titelMemories'] ?? "",
      decMemories: map['decMemories'] ?? "",
      dateTimeMemories: DateTime.parse(map['dateTimeMemories']),
      imageMemories: map['imageMemories'],
      audioMemories: map['audioMemories'],
    );
  }
}
