import 'package:admin_solution_core/model/proposta.dart';
import 'package:admin_solution_core/service/propostaBlocV2/propostaService.dart';
import 'package:admin_solution_core/service/propostaBlocV2/propostaEvents.dart';
import 'package:admin_solution_core/service/propostaBlocV2/propostaState.dart';
import 'package:bloc/bloc.dart';

class PropostaBloc extends Bloc<PropostaEvent, PropostaState> {
  final _propostaService = PropostaService();

  PropostaBloc() : super(PropostaInitialState()) {
    on<LoadPropostaEvent>(
          (event, emit) async {
            return emit(PropostaSuccessState(propostaList: await _propostaService.findAll(event.endpoint)));
          },
    );

    on<AddPropostaEvent>(
          (event, emit) => emit(PropostaSuccessState(propostaList: _propostaService.create(event.proposta))),
    );

    on<RemovePropostaEvent>(
          (event, emit) => emit(PropostaSuccessState(propostaList: _propostaService.delete(event.proposta))),
    );
  }

}