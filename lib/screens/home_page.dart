import 'package:flutter/material.dart';
import 'package:product_angelim/models/product_model.dart';
import 'package:product_angelim/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  List<Product> allProducts = [];
  List<Product> displayProducts = [];
  bool isLoading = true;
  bool isFilterActive = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final List<Product> allProductData = await _apiService.getAllProducts();
      setState(() {
        allProducts = allProductData;
        displayProducts = allProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
  // Perintah: Local Filtering: Tambahkan IconButton Filter di AppBar. Jika aktif, tampilkan hanya kategori
// "electronics" tanpa memanggil API ulang pada list di memori.
  void toggleFilter() {
    setState(() {
      isFilterActive = !isFilterActive;

      if (isFilterActive) {
        displayProducts = allProducts.where((p) => p.category == "electronics").toList();
      } else {
        displayProducts = allProducts;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FakeStore"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: toggleFilter,
          )
        ],
      ),
      // Perintah: Loading State: Tampilkan CircularProgressIndicator saat proses ambil data.
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: displayProducts.length,
              itemBuilder: (context, index) {
                final product = displayProducts[index];

                // Perintah: Tampilkan data produk menggunakan widget Card 
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(
                      product.image,
                      width: 50,
                      height: 50,
                    ),

                    // Ini untuk menampilkan kategori produk dengan huruf kapital dan menebalkan teks.
                    title: Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.getShortTitle()), // Perintah: Judul Produk: Gunakan hasil dari method getShortTitle().
                        Text("\$${product.price}",
                          style: TextStyle(
                            // Perintah: Jika isExpensive adalah true, warna teks harga menjadi Merah dan Tebal.
                            color: product.isExpensive
                                ? Colors.red
                                : Colors.black,
                            fontWeight: product.isExpensive
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        // Perintah:Tampilkan nilai rate dan jumlah count secara berdampingan.
                        Row(
                          children: [
                            Text("${product.rating.rate}"),
                            const SizedBox(width: 8),
                            Text("(${product.rating.count})"),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// 4. Pertanyaan Analisis (Wajib)
// Tulis jawaban di komentar bawah file home_page.dart:
// 1. Jelaskan alur data dari ApiService hingga tampil di ListView.
// Data diambil dari ApiService melalui method getAllProducts() menggunakan HTTP request.
// Setelah mendapatkan response, data JSON akan diubah menjadi object Product.
// Data tersebut akan disimpan ke dalam state (allProducts dan displayProducts) menggunakan setState.
// ListView.builder nantinya akan membaca displayProducts dan menampilkannya dalam bentuk Card.

// 2. Mengapa kita perlu memisahkan list data asli dan list data yang ditampilkan saat melakukan filter?
// Hal ini dikarenakan allProducts digunakan sebagai sumber data asli.
// Sedangkan displayProducts hanya digunakan untuk menampilkan data yang sudah difilte saja
// Jika hanya menggunakan satu list, maka data asli akan hilang saat filter diterapkan dan tidak bisa dikembalikan tanpa memanggil API ulang.