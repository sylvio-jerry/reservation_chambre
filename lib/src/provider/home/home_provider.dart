import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageIndexNotifier extends StateNotifier<int> {
  PageIndexNotifier() : super(0);

  void setPageIndex(int value) {
    state = value;
  }
}

final pageIndexProvider = StateNotifierProvider<PageIndexNotifier, int>((ref) => PageIndexNotifier());