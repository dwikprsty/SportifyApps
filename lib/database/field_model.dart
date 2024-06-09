class FieldModel {
  int? id;
  String? name, activity, location, createdAt, updatedAt;

  FieldModel({
    this.id,
    this.name,
    this.activity,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  factory FieldModel.fromJson(Map<String, dynamic> json) {
    return FieldModel(
      id: json['id'],
      name: json['name'],
      activity: json['activity'],
      location: json['location'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
