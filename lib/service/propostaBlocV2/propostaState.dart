import 'package:admin_solution_core/model/proposta.dart';

abstract class PropostaState {
  List<Proposta> propostaList;

  PropostaState({
    required this.propostaList,
  });
}

class PropostaInitialState extends PropostaState {
  PropostaInitialState() : super(propostaList: []);
}

class PropostaSuccessState extends PropostaState {
  PropostaSuccessState({required List<Proposta> propostaList}) : super(propostaList: propostaList);
}
