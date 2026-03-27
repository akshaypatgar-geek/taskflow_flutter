import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../../core/utils/snackbar_helper.dart';
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
        leading: context.canPop()
            ? Semantics(
                label: AppStrings.back,
                tooltip: AppStrings.back,
                button: true,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: AppStrings.back,
                  onPressed: () => context.pop(),
                  color: colorScheme.onSurface,
                ),
              )
            : null,
        title: Text(
          AppStrings.categories,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        buildWhen: (previous, current) {
          if (previous.runtimeType != current.runtimeType) {
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
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: Center(
                            child: Text(
                              AppStrings.noCategoriesYet,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTokens.sXl,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        key: ValueKey(category.categoryId),
                        padding: const EdgeInsets.only(bottom: AppTokens.sM),
                        child: SurfaceCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTokens.sXl,
                            vertical: AppTokens.sL,
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
      floatingActionButton: Semantics(
        label: AppStrings.createCategory,
        tooltip: AppStrings.createCategoryTooltip,
        button: true,
        child: FloatingActionButton(
          heroTag: 'categories_fab_create',
          tooltip: AppStrings.createCategory,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTokens.rL)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: categoriesBloc,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + AppTokens.sXl,
              top: AppTokens.sXl,
              left: AppTokens.sXl,
              right: AppTokens.sXl,
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
                maxLength: AppTokens.categoryTitleMaxLength,
              ),
              const SizedBox(height: AppTokens.sXl),
              BlocConsumer<CategoriesBloc, CategoriesState>(
                buildWhen: (previous, current) =>
                    (previous is CategoriesCreating) !=
                        (current is CategoriesCreating) ||
                    (previous is CategoriesLoading) !=
                        (current is CategoriesLoading),
                listener: (context, state) {
                  if (state is CategoriesLoaded) {
                    Navigator.of(sheetContext).pop();
                  } else if (state is CategoriesFailed) {
                    SnackbarHelper.showErrorMessage(
                      context: context,
                      message: state.errorMessage,
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
    ).whenComplete(() => controller.dispose());
  }
}
