class Artist {
  final String id;
  final String name;
  final String image;
  const Artist({
    required this.id,
    required this.name,
    required this.image,
  });
  @override
  String toString() => name;
}