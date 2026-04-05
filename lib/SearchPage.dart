import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green/models/productModel.dart';
import 'ItemPage.dart';
import 'search_history_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final SearchHistoryService _searchHistoryService = SearchHistoryService();
  final ProductService _productService = ProductService();

  List<String> recentSearches = [];
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  bool isLoadingHistory = true;
  bool isLoadingProducts = true;

  final List<String> popularImages = [
    "assets/images/pic7.png",
    "assets/images/pic8.png",
    "assets/images/pic9.png",
    "assets/images/pic10.png",
  ];

  @override
  void initState() {
    super.initState();
    loadSearchHistory();
    loadProducts();
  }

  Future<void> loadSearchHistory() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        setState(() {
          recentSearches = [];
          isLoadingHistory = false;
        });
        return;
      }

      final searches = await _searchHistoryService.getSearchHistory();

      setState(() {
        recentSearches = searches;
        isLoadingHistory = false;
      });
    } catch (e) {
      setState(() {
        isLoadingHistory = false;
      });
    }
  }

  void loadProducts() {
    _productService.getProducts().listen((products) {
      setState(() {
        allProducts = products;
        isLoadingProducts = false;
      });

      if (searchController.text.trim().isNotEmpty) {
        filterProducts(searchController.text);
      }
    });
  }

  void filterProducts(String query) {
    final trimmedQuery = query.trim().toLowerCase();

    if (trimmedQuery.isEmpty) {
      setState(() {
        filteredProducts = [];
      });
      return;
    }

    final matches = allProducts.where((product) {
      final productName = product.name.toLowerCase();
      final category = product.category.toLowerCase();
      final description = product.description.toLowerCase();

      return productName.contains(trimmedQuery) ||
          category.contains(trimmedQuery) ||
          description.contains(trimmedQuery);
    }).toList();

    setState(() {
      filteredProducts = matches;
    });
  }

  Future<void> handleSearchSubmit(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) return;
    if (trimmedQuery.length < 2) return;

    await _searchHistoryService.saveSearch(trimmedQuery);
    await loadSearchHistory();
    filterProducts(trimmedQuery);
  }

  Future<void> removeSearch(String query) async {
    await _searchHistoryService.removeSingleSearch(query);
    await loadSearchHistory();
  }

  Future<void> clearAllSearches() async {
    await _searchHistoryService.clearAllSearches();
    await loadSearchHistory();
  }

  void openProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemPage(product: product),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final hasQuery = searchController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Search products...",
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (value) {
              filterProducts(value);
              setState(() {});
            },
            onSubmitted: handleSearchSubmit,
          ),
        ),
        actions: [
          if (recentSearches.isNotEmpty)
            TextButton(
              onPressed: clearAllSearches,
              child: const Text(
                "Clear All",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: isLoadingProducts
          ? const Center(
        child: CircularProgressIndicator(color: Colors.green),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user == null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Login to save your recent searches.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              if (!hasQuery) ...[
                const Text(
                  "Popular Products",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (String img in popularImages)
                        Container(
                          margin: const EdgeInsets.only(right: 15),
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.green[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(img, fit: BoxFit.contain),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Recent Searches",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                if (isLoadingHistory)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ),
                  )
                else if (recentSearches.isEmpty)
                  const Text(
                    "No recent searches",
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  Column(
                    children: recentSearches.map((recent) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.history, color: Colors.green),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  searchController.text = recent;
                                  filterProducts(recent);
                                  await handleSearchSubmit(recent);
                                },
                                child: Text(
                                  recent,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => removeSearch(recent),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ] else ...[
                Text(
                  "Search Results (${filteredProducts.length})",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),

                if (filteredProducts.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "No matching products found",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return GestureDetector(
                        onTap: () async {
                          await handleSearchSubmit(searchController.text);
                          openProduct(product);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  product.imageUrl,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                      Container(
                                        height: 70,
                                        width: 70,
                                        color: Colors.green[100],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.category,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      product.isDonate
                                          ? "Free"
                                          : "\$${product.price.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}