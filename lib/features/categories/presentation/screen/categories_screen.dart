import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/adaptive_nav_rail.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../domain/entities/category_entity.dart';
import '../bloc/categories_bloc.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';
import 'package:taskflowapp/core/utils/constants.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        leading: Semantics(
          label: AppStrings.back,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
            color: colorScheme.onSurface,
          ),
        ),
        title: Text(
          AppStrings.categories,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: AdaptiveNavRail(
        selectedIndex: 2,
        child: BlocBuilder<CategoriesBloc, CategoriesState>(
        buildWhen: (previous, current) {
          if(previous.runtimeType != current.runtimeType) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is CategoriesLoading || state is CategoriesInitial) {
            return const AppLoadingIndicator();
          }
          if (state is CategoriesFailed && (state.categories == null || state.categories!.isEmpty)) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppTokens.sXxxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: AppTokens.sXl),
                    PrimaryButton(
                      label: AppStrings.retry,
                      onPressed: () =>
                          context.read<CategoriesBloc>().add(LoadCategories()),
                    ),
                  ],
                ),
              ),
            );
          }
          final categories = state is CategoriesLoaded
              ? state.categories
              : state is CategoriesCreating
                  ? state.categories
                  : state is CategoriesFailed && state.categories != null
                      ? state.categories!
                      : <CategoryEntity>[];

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CategoriesBloc>().add(LoadCategories());
            },
            child: ResponsiveContainer(
              child: categories.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(
                        child: Text(
                          AppStrings.noCategoriesYet,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTokens.sXl,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppTokens.sM),
                        child: SurfaceCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.category_outlined,
                              color: colorScheme.primary,
                            ),
                            title: Text(
                              category.categoryName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        )
                      );
                    },
                  ),
            ),
          );
        },
        ),
      ),
      floatingActionButton: Semantics(
        label: AppStrings.createCategory,
        tooltip: AppStrings.createCategoryTooltip,
        button: false,
        child: FloatingActionButton(
          onPressed: () => _showCreateCategorySheet(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showCreateCategorySheet(BuildContext context) {
    final controller = TextEditingController();
    final theme = Theme.of(context);
    final categoriesBloc = context.read<CategoriesBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: categoriesBloc,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
              top: 16,
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Text(
                AppStrings.createCategory,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTokens.sXl),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: AppStrings.titleLabel,
                ),
                autofocus: true,
              ),
              const SizedBox(height: AppTokens.sXl),
              BlocConsumer<CategoriesBloc, CategoriesState>(
                listener: (context, state) {
                  if (state is CategoriesLoaded) {
                    Navigator.of(sheetContext).pop();
                  } else if (state is CategoriesFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    label: AppStrings.createCategory,
                    isLoading: state is CategoriesCreating || state is CategoriesLoading,
                    onPressed: () {
                      final title = controller.text.trim();
                      if (title.isNotEmpty) {
                        context.read<CategoriesBloc>().add(
                              CreateCategory(title: title),
                            );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
        );
      },
    );
  }
}
