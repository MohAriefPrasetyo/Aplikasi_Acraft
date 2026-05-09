import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../services/disqus_service.dart';

class ReviewViewModel extends ChangeNotifier {
  final DisqusService _disqusService = DisqusService();

  List<Review> _reviews = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchReviews() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _reviews = await _disqusService.fetchReviews();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}