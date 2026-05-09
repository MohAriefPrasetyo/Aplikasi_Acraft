import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/craft_model.dart';

class CraftService {
  final _supabase = Supabase.instance.client;

  Future<List<Craft>> fetchCrafts() async {
    final data = await _supabase
        .from('craft_items')
        .select()
        .order('created_at', ascending: false);
    return (data as List).map((e) => Craft.fromJson(e)).toList();
  }

  Future<void> addCraft(Map<String, dynamic> data) async {
    await _supabase.from('craft_items').insert(data);
  }

  Future<void> updateCraft(String id, Map<String, dynamic> data) async {
    await _supabase.from('craft_items').update(data).eq('id', id);
  }

  Future<void> deleteCraft(String id) async {
    await _supabase.from('craft_items').delete().eq('id', id);
  }
}
