import 'package:flutter/material.dart';
import 'package:taskflowapp/core/utils/constants.dart';

import '../widgets/app_loading_indicator.dart';


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
          child: Text('${AppStrings.failedToLoad}: $_error'),
        ),
      );
    }
    if (!_loaded) {
      return const Scaffold(
        body: AppLoadingIndicator(),
      );
    }
    return widget.childBuilder();
  }
}
