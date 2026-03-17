import 'package:flutter/material.dart';

/// Builds [childBuilder] only after [load] has completed, showing a loading
/// indicator until then. Used for deferred route/screen loading.
class DeferredRouteLoader extends StatefulWidget {
  const DeferredRouteLoader({
    super.key,
    required this.load,
    required this.childBuilder,
  });

  final Future<void> Function() load;
  final Widget Function() childBuilder;

  @override
  State<DeferredRouteLoader> createState() => _DeferredRouteLoaderState();
}

class _DeferredRouteLoaderState extends State<DeferredRouteLoader> {
  bool _loaded = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    widget.load().then((_) {
      if (mounted) setState(() => _loaded = true);
    }).catchError((e, _) {
      if (mounted) setState(() => _error = e);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text('Failed to load: $_error'),
        ),
      );
    }
    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return widget.childBuilder();
  }
}
