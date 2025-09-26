import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ListState Tests', () {
    test('should create ListState with default values', () {
      // act
      const state = ListState<String>();

      // assert
      expect(state.status, RequestState.empty);
      expect(state.items, isEmpty);
      expect(state.message, '');
    });

    test('should create ListState with custom values', () {
      // arrange
      const items = ['item1', 'item2', 'item3'];
      const message = 'Test message';

      // act
      const state = ListState<String>(status: RequestState.loading, items: items, message: message);

      // assert
      expect(state.status, RequestState.loading);
      expect(state.items, items);
      expect(state.message, message);
    });

    test('should copy with new values', () {
      // arrange
      const originalState = ListState<String>(
        status: RequestState.empty,
        items: ['item1'],
        message: 'original',
      );

      // act
      final newState = originalState.copyWith(
        status: RequestState.loaded,
        items: ['item1', 'item2'],
        message: 'updated',
      );

      // assert
      expect(newState.status, RequestState.loaded);
      expect(newState.items, ['item1', 'item2']);
      expect(newState.message, 'updated');
    });

    test('should copy with partial values', () {
      // arrange
      const originalState = ListState<String>(
        status: RequestState.empty,
        items: ['item1'],
        message: 'original',
      );

      // act
      final newState = originalState.copyWith(status: RequestState.loaded);

      // assert
      expect(newState.status, RequestState.loaded);
      expect(newState.items, ['item1']); // unchanged
      expect(newState.message, 'original'); // unchanged
    });

    test('should support different types', () {
      // arrange
      const intState = ListState<int>(
        status: RequestState.loaded,
        items: [1, 2, 3],
        message: 'numbers',
      );

      const boolState = ListState<bool>(
        status: RequestState.loaded,
        items: [true, false],
        message: 'booleans',
      );

      // assert
      expect(intState.items, [1, 2, 3]);
      expect(boolState.items, [true, false]);
    });

    test('should be equal when properties are same', () {
      // arrange
      const state1 = ListState<String>(
        status: RequestState.loaded,
        items: ['item1', 'item2'],
        message: 'test',
      );

      const state2 = ListState<String>(
        status: RequestState.loaded,
        items: ['item1', 'item2'],
        message: 'test',
      );

      // assert
      expect(state1, equals(state2));
    });

    test('should not be equal when properties are different', () {
      // arrange
      const state1 = ListState<String>(
        status: RequestState.loaded,
        items: ['item1'],
        message: 'test',
      );

      const state2 = ListState<String>(
        status: RequestState.loaded,
        items: ['item1', 'item2'],
        message: 'test',
      );

      // assert
      expect(state1, isNot(equals(state2)));
    });
  });

  group('edge cases', () {
    test('should handle empty list correctly', () {
      // arrange
      const state = ListState<String>(items: []);

      // act & assert
      expect(state.items, isEmpty);
      expect(state.status, RequestState.empty);
      expect(state.message, '');
    });

    test('should handle null-like values correctly', () {
      // arrange
      const state = ListState<String>(status: RequestState.empty, items: [], message: '');

      // act & assert
      expect(state.status, RequestState.empty);
      expect(state.items, isEmpty);
      expect(state.message, '');
    });

    test('should handle single item list correctly', () {
      // arrange
      const state = ListState<String>(items: ['single_item']);

      // act & assert
      expect(state.items, hasLength(1));
      expect(state.items.first, 'single_item');
    });

    test('should handle large list correctly', () {
      // arrange
      final largeList = List.generate(1000, (index) => 'item_$index');
      final state = ListState<String>(items: largeList);

      // act & assert
      expect(state.items, hasLength(1000));
      expect(state.items.first, 'item_0');
      expect(state.items.last, 'item_999');
    });

    test('should handle copyWith with null values correctly', () {
      // arrange
      const originalState = ListState<String>(
        status: RequestState.loaded,
        items: ['item1', 'item2'],
        message: 'test',
      );

      // act
      final newState = originalState.copyWith(status: null, items: null, message: null);

      // assert
      expect(newState.status, RequestState.loaded); // unchanged
      expect(newState.items, ['item1', 'item2']); // unchanged
      expect(newState.message, 'test'); // unchanged
    });
  });
}
