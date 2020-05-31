// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FeedbackController on _FeedbackBase, Store {
  final _$coutTextFeedbackAtom = Atom(name: '_FeedbackBase.coutTextFeedback');

  @override
  int get coutTextFeedback {
    _$coutTextFeedbackAtom.context.enforceReadPolicy(_$coutTextFeedbackAtom);
    _$coutTextFeedbackAtom.reportObserved();
    return super.coutTextFeedback;
  }

  @override
  set coutTextFeedback(int value) {
    _$coutTextFeedbackAtom.context.conditionallyRunInAction(() {
      super.coutTextFeedback = value;
      _$coutTextFeedbackAtom.reportChanged();
    }, _$coutTextFeedbackAtom, name: '${_$coutTextFeedbackAtom.name}_set');
  }

  final _$ratingAtom = Atom(name: '_FeedbackBase.rating');

  @override
  double get rating {
    _$ratingAtom.context.enforceReadPolicy(_$ratingAtom);
    _$ratingAtom.reportObserved();
    return super.rating;
  }

  @override
  set rating(double value) {
    _$ratingAtom.context.conditionallyRunInAction(() {
      super.rating = value;
      _$ratingAtom.reportChanged();
    }, _$ratingAtom, name: '${_$ratingAtom.name}_set');
  }
}
