import 'package:flutter/material.dart';
import 'dart:async';

class SearchSortBar extends StatefulWidget {

  final void Function(String searchBar, String sortBy, bool asc) onChanged;
  final Duration searchDebounceDuration;

  const SearchSortBar({required this.onChanged, this.searchDebounceDuration = const Duration(milliseconds: 500), super.key});

  @override
  State<SearchSortBar> createState() => _SearchSortBarState();
}

class _SearchSortBarState extends State<SearchSortBar> {

  final _searchBarController = TextEditingController();
  Timer? _searchDebounce;
  String sortByOption = 'name';
  bool ascending = true;

  void _onSearchChanged(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(
      widget.searchDebounceDuration,
      () => widget.onChanged(query, sortByOption, ascending),
    );
  }

  final sortByOptions = ['Name', 'Popularity ▲', 'Price ▲', 'Popularity ▼', 'Price ▼'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.75), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Material(
          color: const Color(0xFF08090A),
          elevation: 20.0,
          shadowColor: Colors.black,
          borderRadius: BorderRadius.circular(60.0),
          clipBehavior: Clip.antiAlias,
          child: SearchBar(
            controller: _searchBarController,
            backgroundColor: MaterialStateColor.resolveWith((states) => const Color(0xFF08090A)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60.0),
              ),
            ),
            leading: const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Icon(Icons.search, color: Color(0xFFD9D9D9), size: 30.0),
            ),
            trailing: [
              IconButton(
                icon: const Icon(Icons.clear_rounded, color: Color(0xFFD9D9D9), size: 30.0),
                onPressed: () => _searchBarController.clear(),
              ),
              PopupMenuButton<String>(
                color: const Color(0xFF626876),
                elevation: 60.0,
                shadowColor: Colors.black,
                icon: const Icon(Icons.sort_rounded, color: Colors.white),
                itemBuilder: (context) => sortByOptions.map((String option) {
                  return PopupMenuItem<String>(
                    value: option,
                    child: Row(
                        children: [
                          Icon(
                            option == sortByOption ? Icons.check : null,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                              option,
                              style: TextStyle(
                                color: option == sortByOption ? Colors.white : Colors.white38,
                                fontFamily: 'Saira',
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              )
                          ),
                        ]
                    ),
                  );
                }).toList(),
                onSelected: (String option) {
                  final optionParts = option.split(' ');
                  sortByOption = optionParts[0].toLowerCase();
                  ascending = optionParts.length == 1 || optionParts[1] == '▼';
                  setState(() {
                    widget.onChanged(_searchBarController.text.trim(), sortByOption, ascending);
                  });
                },
              ),
            ],
            hintText: 'Search for an item',
            hintStyle: MaterialStateProperty.all(
              TextStyle(
                color: const Color(0xFFD9D9D9).withOpacity(0.35),
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
                fontFamily: 'Saira',
              ),
            ),
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                color: Color(0xFFD9D9D9),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Saira',
              ),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
      ),
    );
  }

}