import 'package:flutter/material.dart';

import '../../../../core/pagination/blocs/pagination_bloc.dart';
import '../../../../core/pagination/models/pagination_models.dart';
import '../../../../core/pagination/widgets/pagination_wrapper.dart';
import '../../domain/entities/user_detail_entity.dart';
import '../../domain/usecases/fetch_user_details_use_case.dart';

class UserDetailsScreen extends StatefulWidget {
  final FetchUserDetailsUseCase fetchUserDetailsUseCase;

  const UserDetailsScreen({super.key, required this.fetchUserDetailsUseCase});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late final PaginationBloc<UserDetailsEntity> _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PaginationBloc<UserDetailsEntity>(
      fetchPage: ({
        required endpoint,
        required page,
        required pageSize,
        queryParams,
        headers,
      }) =>
          widget.fetchUserDetailsUseCase(
            endpoint: endpoint,
            page: page,
            pageSize: pageSize,
            queryParams: queryParams,
            headers: headers,
          ),
      endpoint: 'posts',
      config: const PaginationConfig(initialPage: 1, pageSize: 10),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: PaginationWrapper<UserDetailsEntity>(
        bloc: _bloc,
        padding: const EdgeInsets.all(24.0),
        itemBuilder: (context, post, index) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      '${post.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          post.title,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
    );
  }
}
