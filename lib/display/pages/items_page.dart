import 'package:calc_away/display/helpers/flushbar_feedback.dart';
import 'package:calc_away/display/widgets/add_item_dialog.dart';
import 'package:calc_away/display/widgets/item_tile.dart';
import 'package:calc_away/services/items_page_service.dart';
import 'package:flutter/material.dart';
import '../../data/models/item.dart';
import '../widgets/calcaway_app_bar.dart';
import '../widgets/drawer_navigator.dart';
import '../widgets/search_sort_bar.dart';

class ItemsPage extends StatefulWidget {
  final ItemsPageService itemService;

  const ItemsPage({required this.itemService, super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {

  late Future<List<(Item, int, double)>?> _itemTuplesFuture;
  String _searchBar = '';
  String _sortBy = 'name';
  bool _ascending = true;

  @override
  void initState() {
    super.initState();
    _itemTuplesFuture = widget.itemService.fetchItemTuples(_searchBar, _sortBy, _ascending);
  }

  void _refreshItems(String searchBar, String sortBy, bool ascending) {
    setState(() {
      _searchBar = searchBar;
      _sortBy = sortBy;
      _ascending = ascending;
      _itemTuplesFuture = widget.itemService.fetchItemTuples(searchBar, sortBy, ascending);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    List<(Item item, int saleCount, double discount)> itemTuples;

    return Scaffold(
      backgroundColor: const Color(0xFF18212A),
      appBar: const CalcawayAppBar(),
      drawer: const DrawerNavigator(),
      body: Stack(
        children: [
          Positioned.fill(
            child: FutureBuilder<List<(Item, int, double)>?>(
              future: _itemTuplesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFC6FFEE), strokeWidth: 4.0));
                } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) { // TODO handle null vs empty
                return const Center(child: Text('No items found.'));
                }

                itemTuples = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 80.0),
                  itemCount: itemTuples.length,
                  itemBuilder: (context, index) => ItemTile(
                    itemTuples[index],
                    itemService: widget.itemService,
                    () => setState(() => _refreshItems(_searchBar, _sortBy, _ascending)) // Refresh the state after any deletion
                  ),
                );
              }
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: SearchSortBar(onChanged: _refreshItems),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 70.0,
        height: 70.0,
        child: FloatingActionButton(
          heroTag: 'add-item',
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (context) => AddItemDialog(itemService: widget.itemService)
            ).then((res) {
              if (res != null && res) {
                showSuccessFlushbar(context, 'Item Added Successfully.');
                _refreshItems(_searchBar, _sortBy, _ascending);
              }
            });
          },
          backgroundColor: const Color(0xFFC4E8DD),
          foregroundColor: const Color(0xFF08090A),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
