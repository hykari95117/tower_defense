# Tower Survivor - 프로젝트 컨텍스트

## 게임 개요
- **엔진**: Godot 4.6 (Mobile renderer, D3D12)
- **장르**: Tower Survivor (단순화된 타워 디펜스)
- **분위기**: Surreal - 판타지와 현대 요소 혼합 (신성한 사슴, 고대 마법사 옆에 미사일과 로봇이 공존)
- **플랫폼**: 모바일 우선 (세로 화면, Portrait), 이후 PC 대응
- **핵심 철학**: 최대한 단순하게 — 복잡한 건 없애고 선택의 무게감을 높인다

---

## 핵심 게임플레이

### 타워 (Tower)
- 화면 **중앙 고정 1개** — 이동 불가, 개수 증가 없음
- 라운드 사이에 **업그레이드** 가능 (골드 소모)
- 계절에 따라 외형과 능력치 변화 (tower1~4 각각 spring/summer/fall/winter 버전 보유)

### 몬스터 (Monster)
- **사방에서 타워를 향해** 직선 접근
- 3종류: `slime` (일반) / `middle_boss` (중간보스) / `last_boss` (최종보스)
- 계절에 따라 몬스터 능력치 변동

### 라운드 구조
- **N라운드 클리어 + HP 유지** 시 승리
- 라운드 **25, 50, 75, 100** 배수마다 `middle_boss` 등장
- 최종 라운드에 `last_boss` 등장
- 매 라운드마다 보스 등장하지 않음

### 라운드 사이 행동
1. **타워 업그레이드** — 공격력, 사거리, 공격속도 등 강화
2. **스킬 교체 OR 강화** — 4슬롯 중 원하는 슬롯의 스킬을 바꾸거나 강화

---

## 스킬 시스템 (4슬롯 고정)

| 슬롯 | 카테고리 | 발동 방식 | 특이사항 |
|------|----------|----------|----------|
| 1 | **공격 (Attack)** | 자동 발동 | 타워가 자동으로 스킬 사용 |
| 2 | **버프 (Buff)** | 터치 즉시 시전 | 시전 가능 시간 제한 있음 |
| 3 | **방어 (Defense)** | 자동 발동 | 피해 감소/방어 자동 처리 |
| 4 | **회피 (Evasion)** | 라운드당 1회 | 해당 라운드 전체 Skip — **보상 없음** |

**회피 스킬 주의**: 사용 시 라운드를 건너뛰지만 클리어 보상(골드, 스킬 선택 기회)이 없음. 리스크-리워드 선택.

---

## 계절 시스템 (4계절)
- **spring**: 기본 상태
- **summer**: (게임플레이 영향 TBD)
- **fall**: (게임플레이 영향 TBD)
- **winter**: (게임플레이 영향 TBD)

각 계절마다 배경(`assets/background/`), 타워 외형이 변화하며 몬스터 및 타워 능력치에 영향을 줌.

---

## 에셋 구조
```
assets/
├── background/          # spring.jpg, summer.jpg, fall.jpg, winter.jpg
└── _origin/
    ├── background/
    ├── monster/
    │   ├── slime.jpg
    │   ├── middle_boss/
    │   └── last_boss/
    ├── skills/
    │   ├── attack/      # missile.jpg, robot.jpg, robot2.jpg
    │   ├── buff/        # a spiritual deer.jpg, an ancient wizard.jpg, monster_drink.jpg
    │   ├── defense/     # mirror1.jpg, mirror2.jpg
    │   └── evasion/     # bloodstained hands1.jpg, bloodstained hands2.jpg, car_rush1.jpg
    └── towers/
        ├── tower.jpg    # 기본 타워
        ├── tower1/      # tower_image1_spring/summer/fall/winter/4cut
        ├── tower2/      # tower_image2_spring/summer/fall/winter/4cut
        ├── tower3/      # tower_image3_spring/summer/fall/winter/4cut
        └── tower4/      # tower_image4_spring/summer/fall/winter (top/bottom 분리)
```

---

## 개발 규칙
- **언어**: GDScript (Godot 4.x 문법)
- **씬 구조**: 모바일 세로 화면 기준 설계
- **단순함 유지**: 불필요한 복잡도 추가 금지. 기능은 최소한으로, 선택의 깊이로 재미를 만든다
- **코드 스타일**: snake_case, 주석은 한국어 허용

---

## 현재 상태
- Godot 4.6 프로젝트 초기 세팅 완료
- 원본 이미지 에셋 보유 (스프라이트 변환 필요)
- 씬 파일 미구현 (배경/타워 프로토타입 삭제됨)

---

## Agent 구성

프로젝트에는 4개의 전문 sub-agent가 정의되어 있습니다 (`.claude/agents/`).

| Agent | 파일 | 역할 | 주요 도구 |
|-------|------|------|----------|
| **concept** | `concept.md` | 기획 — 밸런스 수치, 기능 명세, 계절 시스템, 라운드 설계 | Read, Write, Edit |
| **dev** | `dev.md` | 개발 — GDScript 코딩, 씬 구성, 게임 로직 구현 | Read, Write, Edit, Bash |
| **design** | `design.md` | 디자인 — UI/UX 레이아웃, 에셋 배치, 계절 전환 효과 | Read, Write, Edit |
| **test** | `test.md` | 테스트 — 버그 탐지, 밸런스 검증, 엣지 케이스 분석 | Read, Glob, Grep, Bash |

### 호출 방법
Claude가 작업 내용에 따라 자동으로 적절한 agent를 선택하거나, 직접 명시할 수 있습니다.

```
# 직접 명시 예시
dev agent로 라운드 매니저 스크립트 만들어줘
concept agent에게 계절별 몬스터 스탯 설계 맡겨줘
design agent한테 스킬 슬롯 UI 레이아웃 설계해줘
test agent로 지금 코드 버그 검사해줘

# 등록된 agent 목록 확인
/agents
```

### Agent 간 역할 분리 원칙
- **concept** → 무엇을 만들지 결정
- **dev** → 어떻게 코드로 구현할지 결정
- **design** → 어떻게 보여줄지 결정
- **test** → 제대로 동작하는지 검증
