// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'demande_visite_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DemandeVisiteCollection _$DemandeVisiteCollectionFromJson(
    Map<String, dynamic> json) {
  return _DemandeVisiteCollection.fromJson(json);
}

/// @nodoc
mixin _$DemandeVisiteCollection {
  List<DemandeVisiteModel>? get data => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  bool get hasPrevious => throw _privateConstructorUsedError;
  bool get hasNext => throw _privateConstructorUsedError;

  /// Serializes this DemandeVisiteCollection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DemandeVisiteCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DemandeVisiteCollectionCopyWith<DemandeVisiteCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DemandeVisiteCollectionCopyWith<$Res> {
  factory $DemandeVisiteCollectionCopyWith(DemandeVisiteCollection value,
          $Res Function(DemandeVisiteCollection) then) =
      _$DemandeVisiteCollectionCopyWithImpl<$Res, DemandeVisiteCollection>;
  @useResult
  $Res call(
      {List<DemandeVisiteModel>? data,
      int currentPage,
      int totalPages,
      int pageSize,
      int totalCount,
      bool hasPrevious,
      bool hasNext});
}

/// @nodoc
class _$DemandeVisiteCollectionCopyWithImpl<$Res,
        $Val extends DemandeVisiteCollection>
    implements $DemandeVisiteCollectionCopyWith<$Res> {
  _$DemandeVisiteCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DemandeVisiteCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? pageSize = null,
    Object? totalCount = null,
    Object? hasPrevious = null,
    Object? hasNext = null,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<DemandeVisiteModel>?,
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
      hasPrevious: null == hasPrevious
          ? _value.hasPrevious
          : hasPrevious // ignore: cast_nullable_to_non_nullable
              as bool,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DemandeVisiteCollectionImplCopyWith<$Res>
    implements $DemandeVisiteCollectionCopyWith<$Res> {
  factory _$$DemandeVisiteCollectionImplCopyWith(
          _$DemandeVisiteCollectionImpl value,
          $Res Function(_$DemandeVisiteCollectionImpl) then) =
      __$$DemandeVisiteCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<DemandeVisiteModel>? data,
      int currentPage,
      int totalPages,
      int pageSize,
      int totalCount,
      bool hasPrevious,
      bool hasNext});
}

/// @nodoc
class __$$DemandeVisiteCollectionImplCopyWithImpl<$Res>
    extends _$DemandeVisiteCollectionCopyWithImpl<$Res,
        _$DemandeVisiteCollectionImpl>
    implements _$$DemandeVisiteCollectionImplCopyWith<$Res> {
  __$$DemandeVisiteCollectionImplCopyWithImpl(
      _$DemandeVisiteCollectionImpl _value,
      $Res Function(_$DemandeVisiteCollectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DemandeVisiteCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? pageSize = null,
    Object? totalCount = null,
    Object? hasPrevious = null,
    Object? hasNext = null,
  }) {
    return _then(_$DemandeVisiteCollectionImpl(
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<DemandeVisiteModel>?,
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
      hasPrevious: null == hasPrevious
          ? _value.hasPrevious
          : hasPrevious // ignore: cast_nullable_to_non_nullable
              as bool,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DemandeVisiteCollectionImpl implements _DemandeVisiteCollection {
  _$DemandeVisiteCollectionImpl(
      {final List<DemandeVisiteModel>? data = const [],
      this.currentPage = 0,
      this.totalPages = 0,
      this.pageSize = 0,
      this.totalCount = 0,
      this.hasPrevious = false,
      this.hasNext = false})
      : _data = data;

  factory _$DemandeVisiteCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DemandeVisiteCollectionImplFromJson(json);

  final List<DemandeVisiteModel>? _data;
  @override
  @JsonKey()
  List<DemandeVisiteModel>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
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
  final bool hasPrevious;
  @override
  @JsonKey()
  final bool hasNext;

  @override
  String toString() {
    return 'DemandeVisiteCollection(data: $data, currentPage: $currentPage, totalPages: $totalPages, pageSize: $pageSize, totalCount: $totalCount, hasPrevious: $hasPrevious, hasNext: $hasNext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DemandeVisiteCollectionImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.hasPrevious, hasPrevious) ||
                other.hasPrevious == hasPrevious) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext));
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
      hasPrevious,
      hasNext);

  /// Create a copy of DemandeVisiteCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DemandeVisiteCollectionImplCopyWith<_$DemandeVisiteCollectionImpl>
      get copyWith => __$$DemandeVisiteCollectionImplCopyWithImpl<
          _$DemandeVisiteCollectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DemandeVisiteCollectionImplToJson(
      this,
    );
  }
}

abstract class _DemandeVisiteCollection implements DemandeVisiteCollection {
  factory _DemandeVisiteCollection(
      {final List<DemandeVisiteModel>? data,
      final int currentPage,
      final int totalPages,
      final int pageSize,
      final int totalCount,
      final bool hasPrevious,
      final bool hasNext}) = _$DemandeVisiteCollectionImpl;

  factory _DemandeVisiteCollection.fromJson(Map<String, dynamic> json) =
      _$DemandeVisiteCollectionImpl.fromJson;

  @override
  List<DemandeVisiteModel>? get data;
  @override
  int get currentPage;
  @override
  int get totalPages;
  @override
  int get pageSize;
  @override
  int get totalCount;
  @override
  bool get hasPrevious;
  @override
  bool get hasNext;

  /// Create a copy of DemandeVisiteCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DemandeVisiteCollectionImplCopyWith<_$DemandeVisiteCollectionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
