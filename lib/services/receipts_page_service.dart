import 'package:calc_away/data/db/receipt_dao.dart';
import 'package:calc_away/data/models/receipt.dart';

class ReceiptsPageService {

  final ReceiptDAO receiptDAO;

  const ReceiptsPageService(this.receiptDAO);

  Future<List<Receipt>?> fetchIdsAndTimeStamps() async {
    return await receiptDAO.getMultiple();
  }

  Future<Receipt?> fetchReceipt(int id) async {
    return await receiptDAO.get(id);
  }

  Future<bool> deleteReceipt(int id) async {
    return await receiptDAO.delete(id) > 0;
  }
}