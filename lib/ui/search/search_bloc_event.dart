import 'package:equatable/equatable.dart';

abstract class SearchBlocEvent extends Equatable {
  const SearchBlocEvent();

  @override
  List<Object> get props => throw UnimplementedError();
}

class SearchUserEvent extends SearchBlocEvent {
  final String query;
  SearchUserEvent(this.query);

  @override
  List<Object> get props => [query];
}
