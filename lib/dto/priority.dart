class PriorityIssues {
  final int idPriority;
  final String priorityName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  PriorityIssues({
    required this.idPriority,
    required this.priorityName,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_priority': idPriority,
      'priority_name': priorityName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory PriorityIssues.fromJson(Map<String, dynamic> json) {
    return PriorityIssues(
      idPriority: json['id_priority'] as int,
      priorityName: json['priority_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
    );
  }
}
