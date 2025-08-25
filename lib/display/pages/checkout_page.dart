import 'package:calc_away/display/helpers/flushbar_feedback.dart';
import 'package:calc_away/display/widgets/add_discount_dialog.dart';
import 'package:calc_away/display/widgets/press_and_hold_button.dart';
import 'package:calc_away/services/checkout_service.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {

  final CheckoutService checkoutService;

  const CheckoutPage({required this.checkoutService, super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {

  bool _selectionMode = false;
  final Set<int> _selectedIds = <int>{};
  late Future<void> _defaultDiscountsFetched;

  @override
  void initState() {
    super.initState();
    _defaultDiscountsFetched = widget.checkoutService.setDefaultDiscounts();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.checkoutService.receipt.items;
    final receipt = widget.checkoutService.receipt;

    return WillPopScope(
      onWillPop: () async {
        if (_selectionMode) {
          setState(() {
            _selectedIds.clear();
            _selectionMode = false;
          });
          return false; // Prevents the back navigation
        }
        return true; // Allows the back navigation
      },
      child: Scaffold(
        backgroundColor: const Color (0xFF0B1419),
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 150.0,
          title: Column(
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontFamily: 'REM',
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Colors.white,
                  letterSpacing: 1.8,
                ),
              ),
              FutureBuilder<void>(
                future: _defaultDiscountsFetched,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Color(0xFFF5F749), strokeWidth: 3.0);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return Text(
                    '£ ${receipt.cost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Saira',
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Color(0xFFF5F749),
                      // color: Colors.orangeAccent,
                      letterSpacing: 3.0,
                    ),
                  );
                }
              ),
            ],
          ),
          flexibleSpace: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x7064FFD2), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          actions: [
            _selectionMode? IconButton(
              icon: Icon(
                _selectedIds.length == items.length ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                size: 28,
              ),
              onPressed: () {
                setState(() {
                  if (_selectedIds.length == items.length) {
                    _selectedIds.clear();
                  } else {
                    _selectedIds.addAll(items.map((t) => t.id!));
                  }
                });
              },
            ) : const SizedBox(),
          ],
        ),
        body: Stack(
          children: [
            FutureBuilder<void>(
              future: _defaultDiscountsFetched,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Color(0xFF99E3DA), strokeWidth: 3.0);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 80.0),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      color: _selectedIds.contains(item.id)
                          ? const Color(0xFF282F31)
                          : const Color(0xFF1C2022),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      elevation: 12.0,
                      margin: const EdgeInsets.symmetric(vertical: 7.5),
                      child: InkWell(
                        splashColor: const Color(0xFF282F31),
                        onTap: () {
                          if (_selectionMode) {
                            setState(() {
                              if (_selectedIds.contains(item.id!)) {
                                _selectedIds.remove(item.id!);
                              } else {
                                _selectedIds.add(item.id!);
                              }
                            });
                          }
                        },
                        onLongPress: () {
                          if (!_selectionMode) {
                            setState(() {
                              _selectionMode = true;
                              _selectedIds.add(item.id!);
                            });
                          }
                        },
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 80.0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 23.0),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _selectionMode
                                    ? Expanded(
                                        flex: 2,
                                        child: Icon(
                                          _selectedIds.contains(item.id)
                                              ? Icons.check_box_rounded
                                              : Icons
                                                  .check_box_outline_blank_rounded,
                                          color: Colors.white,
                                          size: 28.0,
                                        ),
                                      )
                                    : const SizedBox(),
                                _selectionMode
                                    ? const Spacer(flex: 2)
                                    : const SizedBox(),
                                Expanded(
                                  flex: 13,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'Saira',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.4,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 7.0),
                                      () {
                                        final discount =
                                            receipt.discounts[item.id] ?? 0.0;
                                        if (discount == 0.0) return const SizedBox();
                                        return Text(
                                          'Dsc. %${discount.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 19.0,
                                            fontFamily: 'Saira',
                                            letterSpacing: 0.7,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFFF871F),
                                          ),
                                        );
                                      }(),
                                    ],
                                  ),
                                ),
                                const Spacer(flex: 3),
                                Expanded(
                                  flex: item.price >= 1000.0 ? 9 : 7,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '£ ${(item.price).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                          fontFamily: 'Saira',
                                          letterSpacing: 0.7,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF99E3DA),
                                        ),
                                      ),
                                      Text(
                                        'X ${receipt.getCountOf(item)}',
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                          fontFamily: 'Saira',
                                          letterSpacing: 0.7,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 40.0,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0B1419), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120.0,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0x5564FFD2), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _selectionMode
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: FloatingActionButton(
                                heroTag: UniqueKey(),
                                backgroundColor: const Color(0xFF64FFD2),
                                onPressed: () async {
                                  final discount = await showDialog<double?>(
                                    context: context,
                                    builder: (context) => AddDiscountDialog(validator: widget.checkoutService.discountValidator)
                                  );
                                  setState(() {
                                    if (discount != null) {
                                      widget.checkoutService.writeDiscount(_selectedIds.toList(), discount);
                                      _selectedIds.clear();
                                      _selectionMode = false;
                                    }
                                  });
                                },
                                child: const Icon(Icons.discount_outlined, color: Color(0xFF0B1419), size: 35.0)
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 25.0),
                            child: FloatingActionButton(
                                heroTag: UniqueKey(),
                                backgroundColor: const Color(0xFF64FFD2),
                                onPressed: () {
                                  setState(() {
                                    widget.checkoutService.removeDiscounts(_selectedIds.toList());
                                    _selectedIds.clear();
                                    _selectionMode = false;
                                  });
                                },
                                child: const Icon(Icons.remove_circle_outline_rounded, color: Color(0xFF0B1419), size: 35.0)
                            ),
                          ),
                        ],
                      )
                      : PressAndHoldButton(
                          onCheckout: () {
                            widget.checkoutService.checkoutReceipt().then((success) {
                              if (success) {
                                Navigator.pop(context, true);
                              } else {
                                showSuccessFlushbar(context, 'Error checking out receipt. Please try again.');
                              }
                            });
                          },
                          label: const Text(
                            'Hold to checkout',
                            style: TextStyle(
                              fontFamily: 'Saira',
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              color: Colors.black,
                            ),
                          ),
                          color: const Color(0xFF64FFD2),
                          holdDuration: const Duration(milliseconds: 750),
                        ),
                ),
              ),
            ),
          ],
        ),
        // persistentFooterButtons: [
        //
        // ],
        // persistentFooterAlignment: AlignmentDirectional.center,
      ),
    );
  }
}
