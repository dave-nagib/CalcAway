import 'package:calc_away/data/models/receipt.dart';
import 'package:calc_away/data/models/item.dart';
import 'package:calc_away/data/db/receipt_dao.dart';
import 'package:calc_away/data/db/item_dao.dart';

class CheckoutService {

  Receipt receipt;
  ReceiptDAO receiptDAO;
  ItemDAO itemDAO;

  CheckoutService(this.receipt, this.receiptDAO, this.itemDAO) {
    // Fetch default discounts for the receipt items
    for (Item item in receipt.items) {
      double discount = -1.0;
      itemDAO.getDiscount(item.id!).then((value) => {discount = value ?? -1.0});
      if (discount > 0.0) {
        receipt.updateDiscount(item.id!, discount);
      }
    }
  }

  /// Adds a discount to a group of items
  void addDiscount(List<int> itemIds, double discount) {
    for (int id in itemIds) {
      receipt.updateDiscount(id, discount);
    }
  }

  /// Removes discounts from a group of items
  void removeDiscount(List<int> itemIds) {
    for (int id in itemIds) {
      receipt.removeDiscount(id);
    }
  }

  /// Finalizes a receipt by adding it to the database
  Future<bool> checkoutReceipt() async {
    return await receiptDAO.add(receipt) != null;
  }
}