class CategoryData {
  final String id;
  final String title;
  final String description;
  final String gender_category;
  final String visibility;
  final String created_at;
  final String cat_row;

  CategoryData(
      {this.id,
      this.title,
      this.description,
      this.gender_category,
      this.visibility,
      this.created_at,
      this.cat_row});

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      gender_category: json["gender_category"],
      visibility: json["visibility"],
      created_at: json["created_at"],
      cat_row: json["cat_row"]);

  Map<String, dynamic> toMap() {
    return {"categoryName": this.title, "id": this.cat_row};
  }
}
