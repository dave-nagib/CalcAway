import 'package:calc_away/data/models/receipt.dart';
import 'package:flutter/material.dart';
import '../../data/models/item.dart';
import '../../services/receipts_page_service.dart';
import '../widgets/drawer_navigator.dart';
import '../widgets/receipt_expansion_tile.dart';
import '../widgets/calcaway_app_bar.dart';

class ReceiptsPage extends StatefulWidget {
  final ReceiptsPageService receiptsService;

  const ReceiptsPage({required this.receiptsService, super.key});

  @override
  State<ReceiptsPage> createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {

  late Future<List<Receipt>?> _receiptsFuture;

  @override
  void initState() {
    super.initState();
    _receiptsFuture = widget.receiptsService.fetchIdsAndTimeStamps();
  }

  void _refreshReceipts() {
    setState(() {
      _receiptsFuture = widget.receiptsService.fetchIdsAndTimeStamps();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1419),
      appBar: const CalcawayAppBar(),
      drawer: const DrawerNavigator(),
      body: FutureBuilder<List<Receipt>?>(
        future: _receiptsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFC6FFEE), strokeWidth: 4.0));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) { // TODO handle null vs empty
            return const Center(child: Text('No receipts found.'));
          }

          final receipts = snapshot.data!;

          return ListView.builder(
            itemCount: receipts.length,
            itemBuilder: (context, index) => ReceiptExpansionTile(
              receipts[index],
              () => widget.receiptsService.fetchReceipt(receipts[index].id!),
              () {
                widget.receiptsService.deleteReceipt(receipts[index].id!);
                _refreshReceipts();
              }
            ),
          );
        }
      ),
    );
  }
}
