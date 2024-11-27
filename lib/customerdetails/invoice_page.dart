import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/loginscreen.dart';
import 'controller/customer_controller.dart';
import 'customer_list_page.dart';

class InvoicePage extends StatelessWidget {
  final _customerController = TextEditingController();
  final _productController = TextEditingController();
  final _priceController = TextEditingController();

  final CustomerController customerController = Get.find<CustomerController>();
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false); // Mark user as logged out

    Fluttertoast.showToast(msg: 'Logged out successfully');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white, size: 30),
        backgroundColor: Colors.blue,
        title: Text(
          'Invoice Generator',
          style: TextStyle(
              fontSize: 26, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Logout icon
            onPressed: () {
              logout(context); // Call the logout function
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _customerController,
              decoration: InputDecoration(labelText: 'Customer Name'),
              onChanged: (value) {
                customerController.currentCustomer.value = value;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _productController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_productController.text.isNotEmpty &&
                        _priceController.text.isNotEmpty) {
                      customerController.addProduct(
                        _productController.text,
                        double.parse(_priceController.text),
                      );
                      _productController.clear();
                      _priceController.clear();
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Obx(() => Expanded(
                  child: ListView.builder(
                    itemCount: customerController.productList.length,
                    itemBuilder: (context, index) {
                      final product = customerController.productList[index];
                      return ListTile(
                        title: Text(product['product']),
                        trailing: Text('\$${product['price']}'),
                      );
                    },
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await customerController.saveCustomer();
                  },
                  child: Text('Save Data', style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Background color
                    foregroundColor: Colors.white, // Text color
                    // Padding
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _customerController.clear();
                    _productController.clear();
                    _priceController.clear();
                    customerController.currentCustomer.value = '';
                    customerController.productList.clear();
                  },
                  child: Text('New Customer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Background color
                    foregroundColor: Colors.white, // Text color
                    // Padding
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => Get.to(CustomerListPage()),
              child: Text('View Saved Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color
                foregroundColor: Colors.white, // Text color
                // Padding
              ),
            ),
          ],
        ),
      ),
    );
  }
}
