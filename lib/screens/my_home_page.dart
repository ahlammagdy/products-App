import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_product.dart';
import 'products.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Product> prodList =
        Provider.of<Products>(context, listen: true).productsList;

    Widget buildText(title, desc, double price) {
      var description =
          desc.length >= 20 ? desc.replaceRange(20, desc.length, '...') : desc;
      return Positioned(
        bottom: 10,
        right: 10,
        child: Container(
          width: 180,
          color: Colors.black54,
          margin: const EdgeInsets.only(left: 100, top: 20),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Text(
            "$title\n$description\n\$$price",
            style: const TextStyle(fontSize: 26, color: Colors.white),
            softWrap: true,
            overflow: TextOverflow.fade,
            maxLines: 4,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        backgroundColor: const Color.fromARGB(255, 86, 67, 10),
      ),
      body: prodList.isEmpty
          ? const Center(
              child: Text('No Products Added.', style: TextStyle(fontSize: 22)))
          : GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 0,
                crossAxisSpacing: 10,
                maxCrossAxisExtent: 500,
                childAspectRatio: 2,
              ),
              children: prodList
                  .map(
                    (item) => Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 6,
                      margin: const EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: item.image != null
                                ? Image.file(item.image!, fit: BoxFit.fill)
                                : const SizedBox.shrink(),
                          ),
                          buildText(item.title, item.description, item.price),
                          Positioned(
                            left: 10,
                            bottom: 10,
                            child: FloatingActionButton(
                              heroTag: item.description,
                              backgroundColor: Theme.of(context).primaryColor,
                              onPressed: () =>
                                  Provider.of<Products>(context, listen: false)
                                      .delete(item.description),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
      floatingActionButton: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).primaryColor,
        ),
        child: MaterialButton(
          child: const Text("Add Product",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (ctx) => const AddProduct())),
        ),
      ),
    );
  }
}
