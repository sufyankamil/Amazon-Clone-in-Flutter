import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../../../common/constants/error_hanlders.dart';
import '../../../common/constants/utils.dart';
import '../../../models/product.dart';
import '../../../providers/user_provider.dart';
import 'package:http/http.dart' as http;

class AdminServices {
  bool loading = false;

   bool get isLoading => loading;

  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
    bool loading = true,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    var cloudName = dotenv.env['cloud_name']!;
    var cloudPreset = dotenv.env['preset']!;

    try {
      // if (loading) {
      //   showLoadingDialog(context);
      // }

      final cloudinary = CloudinaryPublic(cloudName, cloudPreset);
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      var userUrl = dotenv.env['base'];

      http.Response res = await http.post(
        Uri.parse('$userUrl/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      if (context.mounted) {
        httpErrorHandlers(
          response: res,
          context: context,
          onSuccess: () {
            if (!loading) {
              Navigator.pop(context); // Navigate to a new screen
            }
            loading = true;
            showSnackBar(context, 'Product Added Successfully!');
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      if (loading) {
        Navigator.of(context).pop(); // Hide loading indicator
      }
    }
  }

  // get all the products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      var userUrl = dotenv.env['base'];

      http.Response res =
          await http.get(Uri.parse('$userUrl/admin/get-products'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      if (context.mounted) {
        httpErrorHandlers(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              productList.add(
                Product.fromJson(
                  jsonEncode(
                    jsonDecode(res.body)[i],
                  ),
                ),
              );
            }
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      var userUrl = dotenv.env['base'];

      http.Response res = await http.post(
        Uri.parse('$userUrl/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );

      if (context.mounted) {
        httpErrorHandlers(
          response: res,
          context: context,
          onSuccess: () {
            onSuccess();
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
