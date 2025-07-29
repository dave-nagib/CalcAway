import 'package:calc_away/data/db/item_dao.dart';
import 'package:calc_away/data/models/item.dart';

class AnalyticsService {
  ItemDAO itemDAO;

  AnalyticsService(this.itemDAO);

  Future<List<MapEntry<Item, int>>> soldCounts() async {
    List<MapEntry<Item, int>>? counts = await itemDAO.saleCounts();
    if (counts == null || counts.isEmpty) {
      return [];
    }
    return counts;
  }
}