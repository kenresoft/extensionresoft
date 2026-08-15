// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A functional programming construct representing a value of one of two possible types.
///
/// [Either] is commonly used for error handling where:
/// - [Left] represents a failure case (typically holding an error)
/// - [Right] represents a success case (typically holding a successful value)
///
/// This implementation provides comprehensive methods for transforming, combining,
/// and working with Either values in a type-safe manner.
///
/// Example Usage:
/// ```dart
/// Either<Exception, int> parseNumber(String input) {
///   try {
///     return Right(int.parse(input));
///   } catch (e) {
///     return Left(Exception('Invalid number: $input'));
///   }
/// }
/// ```
sealed class Either<L, R> {
  const Either();

  // =====================================================================
  // Factories
  // =====================================================================

  /// Creates a [Left] value (typically representing an error/failure case).
  factory Either.left(L value) = Left<L, R>;

  /// Creates a [Right] value (typically representing a success case).
  factory Either.right(R value) = Right<L, R>;

  // =====================================================================
  // Basic Properties
  // =====================================================================

  /// Returns true if this is a [Left] value.
  bool get isLeft => this is Left<L, R>;

  /// Returns true if this is a [Right] value.
  bool get isRight => this is Right<L, R>;

  // =====================================================================
  // Value Accessors
  // =====================================================================

  /// Gets the [Left] value.
  ///
  /// Throws a [StateError] if this is a [Right].
  L get left => switch (this) {
    Left(value: final value) => value,
    Right() => throw StateError('Cannot get left of Right'),
  };

  /// Gets the [Right] value.
  ///
  /// Throws a [StateError] if this is a [Left].
  R get right => switch (this) {
    Right(value: final value) => value,
    Left() => throw StateError('Cannot get right of Left'),
  };

  // =====================================================================
  // Transformations
  // =====================================================================

  /// Transforms both sides of the [Either] with the provided functions.
  Either<L2, R2> bimap<L2, R2>(L2 Function(L) mapLeft, R2 Function(R) mapRight) => switch (this) {
    Left(value: final l) => Left<L2, R2>(mapLeft(l)),
    Right(value: final r) => Right<L2, R2>(mapRight(r)),
  };

  /// Transforms the [Right] value while leaving the [Left] unchanged.
  Either<L, R2> map<R2>(R2 Function(R) mapRight) => bimap((l) => l, mapRight);

  /// Transforms the [Left] value while leaving the [Right] unchanged.
  Either<L2, R> mapLeft<L2>(L2 Function(L) mapLeft) => bimap(mapLeft, (r) => r);

  // =====================================================================
  // Monadic Operations
  // =====================================================================

  /// Flat-maps the [Right] value to a new [Either].
  Either<L, R2> flatMap<R2>(Either<L, R2> Function(R) f) => switch (this) {
    Left(value: final l) => Left<L, R2>(l),
    Right(value: final r) => f(r),
  };

  /// Flat-maps the [Left] value to a new [Either].
  Either<L2, R> flatMapLeft<L2>(Either<L2, R> Function(L) f) => switch (this) {
    Left(value: final l) => f(l),
    Right(value: final r) => Right<L2, R>(r),
  };

  // =====================================================================
  // Folding
  // =====================================================================

  /// Collapses the [Either] into a single value by applying the appropriate function.
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => switch (this) {
    Left(value: final l) => onLeft(l),
    Right(value: final r) => onRight(r),
  };

  // =====================================================================
  // Side Effects
  // =====================================================================

  /// Executes [action] if this is a [Right].
  Either<L, R> onRight(void Function(R) action) {
    if (isRight) action(right);
    return this;
  }

  /// Executes [action] if this is a [Left].
  Either<L, R> onLeft(void Function(L) action) {
    if (isLeft) action(left);
    return this;
  }

  // =====================================================================
  // Nullable Access
  // =====================================================================

  /// Returns the [Right] value if present, otherwise null.
  R? get rightOrNull => isRight ? right : null;

  /// Returns the [Left] value if present, otherwise null.
  L? get leftOrNull => isLeft ? left : null;

  // =====================================================================
  // Error Handling Utilities
  // =====================================================================

  /// Executes [action] in a try-catch block, converting exceptions to [Left].
  static Either<L, R> tryCatch<L, R>(L Function(Object, StackTrace) onError, R Function() action) {
    try {
      return Right<L, R>(action());
    } catch (e, st) {
      return Left<L, R>(onError(e, st));
    }
  }

  /// Async version of [tryCatch].
  static Future<Either<L, R>> tryCatchAsync<L, R>(
    L Function(Object, StackTrace) onError,
    Future<R> Function() action,
  ) async {
    try {
      return Right<L, R>(await action());
    } catch (e, st) {
      return Left<L, R>(onError(e, st));
    }
  }

  /// Async version of [tryCatch] with typed exception handling.
  static Future<Either<L, R>> tryCatchAsyncTyped<L, R, E extends Exception>(
    L Function(E) onError,
    Future<R> Function() action,
  ) async {
    try {
      return Right<L, R>(await action());
    } on E catch (e) {
      return Left<L, R>(onError(e));
    }
  }

  // =====================================================================
  // Combining Operations
  // =====================================================================

  /// Combines two [Either] values, keeping the first [Left] if either is [Left].
  Either<L, R2> zip<R2>(Either<L, R2> other) => switch (this) {
    Left(value: final l) => Left<L, R2>(l),
    Right(value: final _) => other,
  };

  /// Combines two [Either] values with a combining function.
  Either<L, R3> zipWith<R2, R3>(Either<L, R2> other, R3 Function(R, R2) combine) => switch (this) {
    Left(value: final l) => Left<L, R3>(l),
    Right(value: final r) => other.map((r2) => combine(r, r2)),
  };

  // =====================================================================
  // Recovery Operations
  // =====================================================================

  /// Recovers from a [Left] by converting it to a [Right] with the provided function.
  Either<L, R> recover(R Function(L) recovery) => switch (this) {
    Left(value: final l) => Right<L, R>(recovery(l)),
    Right() => this,
  };

  /// Recovers from a [Left] by converting it to another [Either].
  Either<L, R> recoverWith(Either<L, R> Function(L) recovery) => switch (this) {
    Left(value: final l) => recovery(l),
    Right() => this,
  };

  // =====================================================================
  // Filtering
  // =====================================================================

  /// Filters [Right] values, converting to [Left] if the predicate fails.
  Either<L, R> filter(bool Function(R) predicate, L Function() orElse) => switch (this) {
    Left() => this,
    Right(value: final r) => predicate(r) ? this : Left<L, R>(orElse()),
  };

  // =====================================================================
  // Conversion
  // =====================================================================

  /// Converts this [Either] to a [Future].
  Future<Either<L, R>> toFuture() => Future.value(this);

  // =====================================================================
  // Equality and Representation
  // =====================================================================

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (runtimeType == other.runtimeType &&
          switch ((this, other)) {
            (Left(value: final l1), Left(value: final l2)) => l1 == l2,
            (Right(value: final r1), Right(value: final r2)) => r1 == r2,
            _ => false,
          });

  @override
  int get hashCode => switch (this) {
    Left(value: final l) => Object.hash(runtimeType, l),
    Right(value: final r) => Object.hash(runtimeType, r),
  };

  @override
  String toString() => switch (this) {
    Left(value: final l) => 'Left($l)',
    Right(value: final r) => 'Right($r)',
  };
}

// ========================================================================
// Left Variant
// ========================================================================

/// The [Left] side of [Either], typically representing an error/failure case.
final class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);
}

// ========================================================================
// Right Variant
// ========================================================================

/// The [Right] side of [Either], typically representing a success case.
final class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);
}

// ========================================================================
// Unit Type
// ========================================================================

/// A type representing the absence of a value (similar to `void` but usable in generics).
///
/// Used in functional programming contexts where a concrete type is needed to represent
/// "no value" without using `void`.
final class Unit {
  const Unit._();

  /// The single instance of [Unit].
  static const Unit instance = Unit._();

  @override
  bool operator ==(Object other) => other is Unit;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'Unit()';
}

/// The canonical [Unit] instance.
const unit = Unit.instance;

// ========================================================================
// Option Type
// ========================================================================

/// A functional programming construct representing an optional value.
///
/// [Option] can be either [Some] (containing a value) or [None] (no value).
/// Similar to `dartz`'s Option or Rust's Option type.
///
/// Example Usage:
/// ```dart
/// Option<int> parseInt(String input) {
///   try {
///     return Some(int.parse(input));
///   } catch (e) {
///     return None();
///   }
/// }
/// ```
sealed class Option<T> {
  const Option();

  /// Creates a [Some] value containing [value].
  factory Option.some(T value) => Some(value);

  /// Creates a [None] value.
  factory Option.none() => const None();

  // =====================================================================
  // Basic Properties
  // =====================================================================

  /// Returns the contained value or null if [None].
  T? get valueOrNull;

  /// Returns true if this is a [Some] value.
  bool get isSome;

  /// Returns true if this is a [None] value.
  bool get isNone;

  // =====================================================================
  // Core Operations
  // =====================================================================

  /// Collapses the [Option] into a single value.
  R fold<R>(R Function() onNone, R Function(T) onSome);

  /// Transforms the contained value if [Some].
  Option<R> map<R>(R Function(T) mapper);

  /// Flat-maps the contained value if [Some].
  Option<R> flatMap<R>(Option<R> Function(T) mapper);

  /// Gets the contained value or computes a default.
  T getOrElse(T Function() orElse);

  /// Converts to [Either], mapping [None] to [Left] using [onNone].
  Either<L, T> toEither<L>(L Function() onNone);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  @override
  String toString();
}

// ========================================================================
// Some Variant
// ========================================================================

/// The [Some] variant of [Option], representing a present value.
final class Some<T> extends Option<T> {
  final T value;

  const Some(this.value);

  @override
  T? get valueOrNull => value;

  @override
  bool get isSome => true;

  @override
  bool get isNone => false;

  @override
  R fold<R>(R Function() onNone, R Function(T) onSome) => onSome(value);

  @override
  Option<R> map<R>(R Function(T) mapper) => Some(mapper(value));

  @override
  Option<R> flatMap<R>(Option<R> Function(T) mapper) => mapper(value);

  @override
  T getOrElse(T Function() orElse) => value;

  @override
  Either<L, T> toEither<L>(L Function() onNone) => Right<L, T>(value);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is Some<T> && other.value == value);

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() => 'Some($value)';
}

// ========================================================================
// None Variant
// ========================================================================

/// The [None] variant of [Option], representing an absent value.
final class None<T> extends Option<T> {
  const None();

  @override
  T? get valueOrNull => null;

  @override
  bool get isSome => false;

  @override
  bool get isNone => true;

  @override
  R fold<R>(R Function() onNone, R Function(T) onSome) => onNone();

  @override
  Option<R> map<R>(R Function(T) mapper) => None<R>();

  @override
  Option<R> flatMap<R>(Option<R> Function(T) mapper) => None<R>();

  @override
  T getOrElse(T Function() orElse) => orElse();

  @override
  Either<L, T> toEither<L>(L Function() onNone) => Left<L, T>(onNone());

  @override
  bool operator ==(Object other) => other is None<T>;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'None()';
}

// ========================================================================
// Either Utilities
// ========================================================================

/// Utility functions for working with [Either].
abstract final class EitherUtils {
  /// Combines a list of [Either] values into a single [Either] of a list.
  ///
  /// Returns the first [Left] encountered, or a [Right] containing all [Right] values.
  ///
  /// Example:
  /// ```dart
  /// final results = EitherUtils.sequence([
  ///   Right(1),
  ///   Right(2),
  ///   Right(3),
  /// ]); // Right([1, 2, 3])
  /// ```
  static Either<L, List<R>> sequence<L, R>(List<Either<L, R>> eithers) {
    final results = <R>[];
    for (final either in eithers) {
      switch (either) {
        case Left(value: final l):
          return Left<L, List<R>>(l);
        case Right(value: final r):
          results.add(r);
      }
    }
    return Right<L, List<R>>(results);
  }

  /// Maps each element of [list] to an [Either] and combines the results.
  static Either<L, List<R>> traverse<L, R, T>(List<T> list, Either<L, R> Function(T) f) =>
      sequence(list.map(f).toList());

  /// Finds the first [Right] in a list of [Either] values.
  ///
  /// Returns a [Right] with the first successful value, or a [Left] containing
  /// all accumulated [Left] values if no [Right] is found.
  static Either<List<L>, R> firstRight<L, R>(List<Either<L, R>> eithers) {
    final lefts = <L>[];
    for (final either in eithers) {
      switch (either) {
        case Left(value: final l):
          lefts.add(l);
        case Right(value: final r):
          return Right<List<L>, R>(r);
      }
    }
    return Left<List<L>, R>(lefts);
  }
}

// ========================================================================
// Either Extensions
// ========================================================================

/// Extension methods for [Either] to enable more fluent APIs.
extension EitherExtensions<L, R> on Either<L, R> {
  /// Gets the [Right] value or computes a default value.
  R getOrElse(R Function() orElse) => fold((_) => orElse(), (r) => r);

  /// Gets the [Right] value or returns the provided default value.
  R getOrDefault(R defaultValue) => fold((_) => defaultValue, (r) => r);

  /// Swaps the [Left] and [Right] types.
  Either<R, L> swap() => fold((l) => Right<R, L>(l), (r) => Left<R, L>(r));

  /// Converts to [Option<R>] (None if Left).
  Option<R> toOption() => fold((_) => None(), (r) => Some(r));

  /// Converts to [Option<L>] (None if Right).
  Option<L> toLeftOption() => fold((l) => Some(l), (_) => None());

  /// Executes a side effect for the [Right] value and returns the original [Either].
  Either<L, R> tap(void Function(R) action) => onRight(action);

  /// Executes a side effect for the [Left] value and returns the original [Either].
  Either<L, R> tapLeft(void Function(L) action) => onLeft(action);
}

// ========================================================================
// Either Future Extensions
// ========================================================================

/// Extension methods for [Either] with [Future] as the [Right] type.
extension EitherFutureExtensions<L, R> on Either<L, Future<R>> {
  /// Flattens a nested [Either<L, Future<R>>] into a [Future<Either<L, R>>].
  Future<Either<L, R>> flatten() => switch (this) {
    Left(value: final l) => Future.value(Left<L, R>(l)),
    Right(value: final future) => future.then((r) => Right<L, R>(r)),
  };
}

// ========================================================================
// Future Either Extensions
// ========================================================================

/// Extension methods for [Future<Either>].
extension FutureEitherExtensions<L, R> on Future<Either<L, R>> {
  /// Maps the [Right] value asynchronously.
  Future<Either<L, R2>> mapAsync<R2>(Future<R2> Function(R) mapper) => then(
    (either) => either.fold(
      (l) => Future.value(Left<L, R2>(l)),
      (r) => mapper(r).then((r2) => Right<L, R2>(r2)),
    ),
  );

  /// Flat-maps the [Right] value asynchronously to a new [Either].
  Future<Either<L, R2>> flatMapAsync<R2>(Future<Either<L, R2>> Function(R) mapper) =>
      then((either) => either.fold((l) => Future.value(Left<L, R2>(l)), (r) => mapper(r)));

  /// Gets the [Right] value or computes a default asynchronously.
  Future<R> getOrElseAsync(Future<R> Function() orElse) =>
      then((either) => either.fold((_) => orElse(), (r) => Future.value(r)));
}
