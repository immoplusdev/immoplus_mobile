// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'residences_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResidencesCollection _$ResidencesCollectionFromJson(Map<String, dynamic> json) {
  return _ResidencesCollection.fromJson(json);
}

/// @nodoc
mixin _$ResidencesCollection {
  List<ResidenceModel>? get data => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toInt)
  int? get currentPage => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toInt)
  int? get totalPages => throw _privateConstructorUsedError;
  @JsonKey(fromJson: toInt)
  int? get pageSize => throw _privateConstructorUsedError;
  bool? get hasNext => throw _privateConstructorUsedError;
  bool? get hasPrevious => throw _privateConstructorUsedError;

  /// Serializes this ResidencesCollection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResidencesCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResidencesCollectionCopyWith<ResidencesCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResidencesCollectionCopyWith<$Res> {
  factory $ResidencesCollectionCopyWith(ResidencesCollection value,
          $Res Function(ResidencesCollection) then) =
      _$ResidencesCollectionCopyWithImpl<$Res, ResidencesCollection>;
  @useResult
  $Res call(
      {List<ResidenceModel>? data,
      @JsonKey(fromJson: toInt) int? currentPage,
      @JsonKey(fromJson: toInt) int? totalPages,
      @JsonKey(fromJson: toInt) int? pageSize,
      bool? hasNext,
      bool? hasPrevious});
}

/// @nodoc
class _$ResidencesCollectionCopyWithImpl<$Res,
        $Val extends ResidencesCollection>
    implements $ResidencesCollectionCopyWith<$Res> {
  _$ResidencesCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResidencesCollection
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
              as List<ResidenceModel>?,
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
abstract class _$$ResidencesCollectionImplCopyWith<$Res>
    implements $ResidencesCollectionCopyWith<$Res> {
  factory _$$ResidencesCollectionImplCopyWith(_$ResidencesCollectionImpl value,
          $Res Function(_$ResidencesCollectionImpl) then) =
      __$$ResidencesCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ResidenceModel>? data,
      @JsonKey(fromJson: toInt) int? currentPage,
      @JsonKey(fromJson: toInt) int? totalPages,
      @JsonKey(fromJson: toInt) int? pageSize,
      bool? hasNext,
      bool? hasPrevious});
}

/// @nodoc
class __$$ResidencesCollectionImplCopyWithImpl<$Res>
    extends _$ResidencesCollectionCopyWithImpl<$Res, _$ResidencesCollectionImpl>
    implements _$$ResidencesCollectionImplCopyWith<$Res> {
  __$$ResidencesCollectionImplCopyWithImpl(_$ResidencesCollectionImpl _value,
      $Res Function(_$ResidencesCollectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResidencesCollection
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
    return _then(_$ResidencesCollectionImpl(
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ResidenceModel>?,
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
class _$ResidencesCollectionImpl implements _ResidencesCollection {
  _$ResidencesCollectionImpl(
      {final List<ResidenceModel>? data = const [],
      @JsonKey(fromJson: toInt) this.currentPage,
      @JsonKey(fromJson: toInt) this.totalPages,
      @JsonKey(fromJson: toInt) this.pageSize,
      this.hasNext = false,
      this.hasPrevious = false})
      : _data = data;

  factory _$ResidencesCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResidencesCollectionImplFromJson(json);

  final List<ResidenceModel>? _data;
  @override
  @JsonKey()
  List<ResidenceModel>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(fromJson: toInt)
  final int? currentPage;
  @override
  @JsonKey(fromJson: toInt)
  final int? totalPages;
  @override
  @JsonKey(fromJson: toInt)
  final int? pageSize;
  @override
  @JsonKey()
  final bool? hasNext;
  @override
  @JsonKey()
  final bool? hasPrevious;

  @override
  String toString() {
    return 'ResidencesCollection(data: $data, currentPage: $currentPage, totalPages: $totalPages, pageSize: $pageSize, hasNext: $hasNext, hasPrevious: $hasPrevious)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResidencesCollectionImpl &&
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

  /// Create a copy of ResidencesCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResidencesCollectionImplCopyWith<_$ResidencesCollectionImpl>
      get copyWith =>
          __$$ResidencesCollectionImplCopyWithImpl<_$ResidencesCollectionImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResidencesCollectionImplToJson(
      this,
    );
  }
}

abstract class _ResidencesCollection implements ResidencesCollection {
  factory _ResidencesCollection(
      {final List<ResidenceModel>? data,
      @JsonKey(fromJson: toInt) final int? currentPage,
      @JsonKey(fromJson: toInt) final int? totalPages,
      @JsonKey(fromJson: toInt) final int? pageSize,
      final bool? hasNext,
      final bool? hasPrevious}) = _$ResidencesCollectionImpl;

  factory _ResidencesCollection.fromJson(Map<String, dynamic> json) =
      _$ResidencesCollectionImpl.fromJson;

  @override
  List<ResidenceModel>? get data;
  @override
  @JsonKey(fromJson: toInt)
  int? get currentPage;
  @override
  @JsonKey(fromJson: toInt)
  int? get totalPages;
  @override
  @JsonKey(fromJson: toInt)
  int? get pageSize;
  @override
  bool? get hasNext;
  @override
  bool? get hasPrevious;

  /// Create a copy of ResidencesCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResidencesCollectionImplCopyWith<_$ResidencesCollectionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
