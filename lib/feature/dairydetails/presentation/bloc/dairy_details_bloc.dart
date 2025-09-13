import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/dairydetails/presentation/bloc/dairy_details_state.dart';
import 'package:newsee/feature/dairydetails/presentation/bloc/dairy_details_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DairyDetailsBloc extends Bloc<DairyDetailsEvent, DairyDetailsState> {
  static const String storageKey = "dairy_details";

  DairyDetailsBloc() : super(DairyDetailsState.initial()) {
    on<LoadDetails>(_onLoadDetails);
    on<AddDetails>(_onAddDetails);
    on<DeleteDetails>(_onDeleteDetails);
  }

  // Builds a unique storage key per lead
  String _getStorageKey(String? leadId) {
    if (leadId == null || leadId.isEmpty) {
      throw Exception("Tried to save /load without a valid leadId");
    }
    return "$storageKey-$leadId";
  }

  // Load saved details for a given lead
  Future<void> _onLoadDetails(
    LoadDetails event,
    Emitter<DairyDetailsState> emit,
  ) async {
    emit(state.copyWith(status: DairyDetailsStatus.loading));

    try {
      final prefs = await SharedPreferences.getInstance();

      final savedData = prefs.getString(_getStorageKey(event.leadId));

      if (savedData != null) {
        final decoded = jsonDecode(savedData) as List<dynamic>;
        final details =
            decoded.map((e) => Map<String, dynamic>.from(e)).toList();

        emit(
          state.copyWith(
            addedDetails: details,
            status: DairyDetailsStatus.success,
            error: null,
          ),
        );
      } else {
        emit(state.copyWith(status: DairyDetailsStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(status: DairyDetailsStatus.failure, error: e.toString()),
      );
    }
  }

  // Add a new detail entry for a lead
  Future<void> _onAddDetails(
    AddDetails event,
    Emitter<DairyDetailsState> emit,
  ) async {
    emit(state.copyWith(status: DairyDetailsStatus.loading));

    try {
      final updated = List<Map<String, dynamic>>.from(state.addedDetails)
        ..add(event.detail);

      emit(
        state.copyWith(
          addedDetails: updated,
          status: DairyDetailsStatus.success,
          error: null,
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_getStorageKey(event.leadId), jsonEncode(updated));
    } catch (e) {
      emit(
        state.copyWith(status: DairyDetailsStatus.failure, error: e.toString()),
      );
    }
  }

  /// Delete a detail entry by index
  Future<void> _onDeleteDetails(
    DeleteDetails event,
    Emitter<DairyDetailsState> emit,
  ) async {
    emit(state.copyWith(status: DairyDetailsStatus.loading));

    try {
      if (event.index < 0 || event.index >= state.addedDetails.length) {
        emit(
          state.copyWith(
            status: DairyDetailsStatus.failure,
            error: "Invalid index ${event.index}",
          ),
        );
        return;
      }

      final updated = List<Map<String, dynamic>>.from(state.addedDetails)
        ..removeAt(event.index);

      emit(
        state.copyWith(
          addedDetails: updated,
          status: DairyDetailsStatus.success,
          error: null,
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_getStorageKey(event.leadId), jsonEncode(updated));
    } catch (e) {
      emit(
        state.copyWith(status: DairyDetailsStatus.failure, error: e.toString()),
      );
    }
  }
}
