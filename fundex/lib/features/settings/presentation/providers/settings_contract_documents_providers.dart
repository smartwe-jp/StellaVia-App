import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/settings_contract_documents_remote_data_source.dart';
import '../support/settings_contract_document_models.dart';

final settingsContractDocumentsRemoteDataSourceProvider =
    Provider<SettingsContractDocumentsRemoteDataSource>((ref) {
      return SettingsContractDocumentsRemoteDataSourceImpl(
        ref.watch(oaCoreHttpClientProvider),
        memberClient: ref.watch(memberCoreHttpClientProvider),
        clusterRouter: ref.watch(apiClusterRouterProvider),
      );
    });

final settingsContractProjectsProvider =
    FutureProvider.autoDispose<List<SettingsContractProject>>((ref) async {
      ref.watch(authSessionProvider);
      final user = await ref.watch(currentAuthUserProvider.future).catchError((
        Object _,
      ) {
        return null;
      });
      if (user == null) {
        return const <SettingsContractProject>[];
      }

      final rows = await ref
          .watch(settingsContractDocumentsRemoteDataSourceProvider)
          .fetchContractProjects(limit: 300, startPage: 1);
      return _mergeProjects(
        rows
            .map(_mapProject)
            .where(
              (SettingsContractProject project) =>
                  project.projectName.trim().isNotEmpty,
            )
            .toList(growable: false),
      );
    });

final settingsContractProjectProvider = FutureProvider.family
    .autoDispose<SettingsContractProject?, String>((ref, projectKey) async {
      final projects = await ref.watch(settingsContractProjectsProvider.future);
      for (final project in projects) {
        if (project.routeKey == projectKey) {
          return project;
        }
      }
      return null;
    });

SettingsContractProject _mapProject(UserInvestmentContractProjectPdfDto dto) {
  return SettingsContractProject(
    projectId: dto.projectId,
    projectName: dto.projectName,
    documents: dto.documents.map(_mapDocument).toList(growable: false),
  );
}

SettingsContractDocument _mapDocument(UserInvestmentPdfDocumentDto dto) {
  return SettingsContractDocument(
    type: dto.type,
    description: dto.description?.trim().isNotEmpty == true
        ? dto.description!.trim()
        : 'PDF',
    files: dto.urls
        .map(
          (UserInvestmentPdfUrlDto file) => SettingsContractPdfFile(
            name: file.name,
            url: file.url,
            createTime: file.createTime,
          ),
        )
        .toList(growable: false),
  );
}

List<SettingsContractProject> _mergeProjects(
  List<SettingsContractProject> projects,
) {
  final Map<String, _ProjectAccumulator> mergedProjects =
      <String, _ProjectAccumulator>{};

  for (final project in projects) {
    final key = '${project.projectId ?? ''}::${project.projectName}';
    final projectAccumulator = mergedProjects.putIfAbsent(
      key,
      () => _ProjectAccumulator(
        projectId: project.projectId,
        projectName: project.projectName,
      ),
    );

    for (final document in project.documents) {
      final documentKey =
          '${document.type?.toString() ?? ''}::${document.description}';
      final documentAccumulator = projectAccumulator.documents.putIfAbsent(
        documentKey,
        () => _DocumentAccumulator(
          type: document.type,
          description: document.description,
        ),
      );
      for (final file in document.files) {
        final fileKey =
            '${file.url?.trim() ?? ''}::${file.name?.trim() ?? ''}::${file.createTime?.trim() ?? ''}';
        documentAccumulator.files.putIfAbsent(fileKey, () => file);
      }
    }
  }

  return mergedProjects.values
      .map((project) {
        return SettingsContractProject(
          projectId: project.projectId,
          projectName: project.projectName,
          documents: project.documents.values
              .map((document) {
                return SettingsContractDocument(
                  type: document.type,
                  description: document.description,
                  files: document.files.values.toList(growable: false),
                );
              })
              .toList(growable: false),
        );
      })
      .toList(growable: false);
}

class _ProjectAccumulator {
  _ProjectAccumulator({required this.projectId, required this.projectName});

  final String? projectId;
  final String projectName;
  final Map<String, _DocumentAccumulator> documents =
      <String, _DocumentAccumulator>{};
}

class _DocumentAccumulator {
  _DocumentAccumulator({required this.type, required this.description});

  final int? type;
  final String description;
  final Map<String, SettingsContractPdfFile> files =
      <String, SettingsContractPdfFile>{};
}
