import 'package:equatable/equatable.dart';

abstract class BreedsEvent extends Equatable {
  const BreedsEvent();

  @override
  List<Object?> get props => [];
}

class BreedsStarted extends BreedsEvent {
  const BreedsStarted();
}

class BreedsRefreshed extends BreedsEvent {
  const BreedsRefreshed();
}

class BreedsLoadMoreRequested extends BreedsEvent {
  const BreedsLoadMoreRequested();
}

class BreedsSearchChanged extends BreedsEvent {
  const BreedsSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
