class CategoryModel {
  final String name;
  final String description;
  final String image;
  final String code;

  CategoryModel({required this.name, required this.description, required this.image}) : code = name.split(" ").first;
}
