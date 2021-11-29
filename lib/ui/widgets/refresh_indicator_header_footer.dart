import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class RefreshHeader extends StatelessWidget {
  const RefreshHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      height: 50,
      builder: (context, status) {
        if (status == RefreshStatus.refreshing)
          return LoadingIndicator();
        else if (status == RefreshStatus.idle)
          return Text(
            'Pull down to refresh',
            textAlign: TextAlign.center,
          );
        else if (status == RefreshStatus.canRefresh)
          return Text(
            'Release to refresh',
            textAlign: TextAlign.center,
          );
        return Container();
      },
    );
  }
}

class RefreshFooter extends StatelessWidget {
  const RefreshFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      height: 50 + MediaQuery.of(context).padding.bottom,
      builder: (context, status) {
        if (status == LoadStatus.loading)
          return LoadingIndicator();
        else if (status == LoadStatus.noMore)
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'No more records',
              textAlign: TextAlign.center,
            ),
          );
        return Container();
      },
    );
  }
}
