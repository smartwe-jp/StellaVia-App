import 'settings_contract_document_models.dart';
import 'settings_operating_company_content.dart';

const String settingsContractDefaultProjectId =
    '__settings_contract_default_documents__';

const String _coolingOffPostTitle = 'クーリング・オフ通知書';
const String _coolingOffPostUrl = 'https://stellavia.co.jp/coolingoffpost.pdf';

SettingsContractProject buildSettingsContractDefaultDocumentsProject({
  required String projectName,
  required SettingsOperatingCompanyContent operatingCompanyContent,
}) {
  final documents = <SettingsContractDocument>[
    const SettingsContractDocument(
      description: _coolingOffPostTitle,
      files: <SettingsContractPdfFile>[
        SettingsContractPdfFile(
          name: _coolingOffPostTitle,
          url: _coolingOffPostUrl,
        ),
      ],
    ),
    ...operatingCompanyContent.links
        .where(
          (SettingsOperatingCompanyLink link) => link.url.trim().isNotEmpty,
        )
        .map(
          (SettingsOperatingCompanyLink link) => SettingsContractDocument(
            description: link.title,
            files: <SettingsContractPdfFile>[
              SettingsContractPdfFile(name: link.title, url: link.url),
            ],
          ),
        ),
  ];

  return SettingsContractProject(
    projectId: settingsContractDefaultProjectId,
    projectName: projectName,
    documents: documents,
  );
}
