part of 'add_account_bloc.dart';

abstract class AddAccountEvent extends Equatable {
  const AddAccountEvent();

  @override
  List<Object?> get props => [];
}

class AddBankAccount extends AddAccountEvent {
  final String photoFilePath;
  final Map<String, String> fields;

  AddBankAccount({required this.photoFilePath, required this.fields});
}

class AddUPIAccount extends AddAccountEvent {
  final Map<String, String> body;

  AddUPIAccount(this.body);
}
