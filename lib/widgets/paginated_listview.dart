import 'package:flutter/material.dart';

class PaginatedListView<T> extends StatefulWidget {
  final Future<List<T>> Function(int page) fetchPage;
  final Widget Function(T item) itemBuilder;

  const PaginatedListView({
    super.key,
    required this.fetchPage,
    required this.itemBuilder,
  });

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  final ScrollController _controller = ScrollController();

  List<T> items = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetch();

    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        _fetch();
      }
    });
  }

  Future<void> _fetch() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      final newItems = await widget.fetchPage(page);

      setState(() {
        page++;
        items.addAll(newItems);
        if (newItems.isEmpty) hasMore = false;
      });
    } catch (e) {
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index < items.length) {
          return widget.itemBuilder(items[index]);
        }

        if (!hasMore) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text("End of data")),
          );
        }

        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
