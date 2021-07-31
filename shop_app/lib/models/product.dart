class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  //se colocarmos a imagem como asset, toda image novao precisa que o app seja
  //atualizado
  final String imageUrl;

  //vamos nos preocupar depois em como implementar o favoritos para cada usuário
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
}
