// lib/ui/fine/fine_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/model/fine.dart';
import '../../data/repository/fine_repository.dart';
import '../../utils/providers.dart';
import '../../utils/network_utils.dart';

part 'fine_view_model.freezed.dart';

@freezed
class FineState with _$FineState {
  const factory FineState.initial() = _Initial;
  const factory FineState.loading() = _Loading;
  const factory FineState.loaded(Fine fine) = _Loaded;
  const factory FineState.error(String message) = _Error;
}

class FineViewModel extends StateNotifier<FineState> {
  final FineRepository _fineRepository;

  FineViewModel(this._fineRepository) : super(const FineState.initial());

  Future<void> fetchFineDetails({
    required String referenceNumber,
    required String categoryId,
  }) async {
    state = const FineState.loading();
    try {
      final fine = await _fineRepository.getFineDetails(
        referenceNumber: referenceNumber,
        categoryId: categoryId,
      );
      state = FineState.loaded(fine);
    } catch (e) {
      state = FineState.error(NetworkUtils.getErrorMessage(e));
    }
  }

  void reset() => state = const FineState.initial();
}

final fineViewModelProvider =
    StateNotifierProvider<FineViewModel, FineState>(
  (ref) => FineViewModel(ref.watch(fineRepositoryProvider)),
);
