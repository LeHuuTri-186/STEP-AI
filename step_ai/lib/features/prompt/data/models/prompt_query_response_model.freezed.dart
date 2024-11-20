// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prompt_query_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PromptQueryResponse _$PromptQueryResponseFromJson(Map<String, dynamic> json) {
  return _PromptQueryResponse.fromJson(json);
}

/// @nodoc
mixin _$PromptQueryResponse {
  @JsonKey(name: "hasNext")
  bool get hasNext => throw _privateConstructorUsedError;
  @JsonKey(name: "items")
  List<PromptModel> get items => throw _privateConstructorUsedError;
  @JsonKey(name: "limit")
  int get limit => throw _privateConstructorUsedError;
  @JsonKey(name: "offset")
  int get offset => throw _privateConstructorUsedError;
  @JsonKey(name: "total")
  int get total => throw _privateConstructorUsedError;

  /// Serializes this PromptQueryResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PromptQueryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PromptQueryResponseCopyWith<PromptQueryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromptQueryResponseCopyWith<$Res> {
  factory $PromptQueryResponseCopyWith(
          PromptQueryResponse value, $Res Function(PromptQueryResponse) then) =
      _$PromptQueryResponseCopyWithImpl<$Res, PromptQueryResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: "hasNext") bool hasNext,
      @JsonKey(name: "items") List<PromptModel> items,
      @JsonKey(name: "limit") int limit,
      @JsonKey(name: "offset") int offset,
      @JsonKey(name: "total") int total});
}

/// @nodoc
class _$PromptQueryResponseCopyWithImpl<$Res, $Val extends PromptQueryResponse>
    implements $PromptQueryResponseCopyWith<$Res> {
  _$PromptQueryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PromptQueryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasNext = null,
    Object? items = null,
    Object? limit = null,
    Object? offset = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PromptModel>,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PromptQueryResponseImplCopyWith<$Res>
    implements $PromptQueryResponseCopyWith<$Res> {
  factory _$$PromptQueryResponseImplCopyWith(_$PromptQueryResponseImpl value,
          $Res Function(_$PromptQueryResponseImpl) then) =
      __$$PromptQueryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "hasNext") bool hasNext,
      @JsonKey(name: "items") List<PromptModel> items,
      @JsonKey(name: "limit") int limit,
      @JsonKey(name: "offset") int offset,
      @JsonKey(name: "total") int total});
}

/// @nodoc
class __$$PromptQueryResponseImplCopyWithImpl<$Res>
    extends _$PromptQueryResponseCopyWithImpl<$Res, _$PromptQueryResponseImpl>
    implements _$$PromptQueryResponseImplCopyWith<$Res> {
  __$$PromptQueryResponseImplCopyWithImpl(_$PromptQueryResponseImpl _value,
      $Res Function(_$PromptQueryResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PromptQueryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasNext = null,
    Object? items = null,
    Object? limit = null,
    Object? offset = null,
    Object? total = null,
  }) {
    return _then(_$PromptQueryResponseImpl(
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PromptModel>,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PromptQueryResponseImpl implements _PromptQueryResponse {
  const _$PromptQueryResponseImpl(
      {@JsonKey(name: "hasNext") required this.hasNext,
      @JsonKey(name: "items") required final List<PromptModel> items,
      @JsonKey(name: "limit") required this.limit,
      @JsonKey(name: "offset") required this.offset,
      @JsonKey(name: "total") required this.total})
      : _items = items;

  factory _$PromptQueryResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromptQueryResponseImplFromJson(json);

  @override
  @JsonKey(name: "hasNext")
  final bool hasNext;
  final List<PromptModel> _items;
  @override
  @JsonKey(name: "items")
  List<PromptModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(name: "limit")
  final int limit;
  @override
  @JsonKey(name: "offset")
  final int offset;
  @override
  @JsonKey(name: "total")
  final int total;

  @override
  String toString() {
    return 'PromptQueryResponse(hasNext: $hasNext, items: $items, limit: $limit, offset: $offset, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromptQueryResponseImpl &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hasNext,
      const DeepCollectionEquality().hash(_items), limit, offset, total);

  /// Create a copy of PromptQueryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PromptQueryResponseImplCopyWith<_$PromptQueryResponseImpl> get copyWith =>
      __$$PromptQueryResponseImplCopyWithImpl<_$PromptQueryResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromptQueryResponseImplToJson(
      this,
    );
  }
}

abstract class _PromptQueryResponse implements PromptQueryResponse {
  const factory _PromptQueryResponse(
          {@JsonKey(name: "hasNext") required final bool hasNext,
          @JsonKey(name: "items") required final List<PromptModel> items,
          @JsonKey(name: "limit") required final int limit,
          @JsonKey(name: "offset") required final int offset,
          @JsonKey(name: "total") required final int total}) =
      _$PromptQueryResponseImpl;

  factory _PromptQueryResponse.fromJson(Map<String, dynamic> json) =
      _$PromptQueryResponseImpl.fromJson;

  @override
  @JsonKey(name: "hasNext")
  bool get hasNext;
  @override
  @JsonKey(name: "items")
  List<PromptModel> get items;
  @override
  @JsonKey(name: "limit")
  int get limit;
  @override
  @JsonKey(name: "offset")
  int get offset;
  @override
  @JsonKey(name: "total")
  int get total;

  /// Create a copy of PromptQueryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PromptQueryResponseImplCopyWith<_$PromptQueryResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
