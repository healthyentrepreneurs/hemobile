import 'package:equatable/equatable.dart';

class Lang extends Equatable {
  const Lang({required this.code, required this.name,required this.country});
  final String code;
  final String name;
  final String country;
  @override
  List<Object?> get props => [code, name,country];
}
