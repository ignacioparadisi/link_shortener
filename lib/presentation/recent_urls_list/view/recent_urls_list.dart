import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu_link_shortener/presentation/urls_list/cubit/urls_list_cubit.dart';
import 'package:nu_link_shortener/presentation/urls_list/cubit/urls_list_state.dart';

class RecentURLsList extends StatelessWidget {
  RecentURLsList({super.key});
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<URLsListCubit, URLsListState>(
      listener: (context, state) {
        if (state.items.isNotEmpty) {
          _listKey.currentState?.insertItem(state.items.length - 1);
        }
      },
      builder: (context, state) {
        return ListView.separated(
          key: _listKey,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: state.items.length,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
          itemBuilder: (context, index) {
            final item = state.items[index];
            return AnyLinkPreview.builder(
              link: item.links.original,
              placeholderWidget: _previewCell(
                context: context,
                title: item.links.short,
              ),
              cache: Duration.zero,
              errorWidget: ListTile(title: Text(item.links.original)),
              itemBuilder: (context, metadata, imageProvider) {
                if (imageProvider == null) {
                  return ListTile(title: Text(item.links.short));
                }
                return _previewCell(
                  context: context,
                  title: item.links.short,
                  image: imageProvider,
                  onTap: () => print(item.id)
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _previewCell({
    required BuildContext context,
    required String title,
    ImageProvider<Object>? image,
    void Function()? onTap
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: image == null ? Colors.grey.withOpacity(0.2) : null,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                image: image == null
                    ? null
                    : DecorationImage(
                        image: image,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize))
          ],
        ),
      ),
    );
  }
}
