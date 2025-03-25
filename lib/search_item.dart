import 'package:flutter/material.dart';
import 'task.dart';

class SearchBar extends StatefulWidget {
  final List<Task> tasks;
  final Function(String) onSearch;

  const SearchBar({super.key, required this.tasks, required this.onSearch});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            onChanged: widget.onSearch,
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  widget.onSearch('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        );
      }, 
      suggestionsBuilder: (context, query) {
        final filteredTasks = widget.tasks.where((task) =>
            task.title.toLowerCase().contains(query.toString().toLowerCase()));

        return filteredTasks.map((task) {
          return ListTile(
            title: Text(task.title),
            onTap: () {
              searchController.text = task.title;
              widget.onSearch(task.title);
            },
          );
        }).toList();
      }
    );
  }
}


