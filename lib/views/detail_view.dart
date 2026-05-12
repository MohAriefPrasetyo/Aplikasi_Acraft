import 'package:flutter/material.dart';
import '../models/craft_model.dart';
import '../models/review_model.dart';
import '../viewmodels/review_viewmodel.dart';

class DetailView extends StatefulWidget {
  final Craft craft;

  const DetailView({super.key, required this.craft});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final ReviewViewModel _reviewVM = ReviewViewModel();
  List<Review> _reviews = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await _reviewVM.fetchReviews();
      setState(() {
        _reviews = _reviewVM.reviews;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.craft.name),
        foregroundColor: const Color(0xFF8B4513),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.craft.imageUrl.startsWith('http')
                ? Image.network(
                    widget.craft.imageUrl,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        height: 300,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image,
                            size: 60, color: Colors.grey)),
                  )
                : Image.asset(
                    widget.craft.imageUrl,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        height: 300,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image,
                            size: 60, color: Colors.grey)),
                  ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.craft.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.craft.price}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text(
                    "Deskripsi",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.craft.desc,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  const Divider(thickness: 2),
                  const SizedBox(height: 10),
                  const Text(
                    'Ulasan Produk',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildReviews(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -3),
              blurRadius: 10,
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Menghubungkan ke sistem pembayaran..."),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: const Text(
              "Beli Sekarang",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B4513),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviews() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            'Gagal memuat ulasan: $_errorMessage',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    if (_reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: Text('Belum ada ulasan untuk produk ini.')),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final review = _reviews[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF8B4513),
            child: Text(
              review.authorName[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            review.authorName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(review.message),
        );
      },
    );
  }
}
