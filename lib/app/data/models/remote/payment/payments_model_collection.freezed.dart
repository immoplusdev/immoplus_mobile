// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payments_model_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentsModelCollection _$PaymentsModelCollectionFromJson(
    Map<String, dynamic> json) {
  return _PaymentsModelCollection.fromJson(json);
}

/// @nodoc
mixin _$PaymentsModelCollection {
  List<PaymentItentData>? get data => throw _privateConstructorUsedError;
  int? get currentPage => throw _privateConstructorUsedError;
  int? get totalPages => throw _privateConstructorUsedError;
  int? get pageSize => throw _privateConstructorUsedError;
  bool? get hasNext => throw _privateConstructorUsedError;
  bool? get hasPrevious => throw _privateConstructorUsedError;

  /// Serializes this PaymentsModelCollection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentsModelCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentsModelCollectionCopyWith<PaymentsModelCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentsModelCollectionCopyWith<$Res> {
  factory $PaymentsModelCollectionCopyWith(PaymentsModelCollection value,
          $Res Function(PaymentsModelCollection) then) =
      _$PaymentsModelCollectionCopyWithImpl<$Res, PaymentsModelCollection>;
  @useResult
  $Res call(
      {List<PaymentItentData>? data,
      int? currentPage,
      int? totalPages,
      int? pageSize,
      bool? hasNext,
      bool? hasPrevious});
}

/// @nodoc
class _$PaymentsModelCollectionCopyWithImpl<$Res,
        $Val extends PaymentsModelCollection>
    implements $PaymentsModelCollectionCopyWith<$Res> {
  _$PaymentsModelCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentsModelCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? currentPage = freezed,
    Object? totalPages = freezed,
    Object? pageSize = freezed,
    Object? hasNext = freezed,
    Object? hasPrevious = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PaymentItentData>?,
      currentPage: freezed == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: freezed == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int?,
      hasNext: freezed == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasPrevious: freezed == hasPrevious
          ? _value.hasPrevious
          : hasPrevious // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentsModelCollectionImplCopyWith<$Res>
    implements $PaymentsModelCollectionCopyWith<$Res> {
  factory _$$PaymentsModelCollectionImplCopyWith(
          _$PaymentsModelCollectionImpl value,
          $Res Function(_$PaymentsModelCollectionImpl) then) =
      __$$PaymentsModelCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PaymentItentData>? data,
      int? currentPage,
      int? totalPages,
      int? pageSize,
      bool? hasNext,
      bool? hasPrevious});
}

/// @nodoc
class __$$PaymentsModelCollectionImplCopyWithImpl<$Res>
    extends _$PaymentsModelCollectionCopyWithImpl<$Res,
        _$PaymentsModelCollectionImpl>
    implements _$$PaymentsModelCollectionImplCopyWith<$Res> {
  __$$PaymentsModelCollectionImplCopyWithImpl(
      _$PaymentsModelCollectionImpl _value,
      $Res Function(_$PaymentsModelCollectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentsModelCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? currentPage = freezed,
    Object? totalPages = freezed,
    Object? pageSize = freezed,
    Object? hasNext = freezed,
    Object? hasPrevious = freezed,
  }) {
    return _then(_$PaymentsModelCollectionImpl(
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PaymentItentData>?,
      currentPage: freezed == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: freezed == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int?,
      hasNext: freezed == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasPrevious: freezed == hasPrevious
          ? _value.hasPrevious
          : hasPrevious // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentsModelCollectionImpl implements _PaymentsModelCollection {
  _$PaymentsModelCollectionImpl(
      {final List<PaymentItentData>? data = const [],
      this.currentPage = 0,
      this.totalPages = 0,
      this.pageSize = 0,
      this.hasNext = false,
      this.hasPrevious = false})
      : _data = data;

  factory _$PaymentsModelCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentsModelCollectionImplFromJson(json);

  final List<PaymentItentData>? _data;
  @override
  @JsonKey()
  List<PaymentItentData>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final int? currentPage;
  @override
  @JsonKey()
  final int? totalPages;
  @override
  @JsonKey()
  final int? pageSize;
  @override
  @JsonKey()
  final bool? hasNext;
  @override
  @JsonKey()
  final bool? hasPrevious;

  @override
  String toString() {
    return 'PaymentsModelCollection(data: $data, currentPage: $currentPage, totalPages: $totalPages, pageSize: $pageSize, hasNext: $hasNext, hasPrevious: $hasPrevious)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentsModelCollectionImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            (identical(other.hasPrevious, hasPrevious) ||
                other.hasPrevious == hasPrevious));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_data),
      currentPage,
      totalPages,
      pageSize,
      hasNext,
      hasPrevious);

  /// Create a copy of PaymentsModelCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentsModelCollectionImplCopyWith<_$PaymentsModelCollectionImpl>
      get copyWith => __$$PaymentsModelCollectionImplCopyWithImpl<
          _$PaymentsModelCollectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentsModelCollectionImplToJson(
      this,
    );
  }
}

abstract class _PaymentsModelCollection implements PaymentsModelCollection {
  factory _PaymentsModelCollection(
      {final List<PaymentItentData>? data,
      final int? currentPage,
      final int? totalPages,
      final int? pageSize,
      final bool? hasNext,
      final bool? hasPrevious}) = _$PaymentsModelCollectionImpl;

  factory _PaymentsModelCollection.fromJson(Map<String, dynamic> json) =
      _$PaymentsModelCollectionImpl.fromJson;

  @override
  List<PaymentItentData>? get data;
  @override
  int? get currentPage;
  @override
  int? get totalPages;
  @override
  int? get pageSize;
  @override
  bool? get hasNext;
  @override
  bool? get hasPrevious;

  /// Create a copy of PaymentsModelCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentsModelCollectionImplCopyWith<_$PaymentsModelCollectionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
