import 'package:equatable/equatable.dart';
import 'package:nu_link_shortener/domain/entities/alias.dart';

enum URLsListStatus { initial, loading, success, failure }

class URLsListState extends Equatable {
  final URLsListStatus status;
  final List<Alias> items;

  const URLsListState({this.status = URLsListStatus.initial, this.items = const [] });

  URLsListState copyWith({URLsListStatus? status}) {
    return URLsListState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status, items];
}
