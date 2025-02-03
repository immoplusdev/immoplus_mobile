// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservations_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReservationsCollection _$ReservationsCollectionFromJson(
    Map<String, dynamic> json) {
  return _ReservationsCollection.fromJson(json);
}

/// @nodoc
mixin _$ReservationsCollection {
  List<ReservationModel> get data => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  bool get hasNext => throw _privateConstructorUsedError;
  bool get hasPrevious => throw _privateConstructorUsedError;

  /// Serializes this ReservationsCollection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReservationsCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationsCollectionCopyWith<ReservationsCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationsCollectionCopyWith<$Res> {
  factory $ReservationsCollectionCopyWith(ReservationsCollection value,
          $Res Function(ReservationsCollection) then) =
      _$ReservationsCollectionCopyWithImpl<$Res, ReservationsCollection>;
  @useResult
  $Res call(
      {List<ReservationModel> data,
      int currentPage,
      int totalPages,
      int pageSize,
      int totalCount,
      bool hasNext,
      bool hasPrevious});
}

/// @nodoc
class _$ReservationsCollectionCopyWithImpl<$Res,
        $Val extends ReservationsCollection>
    implements $ReservationsCollectionCopyWith<$Res> {
  _$ReservationsCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservationsCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? pageSize = null,
    Object? totalCount = null,
    Object? hasNext = null,
    Object? hasPrevious = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ReservationModel>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrevious: null == hasPrevious
          ? _value.hasPrevious
          : hasPrevious // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReservationsCollectionImplCopyWith<$Res>
    implements $ReservationsCollectionCopyWith<$Res> {
  factory _$$ReservationsCollectionImplCopyWith(
          _$ReservationsCollectionImpl value,
          $Res Function(_$ReservationsCollectionImpl) then) =
      __$$ReservationsCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ReservationModel> data,
      int currentPage,
      int totalPages,
      int pageSize,
      int totalCount,
      bool hasNext,
      bool hasPrevious});
}

/// @nodoc
class __$$ReservationsCollectionImplCopyWithImpl<$Res>
    extends _$ReservationsCollectionCopyWithImpl<$Res,
        _$ReservationsCollectionImpl>
    implements _$$ReservationsCollectionImplCopyWith<$Res> {
  __$$ReservationsCollectionImplCopyWithImpl(
      _$ReservationsCollectionImpl _value,
      $Res Function(_$ReservationsCollectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReservationsCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? pageSize = null,
    Object? totalCount = null,
    Object? hasNext = null,
    Object? hasPrevious = null,
  }) {
    return _then(_$ReservationsCollectionImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ReservationModel>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrevious: null == hasPrevious
          ? _value.hasPrevious
          : hasPrevious // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationsCollectionImpl implements _ReservationsCollection {
  _$ReservationsCollectionImpl(
      {final List<ReservationModel> data = const [],
      this.currentPage = 1,
      this.totalPages = 1,
      this.pageSize = 10,
      this.totalCount = 0,
      this.hasNext = false,
      this.hasPrevious = false})
      : _data = data;

  factory _$ReservationsCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationsCollectionImplFromJson(json);

  final List<ReservationModel> _data;
  @override
  @JsonKey()
  List<ReservationModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final int totalPages;
  @override
  @JsonKey()
  final int pageSize;
  @override
  @JsonKey()
  final int totalCount;
  @override
  @JsonKey()
  final bool hasNext;
  @override
  @JsonKey()
  final bool hasPrevious;

  @override
  String toString() {
    return 'ReservationsCollection(data: $data, currentPage: $currentPage, totalPages: $totalPages, pageSize: $pageSize, totalCount: $totalCount, hasNext: $hasNext, hasPrevious: $hasPrevious)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationsCollectionImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
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
      totalCount,
      hasNext,
      hasPrevious);

  /// Create a copy of ReservationsCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationsCollectionImplCopyWith<_$ReservationsCollectionImpl>
      get copyWith => __$$ReservationsCollectionImplCopyWithImpl<
          _$ReservationsCollectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationsCollectionImplToJson(
      this,
    );
  }
}

abstract class _ReservationsCollection implements ReservationsCollection {
  factory _ReservationsCollection(
      {final List<ReservationModel> data,
      final int currentPage,
      final int totalPages,
      final int pageSize,
      final int totalCount,
      final bool hasNext,
      final bool hasPrevious}) = _$ReservationsCollectionImpl;

  factory _ReservationsCollection.fromJson(Map<String, dynamic> json) =
      _$ReservationsCollectionImpl.fromJson;

  @override
  List<ReservationModel> get data;
  @override
  int get currentPage;
  @override
  int get totalPages;
  @override
  int get pageSize;
  @override
  int get totalCount;
  @override
  bool get hasNext;
  @override
  bool get hasPrevious;

  /// Create a copy of ReservationsCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationsCollectionImplCopyWith<_$ReservationsCollectionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
