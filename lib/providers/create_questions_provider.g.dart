// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_questions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createQuestionsHash() => r'811752285f168059e901aeead5632a5a05730ede';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CreateQuestions
    extends BuildlessAutoDisposeNotifier<List<QuestionModel>> {
  late final int numberOfQuestions;

  List<QuestionModel> build(
    int numberOfQuestions,
  );
}

/// See also [CreateQuestions].
@ProviderFor(CreateQuestions)
const createQuestionsProvider = CreateQuestionsFamily();

/// See also [CreateQuestions].
class CreateQuestionsFamily extends Family<List<QuestionModel>> {
  /// See also [CreateQuestions].
  const CreateQuestionsFamily();

  /// See also [CreateQuestions].
  CreateQuestionsProvider call(
    int numberOfQuestions,
  ) {
    return CreateQuestionsProvider(
      numberOfQuestions,
    );
  }

  @override
  CreateQuestionsProvider getProviderOverride(
    covariant CreateQuestionsProvider provider,
  ) {
    return call(
      provider.numberOfQuestions,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createQuestionsProvider';
}

/// See also [CreateQuestions].
class CreateQuestionsProvider extends AutoDisposeNotifierProviderImpl<
    CreateQuestions, List<QuestionModel>> {
  /// See also [CreateQuestions].
  CreateQuestionsProvider(
    this.numberOfQuestions,
  ) : super.internal(
          () => CreateQuestions()..numberOfQuestions = numberOfQuestions,
          from: createQuestionsProvider,
          name: r'createQuestionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createQuestionsHash,
          dependencies: CreateQuestionsFamily._dependencies,
          allTransitiveDependencies:
              CreateQuestionsFamily._allTransitiveDependencies,
        );

  final int numberOfQuestions;

  @override
  bool operator ==(Object other) {
    return other is CreateQuestionsProvider &&
        other.numberOfQuestions == numberOfQuestions;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, numberOfQuestions.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  List<QuestionModel> runNotifierBuild(
    covariant CreateQuestions notifier,
  ) {
    return notifier.build(
      numberOfQuestions,
    );
  }
}

String _$saveQuizHash() => r'f6695cbef17769c8f7122994f2c7ec560e077589';

/// See also [SaveQuiz].
@ProviderFor(SaveQuiz)
final saveQuizProvider =
    AutoDisposeAsyncNotifierProvider<SaveQuiz, QuizStates>.internal(
  SaveQuiz.new,
  name: r'saveQuizProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$saveQuizHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SaveQuiz = AutoDisposeAsyncNotifier<QuizStates>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
