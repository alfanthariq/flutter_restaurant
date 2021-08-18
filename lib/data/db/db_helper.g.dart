// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_helper.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class RestaurantDbData extends DataClass
    implements Insertable<RestaurantDbData> {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final String rating;
  RestaurantDbData(
      {required this.id,
      required this.name,
      required this.description,
      required this.city,
      required this.address,
      required this.pictureId,
      required this.rating});
  factory RestaurantDbData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return RestaurantDbData(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description'])!,
      city: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}city'])!,
      address: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}address'])!,
      pictureId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}picture_id'])!,
      rating: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rating'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['city'] = Variable<String>(city);
    map['address'] = Variable<String>(address);
    map['picture_id'] = Variable<String>(pictureId);
    map['rating'] = Variable<String>(rating);
    return map;
  }

  RestaurantDbCompanion toCompanion(bool nullToAbsent) {
    return RestaurantDbCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      city: Value(city),
      address: Value(address),
      pictureId: Value(pictureId),
      rating: Value(rating),
    );
  }

  factory RestaurantDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return RestaurantDbData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      city: serializer.fromJson<String>(json['city']),
      address: serializer.fromJson<String>(json['address']),
      pictureId: serializer.fromJson<String>(json['pictureId']),
      rating: serializer.fromJson<String>(json['rating']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'city': serializer.toJson<String>(city),
      'address': serializer.toJson<String>(address),
      'pictureId': serializer.toJson<String>(pictureId),
      'rating': serializer.toJson<String>(rating),
    };
  }

  RestaurantDbData copyWith(
          {String? id,
          String? name,
          String? description,
          String? city,
          String? address,
          String? pictureId,
          String? rating}) =>
      RestaurantDbData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        city: city ?? this.city,
        address: address ?? this.address,
        pictureId: pictureId ?? this.pictureId,
        rating: rating ?? this.rating,
      );
  @override
  String toString() {
    return (StringBuffer('RestaurantDbData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('city: $city, ')
          ..write('address: $address, ')
          ..write('pictureId: $pictureId, ')
          ..write('rating: $rating')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              description.hashCode,
              $mrjc(
                  city.hashCode,
                  $mrjc(address.hashCode,
                      $mrjc(pictureId.hashCode, rating.hashCode)))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestaurantDbData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.city == this.city &&
          other.address == this.address &&
          other.pictureId == this.pictureId &&
          other.rating == this.rating);
}

class RestaurantDbCompanion extends UpdateCompanion<RestaurantDbData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> city;
  final Value<String> address;
  final Value<String> pictureId;
  final Value<String> rating;
  const RestaurantDbCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.city = const Value.absent(),
    this.address = const Value.absent(),
    this.pictureId = const Value.absent(),
    this.rating = const Value.absent(),
  });
  RestaurantDbCompanion.insert({
    required String id,
    required String name,
    required String description,
    required String city,
    required String address,
    required String pictureId,
    required String rating,
  })  : id = Value(id),
        name = Value(name),
        description = Value(description),
        city = Value(city),
        address = Value(address),
        pictureId = Value(pictureId),
        rating = Value(rating);
  static Insertable<RestaurantDbData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? city,
    Expression<String>? address,
    Expression<String>? pictureId,
    Expression<String>? rating,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (city != null) 'city': city,
      if (address != null) 'address': address,
      if (pictureId != null) 'picture_id': pictureId,
      if (rating != null) 'rating': rating,
    });
  }

  RestaurantDbCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? city,
      Value<String>? address,
      Value<String>? pictureId,
      Value<String>? rating}) {
    return RestaurantDbCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      city: city ?? this.city,
      address: address ?? this.address,
      pictureId: pictureId ?? this.pictureId,
      rating: rating ?? this.rating,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (pictureId.present) {
      map['picture_id'] = Variable<String>(pictureId.value);
    }
    if (rating.present) {
      map['rating'] = Variable<String>(rating.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantDbCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('city: $city, ')
          ..write('address: $address, ')
          ..write('pictureId: $pictureId, ')
          ..write('rating: $rating')
          ..write(')'))
        .toString();
  }
}

class $RestaurantDbTable extends RestaurantDb
    with TableInfo<$RestaurantDbTable, RestaurantDbData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $RestaurantDbTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _cityMeta = const VerificationMeta('city');
  late final GeneratedColumn<String?> city = GeneratedColumn<String?>(
      'city', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _addressMeta = const VerificationMeta('address');
  late final GeneratedColumn<String?> address = GeneratedColumn<String?>(
      'address', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _pictureIdMeta = const VerificationMeta('pictureId');
  late final GeneratedColumn<String?> pictureId = GeneratedColumn<String?>(
      'picture_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _ratingMeta = const VerificationMeta('rating');
  late final GeneratedColumn<String?> rating = GeneratedColumn<String?>(
      'rating', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, city, address, pictureId, rating];
  @override
  String get aliasedName => _alias ?? 'restaurant_db';
  @override
  String get actualTableName => 'restaurant_db';
  @override
  VerificationContext validateIntegrity(Insertable<RestaurantDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('picture_id')) {
      context.handle(_pictureIdMeta,
          pictureId.isAcceptableOrUnknown(data['picture_id']!, _pictureIdMeta));
    } else if (isInserting) {
      context.missing(_pictureIdMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestaurantDbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return RestaurantDbData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $RestaurantDbTable createAlias(String alias) {
    return $RestaurantDbTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $RestaurantDbTable restaurantDb = $RestaurantDbTable(this);
  late final RestaurantDao restaurantDao = RestaurantDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [restaurantDb];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$RestaurantDaoMixin on DatabaseAccessor<AppDatabase> {
  $RestaurantDbTable get restaurantDb => attachedDatabase.restaurantDb;
}
