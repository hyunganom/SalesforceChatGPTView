# ChatGPT Salesforce 통합


## 개요

이 프로젝트는 Lightning Web Components (LWC)와 Apex를 사용하여 ChatGPT를 Salesforce와 통합합니다. Salesforce 내에서 사용자가 ChatGPT와 상호 작용하고 메시지를 원활하게 주고받을 수 있는 채팅 인터페이스를 제공합니다.

## 기능

	•	실시간 채팅: 사용자가 ChatGPT에 메시지를 보내고 실시간으로 응답을 받을 수 있습니다.
	•	메시지 저장: 모든 채팅 메시지는 Salesforce에 저장되어 나중에 참조하고 분석할 수 있습니다.
	•	RabbitMQ 통합: 메시지는 RabbitMQ 서버로 보내져 비동기 통신 및 처리를 처리합니다.
	•	자동 새로고침: 채팅 인터페이스는 수동 개입 없이 새 메시지를 표시하기 위해 자동으로 새로고침됩니다.
	•	오류 처리: 실패한 작업에 대한 강력한 오류 처리 및 사용자 알림을 제공합니다.
	•	이벤트 플랫폼 사용: Salesforce 이벤트 플랫폼을 활용하여 이벤트 기반 아키텍처로 메시지 처리를 효율화합니다.


## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
