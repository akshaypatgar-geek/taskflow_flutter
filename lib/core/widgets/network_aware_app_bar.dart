import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflowapp/core/network/bloc/network_bloc.dart';
import 'package:taskflowapp/core/theme/app_theme.dart';
import 'package:taskflowapp/core/utils/constants.dart';

class NetworkAwareAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NetworkAwareAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<NetworkBloc, NetworkState>(
      builder: (context, networkState) {
        final isOffline = networkState is NetworkOffline;
        final offlineColor = AppStatusColors.of(context).highPriority;
        final fgColor = isOffline ? Colors.white : colorScheme.onSurface;

        return AppBar(
          toolbarHeight: 72,
          centerTitle: false,
          backgroundColor: isOffline ? offlineColor : colorScheme.surface,
          elevation: 0,
          iconTheme: IconThemeData(color: fgColor),
          leading: leading,
          actions: actions,
          title: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isOffline)
                  const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_off, color: Colors.white, size: 14),
                        SizedBox(width: 6),
                        Text(
                          AppStrings.noInternetConnection,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                DefaultTextStyle(
                  style:
                      Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                            color: fgColor,
                          ) ??
                          TextStyle(
                            color: fgColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: title,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
