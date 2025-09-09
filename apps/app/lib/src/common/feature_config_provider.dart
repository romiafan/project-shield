import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/src/feature_config.dart';

final featureConfigProvider = Provider<Map<String, bool>>(
  (ref) => kFeatureConfig,
);
