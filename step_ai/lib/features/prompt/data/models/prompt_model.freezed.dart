// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prompt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PromptModel _$PromptModelFromJson(Map<String, dynamic> json) {
  return _PromptModel.fromJson(json);
}

/// @nodoc
mixin _$PromptModel {
  @JsonKey(name: "_id")
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: "category")
  String get category => throw _privateConstructorUsedError;
  @JsonKey(name: "content")
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: "createdAt")
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: "description")
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: "isFavorite")
  bool get isFavorite => throw _privateConstructorUsedError;
  @JsonKey(name: "isPublic")
  bool get isPublic => throw _privateConstructorUsedError;
  @JsonKey(name: "language")
  String? get language => throw _privateConstructorUsedError;
  @JsonKey(name: "title")
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: "updatedAt")
  String? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: "userId")
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: "userName")
  String get userName => throw _privateConstructorUsedError;

  /// Serializes this PromptModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PromptModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PromptModelCopyWith<PromptModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromptModelCopyWith<$Res> {
  factory $PromptModelCopyWith(
          PromptModel value, $Res Function(PromptModel) then) =
      _$PromptModelCopyWithImpl<$Res, PromptModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "_id") String id,
      @JsonKey(name: "category") String category,
      @JsonKey(name: "content") String content,
      @JsonKey(name: "createdAt") String createdAt,
      @JsonKey(name: "description") String description,
      @JsonKey(name: "isFavorite") bool isFavorite,
      @JsonKey(name: "isPublic") bool isPublic,
      @JsonKey(name: "language") String? language,
      @JsonKey(name: "title") String title,
      @JsonKey(name: "updatedAt") String? updatedAt,
      @JsonKey(name: "userId") String? userId,
      @JsonKey(name: "userName") String userName});
}

/// @nodoc
class _$PromptModelCopyWithImpl<$Res, $Val extends PromptModel>
    implements $PromptModelCopyWith<$Res> {
  _$PromptModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PromptModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? content = null,
    Object? createdAt = null,
    Object? description = null,
    Object? isFavorite = null,
    Object? isPublic = null,
    Object? language = freezed,
    Object? title = null,
    Object? updatedAt = freezed,
    Object? userId = freezed,
    Object? userName = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PromptModelImplCopyWith<$Res>
    implements $PromptModelCopyWith<$Res> {
  factory _$$PromptModelImplCopyWith(
          _$PromptModelImpl value, $Res Function(_$PromptModelImpl) then) =
      __$$PromptModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "_id") String id,
      @JsonKey(name: "category") String category,
      @JsonKey(name: "content") String content,
      @JsonKey(name: "createdAt") String createdAt,
      @JsonKey(name: "description") String description,
      @JsonKey(name: "isFavorite") bool isFavorite,
      @JsonKey(name: "isPublic") bool isPublic,
      @JsonKey(name: "language") String? language,
      @JsonKey(name: "title") String title,
      @JsonKey(name: "updatedAt") String? updatedAt,
      @JsonKey(name: "userId") String? userId,
      @JsonKey(name: "userName") String userName});
}

/// @nodoc
class __$$PromptModelImplCopyWithImpl<$Res>
    extends _$PromptModelCopyWithImpl<$Res, _$PromptModelImpl>
    implements _$$PromptModelImplCopyWith<$Res> {
  __$$PromptModelImplCopyWithImpl(
      _$PromptModelImpl _value, $Res Function(_$PromptModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PromptModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? content = null,
    Object? createdAt = null,
    Object? description = null,
    Object? isFavorite = null,
    Object? isPublic = null,
    Object? language = freezed,
    Object? title = null,
    Object? updatedAt = freezed,
    Object? userId = freezed,
    Object? userName = null,
  }) {
    return _then(_$PromptModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PromptModelImpl implements _PromptModel {
  const _$PromptModelImpl(
      {@JsonKey(name: "_id") this.id = '',
      @JsonKey(name: "category") required this.category,
      @JsonKey(name: "content") required this.content,
      @JsonKey(name: "createdAt") this.createdAt = '',
      @JsonKey(name: "description") this.description = '',
      @JsonKey(name: "isFavorite") required this.isFavorite,
      @JsonKey(name: "isPublic") required this.isPublic,
      @JsonKey(name: "language") this.language = '',
      @JsonKey(name: "title") required this.title,
      @JsonKey(name: "updatedAt") this.updatedAt = '',
      @JsonKey(name: "userId") this.userId,
      @JsonKey(name: "userName") required this.userName});

  factory _$PromptModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromptModelImplFromJson(json);

  @override
  @JsonKey(name: "_id")
  final String id;
  @override
  @JsonKey(name: "category")
  final String category;
  @override
  @JsonKey(name: "content")
  final String content;
  @override
  @JsonKey(name: "createdAt")
  final String createdAt;
  @override
  @JsonKey(name: "description")
  final String description;
  @override
  @JsonKey(name: "isFavorite")
  final bool isFavorite;
  @override
  @JsonKey(name: "isPublic")
  final bool isPublic;
  @override
  @JsonKey(name: "language")
  final String? language;
  @override
  @JsonKey(name: "title")
  final String title;
  @override
  @JsonKey(name: "updatedAt")
  final String? updatedAt;
  @override
  @JsonKey(name: "userId")
  final String? userId;
  @override
  @JsonKey(name: "userName")
  final String userName;

  @override
  String toString() {
    return 'PromptModel(id: $id, category: $category, content: $content, createdAt: $createdAt, description: $description, isFavorite: $isFavorite, isPublic: $isPublic, language: $language, title: $title, updatedAt: $updatedAt, userId: $userId, userName: $userName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromptModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      category,
      content,
      createdAt,
      description,
      isFavorite,
      isPublic,
      language,
      title,
      updatedAt,
      userId,
      userName);

  /// Create a copy of PromptModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PromptModelImplCopyWith<_$PromptModelImpl> get copyWith =>
      __$$PromptModelImplCopyWithImpl<_$PromptModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromptModelImplToJson(
      this,
    );
  }
}

abstract class _PromptModel implements PromptModel {
  const factory _PromptModel(
          {@JsonKey(name: "_id") final String id,
          @JsonKey(name: "category") required final String category,
          @JsonKey(name: "content") required final String content,
          @JsonKey(name: "createdAt") final String createdAt,
          @JsonKey(name: "description") final String description,
          @JsonKey(name: "isFavorite") required final bool isFavorite,
          @JsonKey(name: "isPublic") required final bool isPublic,
          @JsonKey(name: "language") final String? language,
          @JsonKey(name: "title") required final String title,
          @JsonKey(name: "updatedAt") final String? updatedAt,
          @JsonKey(name: "userId") final String? userId,
          @JsonKey(name: "userName") required final String userName}) =
      _$PromptModelImpl;

  factory _PromptModel.fromJson(Map<String, dynamic> json) =
      _$PromptModelImpl.fromJson;

  @override
  @JsonKey(name: "_id")
  String get id;
  @override
  @JsonKey(name: "category")
  String get category;
  @override
  @JsonKey(name: "content")
  String get content;
  @override
  @JsonKey(name: "createdAt")
  String get createdAt;
  @override
  @JsonKey(name: "description")
  String get description;
  @override
  @JsonKey(name: "isFavorite")
  bool get isFavorite;
  @override
  @JsonKey(name: "isPublic")
  bool get isPublic;
  @override
  @JsonKey(name: "language")
  String? get language;
  @override
  @JsonKey(name: "title")
  String get title;
  @override
  @JsonKey(name: "updatedAt")
  String? get updatedAt;
  @override
  @JsonKey(name: "userId")
  String? get userId;
  @override
  @JsonKey(name: "userName")
  String get userName;

  /// Create a copy of PromptModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PromptModelImplCopyWith<_$PromptModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
