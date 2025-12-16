import 'package:flutter/material.dart';
import 'package:workshop_shopping_app/models/product.dart';
import 'package:workshop_shopping_app/pages/product_details_page.dart';
import 'package:workshop_shopping_app/services/product_service.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController searchBarController = TextEditingController();
  List<Product> _filteredProducts = [];
	List<Product> _allProducts = [];

	final _productService = ProductService();

	Future<void> _loadProduct() async {
		try {
			final products = await _productService.getAllProducts();
			setState(() {
			  _allProducts = products;
				_filteredProducts = products;
			});
		} catch (e) {
			if (context.mounted) {
				ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(content: Text("Failed to load products: $e"))
				);
			}
		}
	}

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

	@override
	void initState() {
		super.initState();
		_loadProduct();
	}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchBarController,
            textAlignVertical: TextAlignVertical.center,

            decoration: InputDecoration(
              hintText: "Search products...",
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),

            onSubmitted: (value) {
              _filterProducts(value);
            },
          ),
        ),

        body: GridView.builder(
          padding: EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.65
          ),
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(product: _filteredProducts[index]),
                  ),
                );
              },

              child: Card(
                child: Column(
                  children: [
                    Image.asset(
                      _filteredProducts[index].images.first,
                    ),
              
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _filteredProducts[index].name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
              
                            SizedBox(height: 2),
              
                            Text(
                              'RM${_filteredProducts[index].price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
              
                            SizedBox(height: 2),
              
                            Text(
                              'Sales: ${_filteredProducts[index].sales.toString()}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
            );
          },
        )
    );
  }
}
