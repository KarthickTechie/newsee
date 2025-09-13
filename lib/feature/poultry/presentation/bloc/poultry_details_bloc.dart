import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:newsee/feature/poultry/presentation/bloc/poultry_details_event.dart';
import 'package:newsee/feature/poultry/presentation/bloc/poultry_details_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PoultryBloc extends Bloc<PoultryEvent, PoultryState> {
  static const String storageKey = "poultry_details";

  PoultryBloc() : super(PoultryState.initial()) {
    on<LoadPoultryDetails>(_onLoadPoultryDetails);
    on<AddPoultryDetails>(_onAddPoultryDetails);
    on<RemovePoultryDetails>(_onRemovePoultryDetails);
  }
  // Builds a unique storage key per lead

  String getStorageKey(String? leadId) {
    if (leadId == null || leadId.isEmpty) {
      throw Exception("Tried to save/load without a valid leadId");
    }
    return "$storageKey-$leadId";
  }
  // Load saved details for a given lead

  Future<void> _onLoadPoultryDetails(
    LoadPoultryDetails event,
    Emitter<PoultryState> emit,
  ) async {
    emit(state.copyWith(status: PoultryDetailsStatus.loading));
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedData = prefs.getString(getStorageKey(event.leadId));

      if (savedData != null) {
        final decoded = jsonDecode(savedData) as List<dynamic>;
        final details =
            decoded.map((e) => Map<String, dynamic>.from(e)).toList();

        emit(
          state.copyWith(
            addedDetails: details,
            status: PoultryDetailsStatus.success,
            error: null,
          ),
        );
      } else {
        emit(state.copyWith(status: PoultryDetailsStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: PoultryDetailsStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  // Add a new detail entry for a lead

  Future<void> _onAddPoultryDetails(
    AddPoultryDetails event,
    Emitter<PoultryState> emit,
  ) async {
    emit(state.copyWith(status: PoultryDetailsStatus.loading));
    try {
      final updatedList = List<Map<String, dynamic>>.from(state.addedDetails)
        ..add(event.details);

      emit(
        state.copyWith(
          addedDetails: updatedList,
          status: PoultryDetailsStatus.success,
          error: null,
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        getStorageKey(event.leadId),
        jsonEncode(updatedList),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PoultryDetailsStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  /// Delete a detail entry by index

  Future<void> _onRemovePoultryDetails(
    RemovePoultryDetails event,
    Emitter<PoultryState> emit,
  ) async {
    emit(state.copyWith(status: PoultryDetailsStatus.loading));
    try {
      final updatedList = List<Map<String, dynamic>>.from(state.addedDetails)
        ..removeAt(event.index);

      emit(
        state.copyWith(
          addedDetails: updatedList,
          status: PoultryDetailsStatus.success,
          error: null,
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        getStorageKey(event.leadId),
        jsonEncode(updatedList),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PoultryDetailsStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
