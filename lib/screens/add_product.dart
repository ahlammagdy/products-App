// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../main.dart';
import 'products.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var titleController = TextEditingController();
  var descController = TextEditingController();
  var priceController = TextEditingController();

  Builder buildDialogItem(
      BuildContext context, String text, IconData icon, ImageSource src) {
    return Builder(
      builder: (innerContext) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(text),
          onTap: () {
            context.read<Products>().getImage(src);
            Navigator.of(innerContext).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    File? image = Provider.of<Products>(context, listen: true).image;

    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MyApp()));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 86, 67, 10),
            title: const Text('Add Product'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const MyApp())),
            )),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              TextField(
                decoration: const InputDecoration(
                    labelText: "Title", hintText: "Add Title"),
                controller: titleController,
              ),
              TextField(
                decoration: const InputDecoration(
                    labelText: "Description", hintText: "Add Description"),
                controller: descController,
              ),
              TextField(
                decoration: const InputDecoration(
                    labelText: "Price", hintText: "Add Price"),
                controller: priceController,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: const Text("Choose Image"),
                  onPressed: () {
                    var ad = AlertDialog(
                      title: const Text("Choose Picture from:"),
                      content: SizedBox(
                        height: 150,
                        child: Column(
                          children: [
                            const Divider(color: Colors.black),
                            buildDialogItem(context, "Camera",
                                Icons.add_a_photo_outlined, ImageSource.camera),
                            const SizedBox(height: 10),
                            buildDialogItem(context, "Gallery",
                                Icons.image_outlined, ImageSource.gallery),
                          ],
                        ),
                      ),
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => ad);
                  },
                ),
              ),
              const SizedBox(height: 30),
              Consumer<Products>(
                builder: (ctx, value, _) => MaterialButton(
                  color: Colors.orangeAccent,
                  textColor: Colors.black,
                  child: const Text("Add Product"),
                  onPressed: () async {
                    if (titleController.text.isEmpty ||
                        descController.text.isEmpty ||
                        priceController.text.isEmpty) {
                      Toast.show("Please enter all Fields",
                          duration: Toast.lengthLong);
                    } else if (image == null) {
                      Toast.show("Please select an image",
                          duration: Toast.lengthLong);
                    } else {
                      try {
                        value.add(
                          title: titleController.text,
                          description: descController.text,
                          price: double.parse(priceController.text),
                        );
                        value.deleteImage();
                        await Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => const MyApp()));
                      } catch (e) {
                        Toast.show("Please enter a valid price",
                            duration: Toast.lengthLong);
                        print(e);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
