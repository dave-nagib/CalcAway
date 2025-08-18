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

  String? discountValidator(String? discount) {
    if (discount == null || discount.isEmpty) {
      return 'Discount cannot be empty.';
    }
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(discount)) {
      return 'Discount must be a positive percentage with up to two decimal places.';
    }
    if (double.tryParse(discount)! <= 0.0) {
      return 'Discount must be greater than 0 and less or equal to 100.';
    }
    return null;
  }

  /// Writes (and overwrites) a discount to a group of items
  void writeDiscount(List<int> itemIds, double discount) {
    for (int id in itemIds) {
      receipt.updateDiscount(id, discount);
    }
  }

  /// Removes discounts from a group of items
  void removeDiscounts(List<int> itemIds) {
    for (int id in itemIds) {
      receipt.removeDiscount(id);
    }
  }

  /// Finalizes a receipt by adding it to the database
  Future<bool> checkoutReceipt() async {
    return await receiptDAO.add(receipt) != null;
  }
}