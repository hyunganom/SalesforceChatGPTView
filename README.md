# ChatGPT Salesforce 통합


## 개요

이 프로젝트는 Lightning Web Components (LWC)와 Apex를 사용하여 ChatGPT를 Salesforce와 통합합니다. Salesforce 내에서 사용자가 ChatGPT와 상호 작용하고 메시지를 원활하게 주고받을 수 있는 채팅 인터페이스를 제공합니다.

## 기능

	•	실시간 채팅: 사용자가 ChatGPT에 메시지를 보내고 실시간으로 응답을 받을 수 있습니다.
	•	메시지 저장: 모든 채팅 메시지는 Salesforce에 저장되어 나중에 참조하고 분석할 수 있습니다.
	•	RabbitMQ 통합: 메시지는 RabbitMQ 서버로 보내져 비동기 통신 및 처리를 처리합니다.
	•	자동 새로고침: 채팅 인터페이스는 수동 개입 없이 새 메시지를 표시하기 위해 자동으로 새로고침됩니다.
	•	오류 처리: 실패한 작업에 대한 오류 처리 및 사용자 알림을 제공합니다.


## 사용 기술

	•	Salesforce Apex: 맞춤 Apex 클래스와 트리거는 메시지 처리 및 RabbitMQ 통신을 처리합니다.
	•	Lightning Web Components (LWC): LWC를 사용하여 사용자 인터페이스를 구축하여 반응적이고 동적인 채팅 경험을 제공합니다.
	•	RabbitMQ: 메시지 큐잉 및 채팅 메시지의 비동기 처리를 위해 사용됩니다.
	•	HTTP 호출: RabbitMQ 서버와 통신하기 위해 Apex HTTP 호출이 사용됩니다.
	•	SOQL: Salesforce Object Query Language는 사용자 정의 Salesforce 객체에 저장된 채팅 메시지를 쿼리하는 데 사용됩니다.
	•	JavaScript: 사용자 상호 작용 및 동적 콘텐츠 업데이트를 처리하는 클라이언트 측 스크립팅입니다.
	•	Salesforce 이벤트 플랫폼: 이벤트 기반 아키텍처를 통해 메시지 처리와 통합을 효율적으로 관리합니다.

 ## 구성 요소
 	1.	Apex 클래스
		•ChatGPTController: 메시지 검색 및 전송을 처리합니다.
		•SendRabbitMq: RabbitMQ로 메시지를 전송합니다.
	2.	Apex 트리거
		•ChatGPTEventTrigger: 이벤트를 수신하고 Salesforce에 채팅 메시지를 삽입합니다.
	3.	Lightning Web Components
		•ChatGPTComponent: 메시지 표시 및 사용자 입력을 처리하는 채팅 인터페이스의 주요 구성 요소입니다.
	4.	Salesforce 커스텀 객체
		•InboundChat__c: 수신 및 발신 채팅 메시지를 저장하는 커스텀 객체입니다.
	5.	Salesforce 이벤트 플랫폼
		•Platform Event: 채팅 메시지 이벤트를 처리하고 비동기적으로 메시지를 전달합니다.
