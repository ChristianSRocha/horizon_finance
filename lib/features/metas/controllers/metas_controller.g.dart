// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metas_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$metasRepositoryHash() => r'ffa816342f1cbcdb0c1ba83bd7f5b210171f103b';

/// See also [metasRepository].
@ProviderFor(metasRepository)
final metasRepositoryProvider = AutoDisposeProvider<MetasRepository>.internal(
  metasRepository,
  name: r'metasRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$metasRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MetasRepositoryRef = AutoDisposeProviderRef<MetasRepository>;
String _$metasControllerHash() => r'8600116b8ec3d897568d12ee16cf798ef0ef536e';

/// See also [MetasController].
@ProviderFor(MetasController)
final metasControllerProvider =
    AutoDisposeAsyncNotifierProvider<MetasController, List<Meta>>.internal(
  MetasController.new,
  name: r'metasControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$metasControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MetasController = AutoDisposeAsyncNotifier<List<Meta>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
