import 'package:flutter/material.dart';
import 'package:green/models/productModel.dart';
import 'ItemPage.dart';
import 'favourite_service.dart';

class HpCategory extends StatelessWidget {
  final List<Product> products;

  const HpCategory({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final favService = FavouriteService();

    if (products.isEmpty) {
      return const Center(child: Text("No products in this category"));
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
      physics: const BouncingScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ItemPage(product: product)),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14),
                        ),
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.green[100],
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                      child: Text(
                        product.isDonate
                            ? "Free (Donate)"
                            : "\$${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: FavouriteButton(
                    product: product,
                    favService: favService,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FavouriteButton extends StatefulWidget {
  final Product product;
  final FavouriteService favService;

  const FavouriteButton({
    super.key,
    required this.product,
    required this.favService,
  });

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    widget.favService.isFavourite(widget.product.id!).listen((value) {
      if (mounted) {
        setState(() {
          isFav = value;
        });
      }
    });
  }

  void toggleFavourite() async {
    setState(() => isFav = !isFav);

    if (isFav) {
      await widget.favService.addToFavourites({
        'name': widget.product.name,
        'image': widget.product.imageUrl,
        'price': widget.product.price,
        'category': widget.product.category,
        'description': widget.product.description,
        'isDonate': widget.product.isDonate,
      }, widget.product.id!);
    } else {
      await widget.favService.removeFromFavourites(widget.product.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleFavourite,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: isFav ? Colors.green : Colors.white,
          border: Border.all(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.favorite,
          color: isFav ? Colors.white : Colors.green,
          size: 20,
        ),
      ),
    );
  }
}