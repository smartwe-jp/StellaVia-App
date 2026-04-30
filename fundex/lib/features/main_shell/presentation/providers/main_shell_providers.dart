import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainShellCurrentTabIndexProvider = StateProvider<int>((ref) => 0);

final mainShellScrollControllerRegistryProvider =
    ChangeNotifierProvider<MainShellScrollControllerRegistry>((ref) {
      return MainShellScrollControllerRegistry();
    });

class MainShellScrollControllerRegistry extends ChangeNotifier {
  final Map<int, ScrollController> _controllers = <int, ScrollController>{};
  final ScrollController _fallbackController = ScrollController();
  bool _notifyQueued = false;
  bool _isDisposed = false;

  ScrollController controllerFor(int tabIndex) {
    return _controllers[tabIndex] ?? _fallbackController;
  }

  void attach(int tabIndex, ScrollController controller) {
    if (_isDisposed) {
      return;
    }
    if (_controllers[tabIndex] == controller) {
      return;
    }
    _controllers[tabIndex] = controller;
    _scheduleNotifyListeners();
  }

  void detach(int tabIndex, ScrollController controller) {
    if (_isDisposed) {
      return;
    }
    if (_controllers[tabIndex] != controller) {
      return;
    }
    _controllers.remove(tabIndex);
    _scheduleNotifyListeners();
  }

  void _scheduleNotifyListeners() {
    if (_notifyQueued || _isDisposed) {
      return;
    }
    _notifyQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyQueued = false;
      if (_isDisposed) {
        return;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controllers.clear();
    _fallbackController.dispose();
    super.dispose();
  }
}
