import 'package:apidash/consts.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/models/environment_model.dart';
import 'package:apidash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EnvironmentsPane extends ConsumerWidget {
  const EnvironmentsPane({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox();
  }
}

class EnvironmentsList extends HookConsumerWidget {
  const EnvironmentsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environmentSequence = ref.watch(environmentSequenceProvider);
    final environmentItems = ref.watch(environmentsStateNotifierProvider)!;
    final alwaysShowEnvironmentsPaneScrollbar = ref.watch(settingsProvider
        .select((value) => value.alwaysShowCollectionPaneScrollbar));
    final filterQuery = ref.watch(environmentSearchQueryProvider).trim();

    ScrollController scrollController = useScrollController();
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: alwaysShowEnvironmentsPaneScrollbar,
      radius: const Radius.circular(12),
      child: filterQuery.isEmpty
          ? ReorderableListView.builder(
              padding: context.isMediumWindow
                  ? EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(context).bottom,
                      right: 8,
                    )
                  : kPe8,
              scrollController: scrollController,
              buildDefaultDragHandles: false,
              itemCount: environmentSequence.length,
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                if (oldIndex != newIndex) {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .reorder(oldIndex, newIndex);
                }
              },
              itemBuilder: (context, index) {
                var id = environmentSequence[index];
                if (kIsMobile) {
                  return ReorderableDelayedDragStartListener(
                    key: ValueKey(id),
                    index: index,
                    child: Padding(
                      padding: kP1,
                      child: EnvironmentItem(
                        id: id,
                        environmentModel: environmentItems[id]!,
                      ),
                    ),
                  );
                }
                return ReorderableDragStartListener(
                  key: ValueKey(id),
                  index: index,
                  child: Padding(
                    padding: kP1,
                    child: EnvironmentItem(
                      id: id,
                      environmentModel: environmentItems[id]!,
                    ),
                  ),
                );
              },
            )
          : ListView(
              padding: context.isMediumWindow
                  ? EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(context).bottom,
                      right: 8,
                    )
                  : kPe8,
              controller: scrollController,
              children: environmentSequence.map((id) {
                var item = environmentItems[id]!;
                if (item.name.toLowerCase().contains(filterQuery)) {
                  return Padding(
                    padding: kP1,
                    child: EnvironmentItem(
                      id: id,
                      environmentModel: item,
                    ),
                  );
                }
                return const SizedBox();
              }).toList(),
            ),
    );
  }
}

class EnvironmentItem extends ConsumerWidget {
  const EnvironmentItem({
    super.key,
    required this.id,
    required this.environmentModel,
  });

  final String id;
  final EnvironmentModel environmentModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedEnvironmentIdProvider);

    return Text(environmentModel.name);
  }
}
