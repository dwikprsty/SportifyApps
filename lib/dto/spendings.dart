class Spending {
  final int idSpending;
  final int spending;
  final String nim;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Spending({
    required this.idSpending,
    required this.nim,
    required this.spending,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Spending.fromJson(Map<String, dynamic> json) {
    return Spending(
      idSpending: json['id_spending'] as int,
      nim: json['nim'] as String,
      spending: json['spending'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
    );
  }
}
