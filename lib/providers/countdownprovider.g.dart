// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countdownprovider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$countDownNumberHash() => r'f0c9f65ab8d30b338b1547bda1d62ea751597043';

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

abstract class _$CountDownNumber
    extends BuildlessAutoDisposeNotifier<AsyncValue<int>> {
  late final DateTime timeStarting;

  AsyncValue<int> build(
    DateTime timeStarting,
  );
}

/// See also [CountDownNumber].
@ProviderFor(CountDownNumber)
const countDownNumberProvider = CountDownNumberFamily();

/// See also [CountDownNumber].
class CountDownNumberFamily extends Family<AsyncValue<int>> {
  /// See also [CountDownNumber].
  const CountDownNumberFamily();

  /// See also [CountDownNumber].
  CountDownNumberProvider call(
    DateTime timeStarting,
  ) {
    return CountDownNumberProvider(
      timeStarting,
    );
  }

  @override
  CountDownNumberProvider getProviderOverride(
    covariant CountDownNumberProvider provider,
  ) {
    return call(
      provider.timeStarting,
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
  String? get name => r'countDownNumberProvider';
}

/// See also [CountDownNumber].
class CountDownNumberProvider
    extends AutoDisposeNotifierProviderImpl<CountDownNumber, AsyncValue<int>> {
  /// See also [CountDownNumber].
  CountDownNumberProvider(
    this.timeStarting,
  ) : super.internal(
          () => CountDownNumber()..timeStarting = timeStarting,
          from: countDownNumberProvider,
          name: r'countDownNumberProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$countDownNumberHash,
          dependencies: CountDownNumberFamily._dependencies,
          allTransitiveDependencies:
              CountDownNumberFamily._allTransitiveDependencies,
        );

  final DateTime timeStarting;

  @override
  bool operator ==(Object other) {
    return other is CountDownNumberProvider &&
        other.timeStarting == timeStarting;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, timeStarting.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  AsyncValue<int> runNotifierBuild(
    covariant CountDownNumber notifier,
  ) {
    return notifier.build(
      timeStarting,
    );
  }
}

String _$quizEndNumberHash() => r'23c9899fd755f4308a71541c4b8339d00d07f67c';

abstract class _$QuizEndNumber
    extends BuildlessAutoDisposeNotifier<AsyncValue<int>> {
  late final int quizTime;

  AsyncValue<int> build(
    int quizTime,
  );
}

/// See also [QuizEndNumber].
@ProviderFor(QuizEndNumber)
const quizEndNumberProvider = QuizEndNumberFamily();

/// See also [QuizEndNumber].
class QuizEndNumberFamily extends Family<AsyncValue<int>> {
  /// See also [QuizEndNumber].
  const QuizEndNumberFamily();

  /// See also [QuizEndNumber].
  QuizEndNumberProvider call(
    int quizTime,
  ) {
    return QuizEndNumberProvider(
      quizTime,
    );
  }

  @override
  QuizEndNumberProvider getProviderOverride(
    covariant QuizEndNumberProvider provider,
  ) {
    return call(
      provider.quizTime,
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
  String? get name => r'quizEndNumberProvider';
}

/// See also [QuizEndNumber].
class QuizEndNumberProvider
    extends AutoDisposeNotifierProviderImpl<QuizEndNumber, AsyncValue<int>> {
  /// See also [QuizEndNumber].
  QuizEndNumberProvider(
    this.quizTime,
  ) : super.internal(
          () => QuizEndNumber()..quizTime = quizTime,
          from: quizEndNumberProvider,
          name: r'quizEndNumberProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$quizEndNumberHash,
          dependencies: QuizEndNumberFamily._dependencies,
          allTransitiveDependencies:
              QuizEndNumberFamily._allTransitiveDependencies,
        );

  final int quizTime;

  @override
  bool operator ==(Object other) {
    return other is QuizEndNumberProvider && other.quizTime == quizTime;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, quizTime.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  AsyncValue<int> runNotifierBuild(
    covariant QuizEndNumber notifier,
  ) {
    return notifier.build(
      quizTime,
    );
  }
}

String _$userAnswersToQuizHash() => r'd8aafc51c634257103802470030b99773c7726dd';

abstract class _$UserAnswersToQuiz
    extends BuildlessAutoDisposeNotifier<List<List<bool>>> {
  late final QuizModel quizModel;

  List<List<bool>> build(
    QuizModel quizModel,
  );
}

/// See also [UserAnswersToQuiz].
@ProviderFor(UserAnswersToQuiz)
const userAnswersToQuizProvider = UserAnswersToQuizFamily();

/// See also [UserAnswersToQuiz].
class UserAnswersToQuizFamily extends Family<List<List<bool>>> {
  /// See also [UserAnswersToQuiz].
  const UserAnswersToQuizFamily();

  /// See also [UserAnswersToQuiz].
  UserAnswersToQuizProvider call(
    QuizModel quizModel,
  ) {
    return UserAnswersToQuizProvider(
      quizModel,
    );
  }

  @override
  UserAnswersToQuizProvider getProviderOverride(
    covariant UserAnswersToQuizProvider provider,
  ) {
    return call(
      provider.quizModel,
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
  String? get name => r'userAnswersToQuizProvider';
}

/// See also [UserAnswersToQuiz].
class UserAnswersToQuizProvider extends AutoDisposeNotifierProviderImpl<
    UserAnswersToQuiz, List<List<bool>>> {
  /// See also [UserAnswersToQuiz].
  UserAnswersToQuizProvider(
    this.quizModel,
  ) : super.internal(
          () => UserAnswersToQuiz()..quizModel = quizModel,
          from: userAnswersToQuizProvider,
          name: r'userAnswersToQuizProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userAnswersToQuizHash,
          dependencies: UserAnswersToQuizFamily._dependencies,
          allTransitiveDependencies:
              UserAnswersToQuizFamily._allTransitiveDependencies,
        );

  final QuizModel quizModel;

  @override
  bool operator ==(Object other) {
    return other is UserAnswersToQuizProvider && other.quizModel == quizModel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, quizModel.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  List<List<bool>> runNotifierBuild(
    covariant UserAnswersToQuiz notifier,
  ) {
    return notifier.build(
      quizModel,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
