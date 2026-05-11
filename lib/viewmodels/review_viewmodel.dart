import '../models/review_model.dart';
import '../services/disqus_service.dart';

class ReviewViewModel {
  final _disqusService = DisqusService();

  List<Review> reviews = [];

  Future<void> fetchReviews() async {
    reviews = await _disqusService.fetchReviews();
  }
}
