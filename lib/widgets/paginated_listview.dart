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
  State<PaginatedListView<T>> createState() =>
      _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  final controller = ScrollController();

  final List<T> items = [];

  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetch();

    controller.addListener(() {
      if (controller.position.pixels >
          controller.position.maxScrollExtent - 200) {
        _fetch();
      }
    });
  }

  Future<void> _fetch() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    try {
      final newItems = await widget.fetchPage(page);

      setState(() {
        if (newItems.isEmpty || newItems.length < 10) {
          hasMore = false;
        }

        items.addAll(newItems);
        page++;
      });
    } catch (_) {} finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: controller,
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index < items.length) {
          return widget.itemBuilder(items[index]);
        }

        if (!hasMore) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text("No more data")),
          );
        }

        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}