import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(TokoOnlineApp());

class TokoOnlineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TOKO ONLINE - HUDA XGW',
      theme: ThemeData(
        primaryColor: Colors.purple,
        colorScheme: ColorScheme.light(
          primary: Colors.purple,
          secondary: Colors.deepPurpleAccent,
        ),
        fontFamily: 'Arial',
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      home: HalamanUtama(),
    );
  }
}

// ======================================
// DATA PRODUK & MODEL
// ======================================
class Produk {
  final String id;
  final String nama;
  final double harga;
  final String kategori;
  final String gambar;
  final String deskripsi;

  Produk({
    required this.id,
    required this.nama,
    required this.harga,
    required this.kategori,
    required this.gambar,
    required this.deskripsi,
  });
}

// Daftar Produk Contoh
List<Produk> daftarProduk = [
  Produk(
    id: 'P1',
    nama: 'Baju Kaos Premium',
    harga: 85000,
    kategori: 'Pakaian',
    gambar: 'https://cdn-icons-png.flaticon.com/512/1058/1058490.png',
    deskripsi: 'Bahan katun 30s, nyaman dipakai, adem, tidak panas, tersedia ukuran S/M/L/XL.',
  ),
  Produk(
    id: 'P2',
    nama: 'Sepatu Sneaker Sport',
    harga: 250000,
    kategori: 'Sepatu',
    gambar: 'https://cdn-icons-png.flaticon.com/512/2661/2661161.png',
    deskripsi: 'Sol karet empuk, anti licin, desain kekinian, cocok jalan-jalan & olahraga.',
  ),
  Produk(
    id: 'P3',
    nama: 'Tas Ransel Kulit',
    harga: 175000,
    kategori: 'Aksesoris',
    gambar: 'https://cdn-icons-png.flaticon.com/512/2545/2545044.png',
    deskripsi: 'Kapasitas besar, banyak kantong, bahan kulit sintetis awet dan kuat.',
  ),
  Produk(
    id: 'P4',
    nama: 'Jam Tangan Elegan',
    harga: 320000,
    kategori: 'Aksesoris',
    gambar: 'https://cdn-icons-png.flaticon.com/512/3073/3073472.png',
    deskripsi: 'Tahan air, anti karat, garansi resmi 1 tahun, tampilan mewah.',
  ),
  Produk(
    id: 'P5',
    nama: 'Celana Jeans Panjang',
    harga: 120000,
    kategori: 'Pakaian',
    gambar: 'https://cdn-icons-png.flaticon.com/512/1142/1142394.png',
    deskripsi: 'Bahan denim tebal tapi lentur, awet dipakai bertahun-tahun.',
  ),
  Produk(
    id: 'P6',
    nama: 'Kacamata Hitam',
    harga: 95000,
    kategori: 'Aksesoris',
    gambar: 'https://cdn-icons-png.flaticon.com/512/3163/3163419.png',
    deskripsi: 'Anti silau, melindungi mata dari sinar UV, gaya modern.',
  ),
];

// ======================================
// HALAMAN UTAMA
// ======================================
class HalamanUtama extends StatefulWidget {
  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  List<Produk> keranjang = [];
  String kataKunci = '';
  String kategoriPilih = 'Semua';
  final formatUang = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // Filter Produk
  List<Produk> get produkFilter {
    return daftarProduk.where((p) {
      bool cocokKata = p.nama.toLowerCase().contains(kataKunci.toLowerCase());
      bool cocokKategori = (kategoriPilih == 'Semua') || (p.kategori == kategoriPilih);
      return cocokKata && cocokKategori;
    }).toList();
  }

  // Tambah ke Keranjang
  void tambahKeKeranjang(Produk p) {
    setState(() => keranjang.add(p));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ ${p.nama} dimasukkan ke keranjang!'), duration: Duration(seconds: 2)),
    );
  }

  // Hapus dari Keranjang
  void hapusDariKeranjang(Produk p) {
    setState(() => keranjang.remove(p));
  }

  // Total Belanja
  double get totalBelanja => keranjang.fold(0, (sum, item) => sum + item.harga);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("🛍️ TOKO ONLINE HUDA XGW"),
        actions: [
          // Tombol Keranjang
          Badge(
            label: Text('${keranjang.length}', style: TextStyle(color: Colors.white)),
            child: IconButton(
              icon: Icon(Icons.shopping_cart, size: 26),
              onPressed: () => bukaKeranjang(),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔍 KOTAK PENCARIAN
            TextField(
              onChanged: (val) => setState(() => kataKunci = val),
              decoration: InputDecoration(
                hintText: "Cari produk...",
                prefixIcon: Icon(Icons.search, color: Colors.purple),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            SizedBox(height: 16),

            // 📂 PILIH KATEGORI
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Semua', 'Pakaian', 'Sepatu', 'Aksesoris'].map((kategori) {
                  bool aktif = kategoriPilih == kategori;
                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(kategori),
                      selected: aktif,
                      onSelected: (_) => setState(() => kategoriPilih = kategori),
                      selectedColor: Colors.purple,
                      labelStyle: TextStyle(color: aktif ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 20),

            // 📦 GRID PRODUK
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: produkFilter.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                Produk p = produkFilter[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    onTap: () => bukaDetailProduk(p),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(p.gambar, height: 80, width: 80, color: Colors.purple.shade300),
                          SizedBox(height: 10),
                          Text(p.nama, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
                          SizedBox(height: 6),
                          Text(formatUang.format(p.harga), style: TextStyle(color: Colors.purple, fontSize: 15, fontWeight: FontWeight.w600)),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => tambahKeKeranjang(p),
                              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              child: Text("+ Masukkan"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // ======================================
  // FUNGSI BUKA HALAMAN
  // ======================================
  void bukaDetailProduk(Produk p) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(p.nama),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(p.gambar, height: 100, color: Colors.purple.shade300),
            SizedBox(height: 10),
            Text(p.deskripsi, textAlign: TextAlign.justify),
            SizedBox(height: 10),
            Text(formatUang.format(p.harga), style: TextStyle(fontSize: 20, color: Colors.purple, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Tutup")),
          ElevatedButton(onPressed: () { tambahKeKeranjang(p); Navigator.pop(context); }, child: Text("Beli Sekarang")),
        ],
      ),
    );
  }

  void bukaKeranjang() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Text("🛒 KERANJANG BELANJA", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            Expanded(
              child: keranjang.isEmpty
                  ? Center(child: Text("Keranjang masih kosong 😔", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: keranjang.length,
                      itemBuilder: (context, i) {
                        Produk p = keranjang[i];
                        return Card(
                          child: ListTile(
                            leading: Image.network(p.gambar, width: 40, color: Colors.purple),
                            title: Text(p.nama),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(formatUang.format(p.harga)),
                                IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => hapusDariKeranjang(p))),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("TOTAL BAYAR:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(formatUang.format(totalBelanja), style: TextStyle(fontSize: 18, color: Colors.purple, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 12)),
                onPressed: keranjang.isEmpty ? null : () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanPembayaran(total: totalBelanja, daftarBeli: List.from(keranjang))));
                },
                child: Text("💳 LANJUT KE PEMBAYARAN", style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ======================================
// HALAMAN PEMBAYARAN
// ======================================
class HalamanPembayaran extends StatefulWidget {
  final double total;
  final List<Produk> daftarBeli;
  HalamanPembayaran({required this.total, required this.daftarBeli});

  @override
  State<HalamanPembayaran> createState() => _HalamanPembayaranState();
}

class _HalamanPembayaranState extends State<HalamanPembayaran> {
  final namaCtrl = TextEditingController();
  final alamatCtrl = TextEditingController();
  final noHpCtrl = TextEditingController();
  String metodeBayar = 'Transfer Bank';
  final formatUang = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  void prosesPembayaran() {
    if (namaCtrl.text.isEmpty || alamatCtrl.text.isEmpty || noHpCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("⚠️ Lengkapi data pengiriman!")));
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("✅ PEMBAYARAN BERHASIL"),
        content: Text("Terima kasih ${namaCtrl.text}! Pesanan kamu sedang diproses dan akan segera dikirim ke alamat tujuan."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Text("Selesai"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    namaCtrl.dispose();
    alamatCtrl.dispose();
    noHpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("💳 Halaman Pembayaran")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Data Pembeli
            Text("📋 DATA PENGIRIMAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 10),
            TextField(controller: namaCtrl, decoration: InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder())),
            SizedBox(height: 10),
            TextField(controller: alamatCtrl, decoration: InputDecoration(labelText: "Alamat Lengkap", border: OutlineInputBorder()), maxLines: 3),
            SizedBox(height: 10),
            TextField(controller: noHpCtrl, decoration: InputDecoration(labelText: "Nomor HP / WA", border: OutlineInputBorder()), keyboardType: TextInputType.phone),

            SizedBox(height: 20),

            // Metode Pembayaran
            Text("💰 METODE PEMBAYARAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  RadioListTile(
                    title: Text("Transfer Bank"),
                    value: "Transfer Bank",
                    groupValue: metodeBayar,
                    onChanged: (val) => setState(() => metodeBayar = val ?? 'Transfer Bank'),
                  ),
                  RadioListTile(
                    title: Text("E-Wallet (GCash, PayMaya)"),
                    value: "E-Wallet",
                    groupValue: metodeBayar,
                    onChanged: (val) => setState(() => metodeBayar = val ?? 'E-Wallet'),
                  ),
                  RadioListTile(
                    title: Text("Bayar di Tempat (COD)"),
                    value: "COD",
                    groupValue: metodeBayar,
                    onChanged: (val) => setState(() => metodeBayar = val ?? 'COD'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Ringkasan Pesanan
            Text("📦 RINGKASAN PESANAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 10),
            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    ...daftarBeli.map((produk) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(produk.nama, style: TextStyle(fontSize: 14)),
                          Text(formatUang.format(produk.harga), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )).toList(),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("TOTAL:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(formatUang.format(widget.total), style: TextStyle(fontSize: 16, color: Colors.purple, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 25),

            // Tombol Proses Pembayaran
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.purple,
                ),
                onPressed: prosesPembayaran,
                child: Text("✅ PROSES PEMBAYARAN", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),

            SizedBox(height: 10),

            // Tombol Kembali
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14)),
                onPressed: () => Navigator.pop(context),
                child: Text("← KEMBALI", style: TextStyle(fontSize: 16, color: Colors.purple)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
