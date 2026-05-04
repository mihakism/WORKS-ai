# WORKS AI — Claude Code 인수인계 문서

## 프로젝트 개요
WORKS(라인웍스) 캘린더 + AI 기능 프로토타입. 순수 정적 HTML (빌드 도구 없음).

- **GitHub**: https://github.com/mihakism/WORKS-ai.git
- **Vercel 배포**: https://works-ai-three.vercel.app/calendar.html
- **로컬 미리보기**: `npx serve -l 8090 /Users/user/Documents/WORKS-ai`
  - 브라우저: http://localhost:8090/calendar.html

## 주요 파일
| 파일 | 설명 |
|------|------|
| `calendar.html` | 메인 캘린더 페이지 (모든 UI·CSS·JS 인라인) |
| `index.html` | 랜딩/홈 |
| `messenger.html` | 메신저 UI |
| `assets/profile-me.jpg` | 프로필 사진 (홍미학) |
| `sync.sh` | Google Drive ↔ 로컬 동기화 (`./sync.sh up` / `./sync.sh down`) |
| `setup-new-mac.sh` | 새 컴퓨터 환경 셋업 스크립트 |

## 로컬 전용 파일 (git에 없음)
위치: `/Users/user/Documents/WORKS_calendar_files/`
- `WORKS_calendar.htm` — 캘린더 페이지 레퍼런스 HTML
- `make_calendar.htm` — 일정 만들기 모달 레퍼런스 HTML
- `479.c036f3134cad3f1ea9c7.css` — WORKS 번들 CSS (스프라이트 위치 등 참조용)

---

## 현재 구현 상태 (2026-04-28 기준)

### 일정 만들기 모달 (`write_schedule`) — 2컬럼 1160px
#### 좌측 폼 (`ws-schedule-cover`)
- 제목 인풋 `title-input-main` (id=`eventTitle`) — hover 점선 border
- ✦ 반짝이 + 키워드 추천 칩 (`kwchip`) — `kwFadeIn` 애니메이션
- 참석자 행 (날짜 위에 위치) — 검색 드롭다운 `wsAttDropdown` + 프로젝트 칩 `ws-proj-chip`
- 참석자 카드 그리드 `ws-att-grid` (2컬럼) + 푸터 `ws-att-footer`
- 날짜·시간, 캘린더, 화상회의, 설비(회의실), 장소, 메모, 첨부, 위키링크
- **제거됨**: 공개/비공개, 내 설정(범주·알림·상태)

#### 우측 AI 패널 (`ws-detail-box`) — 3가지 상태
| 상태 | ID | 표시 조건 |
|------|----|----------|
| 기본 | `wsDefaultPanel` | 모달 열자마자 |
| 자연어 감지 | `wsSmartCard` | 제목 10자+ 자연어 입력 시 |
| 아젠다 | `wsAgendaSection` | 회의 유형 선택 후 |

**wsDefaultPanel 구성 (핵심)**
- **이어 잡기** 섹션: 프로젝트별 최근 회의 카드 (Q4마케팅/AI디자인팀/브랜드TF)
  - 클릭 → `wsPickContinue(key)` → 제목+참석자+아젠다 자동 채움
- **정규 회의** 섹션: 반복 회의 템플릿 (스탠드업/위클리/1on1)
  - 클릭 → `wsPickTemplate(key)` → 제목+참석자+아젠다 자동 채움

---

## 핵심 JS 데이터 구조

### WS_PEOPLE (object, key=한국이름)
```js
WS_PEOPLE['홍미학'] = { nameEn, nick, dept, email, isLeader, color }
// 주요 인물: 홍미학(주최자), 정예지, 김서윤, 이준혁, 오항남, 박민수 등 13명
```

### wsAttendees (array) — 현재 참석자
```js
wsAttendees = [{ name:'홍미학', isOrganizer:true, isRequired:true }, ...]
// 홍미학은 항상 첫 번째, 제거 불가
```

### WS_CONTINUE / WS_TEMPLATES
```js
WS_CONTINUE = {
  q4:    { title, typeKey:'기획리뷰', members:['정예지','오항남','김서윤','이준혁'] },
  ai:    { title, typeKey:'팀회의',   members:['박민수','최다인','한지수'] },
  brand: { title, typeKey:'기획리뷰', members:['정예지','이준혁'] },
}
WS_TEMPLATES = {
  standup: { title, typeKey:'스탠드업', members:[...] },
  weekly:  { title, typeKey:'팀회의',   members:[...] },
  oneon1:  { title, typeKey:'1on1',     members:['박민수'] },
}
```

### WS_PROJECTS / WS_AGENDAS
- `WS_PROJECTS[typeKey]` → 프로젝트 칩 배열 (Slack 스타일, hover 툴팁)
- `WS_AGENDAS[typeKey]` → 아젠다 항목 배열 `[[제목, 시간], ...]`

---

## 주요 JS 함수
```js
_wsLoadMeeting(title, typeKey, members)  // 이어잡기·정규회의 공통 로더
wsPickContinue(key)     // 이어 잡기 카드 클릭
wsPickTemplate(key)     // 정규 회의 카드 클릭
wsPickType(title, typeKey)  // 키워드 칩 클릭
showWsAgenda(typeKey)   // 아젠다 섹션 렌더링 (500ms 딜레이)
wsRenderAttSuggest(typeKey) // 프로젝트 칩 렌더링
wsAddAttendee(name)     // 참석자 추가
renderWsAttendees()     // 참석자 카드 그리드 렌더링
wsRenderAttDropdown(query)  // 검색 드롭다운
onTitleInput(val)       // 자연어 감지 (600ms 디바운스)
```

---

## 디자인 토큰

### 색상 변수 (:root)
```css
--cal-purple: #744DC8;
--cal-blue: #4B84D9;
--cal-orange: #F9A826;
--cal-teal: #38A23A;
--sunday-red: #F35055;
--ai-blue-bg: #E8F2FF;
--ai-green-bg: #E8F8EF;
```
**그레이 통일 톤**: `#F2F3F5` (카드 bg), `#EAECF0` (hover)

### 폰트
```
https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable-dynamic-subset.min.css
```

### WORKS 스프라이트 SVG
```
https://static.worksmobile.net/static/calendar/2023/sp_cal_2019_9698727f.svg
```
```css
.item_title_date::before          { background-position: -228px -259px; }
.item_title_calendar::before      { background-position: -284px -175px; }
.item_title_attendant::before     { background-position: -172px -259px; }
.item_title_video_meeting::before { background-position: -172px -287px; }
.item_title_resource::before      { background-position: -116px -287px; }
.item_title_place::before         { background-position: -148px -215px; }
.item_title_memo::before          { background-position: -200px -259px; }
.item_title_attach::before        { background-position: -228px -175px; }
```

---

## 새 컴퓨터 셋업 체크리스트
1. `git clone https://github.com/mihakism/WORKS-ai.git ~/Documents/WORKS-ai`
2. `WORKS_calendar_files/` 폴더 AirDrop/USB로 `~/Documents/` 에 복사
3. Claude Code에서 `~/Documents/WORKS-ai` 열기
4. 미리보기: `npx serve -l 8090 ~/Documents/WORKS-ai` → http://localhost:8090/calendar.html
5. Vercel 배포: `vercel deploy --prod --yes` (vercel CLI 설치 필요: `npm i -g vercel`)
6. Google Drive 동기화: `./sync.sh down` (rclone 설정 필요시 `bash setup-new-mac.sh`)

## 주요 결정사항 / 규칙
- 빌드 도구 없음, 모든 것이 `calendar.html` 한 파일에 인라인
- 외부 리소스는 CDN/정적URL만 사용
- 참조 파일(`WORKS_calendar_files/`)은 git에 포함하지 않음 (회사 내부 리소스)
- Pretendard Variable 폰트 필수
- Vercel 프로젝트명: `works-ai` / URL: `works-ai-three.vercel.app`
- 커밋할 때마다 `vercel deploy --prod --yes`로 동시 배포
