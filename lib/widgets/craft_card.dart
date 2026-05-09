import 'package:flutter/material.dart';
import '../models/craft_model.dart';
import '../views/detail_view.dart';

class CraftCard extends StatelessWidget {
  final Craft craft;
  final bool isGrid;

  const CraftCard({super.key, required this.craft, required this.isGrid});

  Widget _buildImage({double? height, BoxFit fit = BoxFit.cover}) {
    final src = craft.imageUrl;
    final isNetwork = src.startsWith('http');
    return isNetwork
        ? Image.network(src,
            width: double.infinity,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => _placeholder(height))
        : Image.asset(src,
            width: double.infinity,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => _placeholder(height));
  }

  Widget _placeholder(double? height) => Container(
        height: height,
        color: Colors.grey[200],
        child: const Center(
            child: Icon(Icons.image, color: Colors.grey, size: 48)),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailView(craft: craft)),
      ),
      child: Card(
        elevation: 1,
        color: const Color(0xFFF5F0F8),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: isGrid ? _buildGridUI() : _buildListUI(),
      ),
    );
  }

  Widget _buildListUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: _buildImage(height: 180),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(craft.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF7B3F00))),
              const SizedBox(height: 4),
              Text(craft.desc,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 6),
              Text(craft.price,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF7B3F00))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGridUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
            child: _buildImage(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(craft.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF7B3F00))),
              const SizedBox(height: 2),
              Text(craft.price,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF7B3F00))),
            ],
          ),
        ),
      ],
    );
  }
}
