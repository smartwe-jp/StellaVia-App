import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/fund_project_favorites_local_data_source.dart';

class FundProjectFavoritesController extends StateNotifier<Set<String>> {
  FundProjectFavoritesController(this._localDataSource)
    : super(const <String>{}) {
    _loadOperation = _loadFavorites();
  }

  final FundProjectFavoritesLocalDataSource _localDataSource;
  Future<void>? _loadOperation;

  bool contains(String projectId) {
    final normalized = projectId.trim();
    if (normalized.isEmpty) {
      return false;
    }
    return state.contains(normalized);
  }

  void toggleFavorite(String projectId) {
    final normalized = projectId.trim();
    if (normalized.isEmpty) {
      return;
    }
    unawaited(_toggleFavorite(normalized));
  }

  Future<void> reload() async {
    _loadOperation = _loadFavorites();
    await _loadOperation;
  }

  Future<void> _toggleFavorite(String projectId) async {
    await (_loadOperation ?? Future<void>.value());

    final previous = Set<String>.from(state);
    final next = Set<String>.from(previous);
    if (next.contains(projectId)) {
      next.remove(projectId);
    } else {
      next.add(projectId);
    }

    state = next;

    try {
      await _localDataSource.saveFavoriteProjectIds(next);
    } catch (_) {
      if (mounted) {
        state = previous;
      }
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final favoriteIds = await _localDataSource.readFavoriteProjectIds();
      if (mounted) {
        state = favoriteIds;
      }
    } catch (_) {
      if (mounted) {
        state = const <String>{};
      }
    }
  }
}
