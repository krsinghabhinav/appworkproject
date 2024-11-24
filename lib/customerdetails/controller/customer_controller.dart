import 'package:get/get.dart';

import '../database/localdatabase.dart';

class CustomerController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Reactive states
  var currentCustomer = ''.obs;
  var productList = <Map<String, dynamic>>[].obs;
  var savedCustomers = <Map<String, dynamic>>[].obs;

  // Add product to temporary list
  void addProduct(String product, double price) {
    productList.add({'product': product, 'price': price});
  }

  // Save customer and products to the database
  Future<void> saveCustomer() async {
    if (currentCustomer.isEmpty || productList.isEmpty) {
      Get.snackbar('Error', 'Enter customer details and add products!');
      return;
    }

    // Save customer to the database
    final customerId = await _dbHelper.insertCustomer(currentCustomer.value);

    // Save products linked to the customer
    for (var product in productList) {
      await _dbHelper.insertProduct(
        customerId,
        product['product'],
        product['price'],
      );
    }
    Get.snackbar('Success', 'Customer details saved!',
        snackPosition: SnackPosition.TOP);

    // Clear temporary lists
    productList.clear();
    currentCustomer.value = '';

    // Reload saved customers
    await loadSavedCustomers();
  }

  // Load saved customers and their products
  Future<void> loadSavedCustomers() async {
    final customers = await _dbHelper.fetchCustomers();
    final List<Map<String, dynamic>> customerData = [];

    for (var customer in customers) {
      final products = await _dbHelper.fetchProducts(customer['id']);
      customerData.add({
        'customer': customer['name'],
        'products': products,
      });
    }

    savedCustomers.assignAll(customerData);
  }

  @override
  void onInit() {
    super.onInit();
    loadSavedCustomers();
    saveCustomer();
  }
}
