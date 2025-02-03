// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ville_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VilleCollection _$VilleCollectionFromJson(Map<String, dynamic> json) {
  return _VilleCollection.fromJson(json);
}

/// @nodoc
mixin _$VilleCollection {
  List<VilleModel>? get data => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  bool get hasNext => throw _privateConstructorUsedError;
  bool get hasPrevious => throw _privateConstructorUsedError;

  /// Serializes this VilleCollection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VilleCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VilleCollectionCopyWith<VilleCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VilleCollectionCopyWith<$Res> {
  factory $VilleCollectionCopyWith(
          VilleCollection value, $Res Function(VilleCollection) then) =
      _$VilleCollectionCopyWithImpl<$Res, VilleCollection>;
  @useResult
  $Res call(
      {List<VilleModel>? data,
      int currentPage,
      int totalPages,
      int pageSize,
      int totalCount,
      bool hasNext,
      bool hasPrevious});
}

/// @nodoc
class _$VilleCollectionCopyWithImpl<$Res, $Val extends VilleCollection>
    implements $VilleCollectionCopyWith<$Res> {
  _$VilleCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VilleCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? pageSize = null,
    Object? totalCount = null,
    Object? hasNext = null,
    Object? hasPrevious = null,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<VilleModel>?,
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
abstract class _$$VilleCollectionImplCopyWith<$Res>
    implements $VilleCollectionCopyWith<$Res> {
  factory _$$VilleCollectionImplCopyWith(_$VilleCollectionImpl value,
          $Res Function(_$VilleCollectionImpl) then) =
      __$$VilleCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<VilleModel>? data,
      int currentPage,
      int totalPages,
      int pageSize,
      int totalCount,
      bool hasNext,
      bool hasPrevious});
}

/// @nodoc
class __$$VilleCollectionImplCopyWithImpl<$Res>
    extends _$VilleCollectionCopyWithImpl<$Res, _$VilleCollectionImpl>
    implements _$$VilleCollectionImplCopyWith<$Res> {
  __$$VilleCollectionImplCopyWithImpl(
      _$VilleCollectionImpl _value, $Res Function(_$VilleCollectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of VilleCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? pageSize = null,
    Object? totalCount = null,
    Object? hasNext = null,
    Object? hasPrevious = null,
  }) {
    return _then(_$VilleCollectionImpl(
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<VilleModel>?,
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
class _$VilleCollectionImpl implements _VilleCollection {
  _$VilleCollectionImpl(
      {final List<VilleModel>? data = const [],
      this.currentPage = 1,
      this.totalPages = 1,
      this.pageSize = 10,
      this.totalCount = 0,
      this.hasNext = false,
      this.hasPrevious = false})
      : _data = data;

  factory _$VilleCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$VilleCollectionImplFromJson(json);

  final List<VilleModel>? _data;
  @override
  @JsonKey()
  List<VilleModel>? get data {
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
  final bool hasNext;
  @override
  @JsonKey()
  final bool hasPrevious;

  @override
  String toString() {
    return 'VilleCollection(data: $data, currentPage: $currentPage, totalPages: $totalPages, pageSize: $pageSize, totalCount: $totalCount, hasNext: $hasNext, hasPrevious: $hasPrevious)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VilleCollectionImpl &&
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

  /// Create a copy of VilleCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VilleCollectionImplCopyWith<_$VilleCollectionImpl> get copyWith =>
      __$$VilleCollectionImplCopyWithImpl<_$VilleCollectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VilleCollectionImplToJson(
      this,
    );
  }
}

abstract class _VilleCollection implements VilleCollection {
  factory _VilleCollection(
      {final List<VilleModel>? data,
      final int currentPage,
      final int totalPages,
      final int pageSize,
      final int totalCount,
      final bool hasNext,
      final bool hasPrevious}) = _$VilleCollectionImpl;

  factory _VilleCollection.fromJson(Map<String, dynamic> json) =
      _$VilleCollectionImpl.fromJson;

  @override
  List<VilleModel>? get data;
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

  /// Create a copy of VilleCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VilleCollectionImplCopyWith<_$VilleCollectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
