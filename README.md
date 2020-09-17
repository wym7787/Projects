# Yumin's Projects

Master's Projects

1. Computer Archtecture
* CacheSimulator
  - Channel, Way, Associativity에 따라 Cache hit ratio와 miss ratio를 SPEC CPU benchmark trace들을 활용하여 캐시 성능을 측정하기 위한 Cache simulation 과제
    LRU 캐시 알고리즘과 PSEUDO LRU 알고리즘에 따라 성능 비교 평가도 수행
  
* Out Of Order
  - Cache Instruction 진행 순서를 바꿔 캐시 성능을 향상 시키는 Out_Of_Order 알고리즘 Simulator 구현 과제

2. Operating System
* Kernel
  - Kernel에서 지원하는 LZ4 Compression 알고리즘을 활용하여 원본 데이터를 약 17% ~ 20% 정도 감소 시키고, 2배의 성능 개선을 이룬 Device Driver Module 과제

3. SSD Study
* SSD_Proejct
  - NAND Device 특성상 하드디스크와 달리 덮어쓰기가 되지 않는 특징을 갖는다. 이 때문에 SSD 내부에 FTL (Flash Translation Layer) S/W를 통해 논리 주소를 물리적 주소로 변환해
    주는 계층이 존재한다. 대학원에서 주로 FTL 에서 수행하는 매핑 테이블 관리를 연구했으며, 빠른 실험을 위해 메모리 상에서 FlashSimultor를 구현하여 SSD의 성능 측정을 하기 위해 만들어진             FlashSimultor.
  - 이 외에도 *github : https://github.com/dgist-datalab/FlashDriver/tree/demand/algorithm (sftl, tpftl, hashftl, bloomftl 관련 알고리즘을 구현)
    FlashDriver는 DGIST DataLab에서 만들어진 User-space 기반의 FlashSimulator 입니다.

Bachelor's Projects

1. Mobile Programming
* Go_healthclub
  - 운동을 처음 접하는 사람들을 위한 정보 제공을 목적으로 만든 웹/앱 서비스 프로젝트. JAVA와 JSP, MySQL을 활용하여 구현하고 cafe24 웹 호스팅을 통해 실제 배포 경험
  
2. Database Programming
* Pharmacy DB design
  - 약국에서 사용되는 데이터베이스를 설계하고, JAVA와 JSP 그리고 Oracle을 활용하여 만든 웹/앱 서비스 구현 (Local 에서 구현)
  
3. Network Programming
* Multi-thread based chatting project
  - 소켓 프로그래밍을 활용하여 멀티 스레드 기반 채팅 프로그램을 제작. 추가적으로 유저들 간의 귓속말 기능을 추가하였음 (Local에서 구현)
