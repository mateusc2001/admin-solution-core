import 'package:admin_solution_core/model/proposta.dart';

abstract class PropostaEvent {}

class LoadPropostaEvent extends PropostaEvent {
  String endpoint;

  LoadPropostaEvent({
    required this.endpoint,
  });
}

class AddPropostaEvent extends PropostaEvent {
  Proposta proposta;

  AddPropostaEvent({
    required this.proposta,
  });
}

class RemovePropostaEvent extends PropostaEvent {
  Proposta proposta;

  RemovePropostaEvent({
    required this.proposta,
  });
}
