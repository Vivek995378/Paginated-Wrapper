import 'package:flutter/material.dart';

import '../models/pagination_models.dart';

class CommonPaginationWidgets {
  CommonPaginationWidgets._();

  static Widget buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Widget buildLoadMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  static Widget buildErrorWidget({
    required PaginationError error,
    required VoidCallback onRetry,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getErrorIcon(error),
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  _getErrorTitle(error),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Retry', textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget buildLoadMoreErrorWidget({
    required PaginationError error,
    required VoidCallback onRetry,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(error.message, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  static Widget buildEndReachedWidget({
    String message = 'You\'ve reached the end',
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }

  static IconData _getErrorIcon(PaginationError error) {
    if (error is NetworkPaginationError) return Icons.wifi_off_outlined;
    if (error is ServerPaginationError) return Icons.cloud_off_outlined;
    if (error is TimeoutPaginationError) return Icons.access_time_outlined;
    return Icons.error_outline;
  }

  static String _getErrorTitle(PaginationError error) {
    if (error is NetworkPaginationError) return 'No Internet Connection';
    if (error is ServerPaginationError) return 'Server Error';
    if (error is TimeoutPaginationError) return 'Request Timeout';
    if (error is ParsingPaginationError) return 'Data Error';
    return 'Something Went Wrong';
  }
}
