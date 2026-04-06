import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflowapp/core/network/bloc/network_bloc.dart';
import 'package:taskflowapp/core/theme/app_theme.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';
import 'package:taskflowapp/core/utils/constants.dart';

/// Connection status strip + standard title [AppBar]. Use [of] so [PreferredSize]
/// height tracks offline/online via [context.watch].
abstract final class NetworkAwareAppBar {
  NetworkAwareAppBar._();

  static PreferredSizeWidget of(
    BuildContext context, {
    required Widget title,
    Widget? leading,
    List<Widget>? actions,
  }) {
    final offline = context.watch<NetworkBloc>().state is NetworkOffline;
    final stripHeight = offline ? AppTokens.networkOfflineStripHeight : 0.0;
    final colorScheme = Theme.of(context).colorScheme;
    final offlineColor = AppStatusColors.of(context).highPriority;
    final statusBarPadding = MediaQuery.paddingOf(context).top;

    // Reserve status bar inset so the offline strip sits *below* the system
    // status bar, then the title AppBar sits below the strip.
    final totalHeight = statusBarPadding + stripHeight + kToolbarHeight;

    return PreferredSize(
      preferredSize: Size.fromHeight(totalHeight),
      child: Material(
        color: colorScheme.surface,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: statusBarPadding),
            if (offline)
              Material(
                color: offlineColor,
                elevation: 1,
                shadowColor: Colors.black.withValues(alpha: 0.26),
                child: const SizedBox(
                  height: AppTokens.networkOfflineStripHeight,
                  width: double.infinity,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_off,
                          color: Colors.white,
                          size: AppTokens.fXl,
                        ),
                        SizedBox(width: AppTokens.sM),
                        Text(
                          AppStrings.noInternetConnection,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppTokens.networkOfflineBannerFontSize,
                            fontWeight: AppTokens.fontWeightSemiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            AppBar(
              primary: false,
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.onSurface,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: leading,
              title: title,
              actions: actions,
              centerTitle: false,
              toolbarHeight: kToolbarHeight,
            ),
          ],
        ),
      ),
    );
  }
}
