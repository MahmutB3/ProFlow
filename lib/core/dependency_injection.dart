import 'package:get/get.dart';
import 'package:surecproject/data/repositories/process_repository_impl.dart';
import 'package:surecproject/domain/repositories/process_repository.dart';
import 'package:surecproject/domain/usecases/analyze_process_data.dart';
import 'package:surecproject/presentation/controllers/process_controller.dart';
import 'package:surecproject/presentation/controllers/theme_controller.dart';

class DependencyInjection {
  static void init() {
    // Repositories
    Get.lazyPut<ProcessRepository>(() => ProcessRepositoryImpl(), fenix: true);

    // Use cases
    Get.lazyPut<AnalyzeProcessData>(
      () => AnalyzeProcessData(Get.find<ProcessRepository>()),
      fenix: true,
    );

    // Controllers
    Get.lazyPut<ProcessController>(
      () =>
          ProcessController(analyzeProcessData: Get.find<AnalyzeProcessData>()),
      fenix: true,
    );

    // Theme controller
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
  }
}
