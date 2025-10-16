import '../enumerations/tag_enumeration.dart';

class Filters {

  final List<({Category category, int count, String name})> categories;
  
  final List<({int count, String publisher})> publishers;
  
  final List<({int count, int year})> years;

  Filters({
    required this.categories,
    required this.publishers,
    required this.years,
  });
}