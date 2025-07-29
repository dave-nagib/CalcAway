import 'package:calc_away/data/db/receipt_dao.dart';
import 'package:calc_away/data/models/receipt.dart';

class ReceiptsPageService {

  ReceiptDAO receiptDAO;

  ReceiptsPageService(this.receiptDAO);

  Future<List<Receipt>?> fetchIdsAndTimeStamps() async {
    // TODO add date filtering
    return await receiptDAO.getMultiple();
  }

  Future<Receipt?> fetchReceipt(int id) async {
    return await receiptDAO.get(id);
  }
}