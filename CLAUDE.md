# WORKS AI — Claude Code 인수인계 문서

## 프로젝트 개요
WORKS(라인웍스) 캘린더 + AI 기능 프로토타입. 순수 정적 HTML (빌드 도구 없음).

- **GitHub**: https://github.com/mihakism/WORKS-ai.git
- **Vercel 배포**: https://works-ai-v3.vercel.app
- **로컬 미리보기**: `python3 -m http.server 8090 --directory /Users/user/Documents/WORKS-ai`
  - 브라우저: http://localhost:8090/calendar.html

## 주요 파일
| 파일 | 설명 |
|------|------|
| `calendar.html` | 메인 캘린더 페이지 (모든 UI 포함) |
| `index.html` | 랜딩/홈 |
| `messenger.html` | 메신저 UI |
| `assets/profile-me.jpg` | 프로필 사진 |
| `.claude/launch.json` | 미리보기 서버 설정 |

## 로컬 전용 파일 (git에 없음, 새 컴퓨터에 직접 복사 필요)
위치: `/Users/user/Documents/WORKS_calendar_files/`
- `WORKS_calendar.htm` — 캘린더 페이지 레퍼런스 HTML
- `make_calendar.htm` — 일정 만들기 모달 레퍼런스 HTML
- `479.c036f3134cad3f1ea9c7.css` — WORKS 번들 CSS (스프라이트 위치 등 참조용)

## 디자인 토큰 / 리소스
### 폰트
```
https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable-dynamic-subset.min.css
```

### WORKS 스프라이트 SVG
```
https://static.worksmobile.net/static/calendar/2023/sp_cal_2019_9698727f.svg
```
사용법: `background: url(...) no-repeat; background-position: Xpx Ypx; width: 16px; height: 16px;`

### 스프라이트 아이콘 좌표 (일정 만들기 모달)
```css
.item_title_date::before          { background-position: -228px -259px; }
.item_title_calendar::before      { background-position: -284px -175px; }
.item_title_attendant::before     { background-position: -172px -259px; }
.item_title_video_meeting::before { background-position: -172px -287px; }
.item_title_resource::before      { background-position: -116px -287px; }
.item_title_place::before         { background-position: -148px -215px; }
.item_title_memo::before          { background-position: -200px -259px; }
.item_title_attach::before        { background-position: -228px -175px; }
.item_title_security::before      { background-position: -60px -287px; }
.item_title_category::before      { background-position: -256px -259px; }
.item_title_notify::before        { background-position: -204px -215px; }
.item_title_status::before        { background-position: -256px -175px; }
```

### 색상 변수 (calendar.html :root)
```css
--cal-purple: #744DC8;
--cal-blue: #4B84D9;
--cal-orange: #F9A826;
--cal-teal: #38A23A;
--sunday-red: #F35055;
--ai-blue-bg: #E8F2FF;
--ai-green-bg: #E8F8EF;
```

## calendar.html 구조 요약

### GNB (상단)
- 클래스: `workscmn_header` (높이 58px)
- WORKS 로고, 서비스 아이콘들(`workscmn_service`), 설정 버튼들(`workscmn_setting_area`)
- GNB 디자인 레퍼런스: https://works-ai-v3.vercel.app/index.html

### SNB (좌측 사이드바)
- 클래스: `nav_lnb` (폭 250px, 배경 `#F9FAFC`)
- 구성: `core_button`(일정만들기), `mini_calender`(table 구조), `menu_box`/`head_bar`/`lnb_tree`/`menu_item`/`ck_box calendar_color_*`
- 캘린더 색상 체크박스: `calendar_color_11`(보라), `color_32`(초록) 등

### 캘린더 그리드
- 2026년 4월, 오늘=24일 (검정 원)
- 이벤트 바: `ep-green`(연초록), `ep-purple`(연보라) 파스텔 스타일

### 일정 만들기 모달 (`write_schedule`)
- 폭 1160px, 2컬럼 레이아웃
- 좌측: `ws-schedule-cover` — 폼 필드들
  - 제목 인풋: `title-input-main` (hover시 점선 border, 26px)
  - hover/click 시 추천 키워드 칩 등장 (`kwFadeIn` 애니메이션, ✦ sparkle 아이콘)
  - **참석자 행이 날짜 위에 위치** (순서 중요)
  - 참석자 선택 → 우측 패널에 추천 시간대 표시
- 우측: `ws-detail-box` — 추천 시간 패널
  - 참석자 없을 때: `wsRecoEmpty` (비어있음 상태)
  - 참석자 추가 시: `wsRecoList` (추천 슬롯 목록)

### 주요 JS 함수
```js
wsAddAttendee(name, avatar)  // 참석자 추가 → 추천 시간 업데이트
wsPickSlot(el)               // 추천 시간 슬롯 선택
onTitleFocus()               // 제목 클릭/포커스 → 키워드 칩 표시
renderAttendeeChips()        // 참석자 칩 렌더링
```

## 작업 히스토리 요약
1. 기본 캘린더 UI 구축
2. GNB → `workscmn_header` 실제 WORKS 스타일로 교체
3. SNB → `nav_lnb` 실제 WORKS 스타일로 교체 (mini calendar table, 캘린더 색상 체크박스)
4. 일정 만들기 모달 → `make_calendar.htm` 레퍼런스 기반 2컬럼 레이아웃으로 재구성
5. 제목 인풋 hover 점선 + 키워드 추천 칩 (`kwFadeIn` 애니메이션)
6. 참석자 행을 날짜 위로 이동, 참석자 추가 시 우측 패널 추천 시간 연동
7. 프로필 사진 교체 (`assets/profile-me.jpg`)

## 새 컴퓨터 셋업 체크리스트
1. `git clone https://github.com/mihakism/WORKS-ai.git`
2. `/Users/user/Documents/WORKS_calendar_files/` 폴더를 USB/AirDrop으로 복사 (레퍼런스 파일들)
3. Claude Code에서 `/Users/user/Documents/WORKS-ai` 열기
4. 이 `CLAUDE.md` 파일이 맥락을 바로 설명해줌
5. 미리보기: `python3 -m http.server 8090 --directory .` 후 http://localhost:8090/calendar.html

## 주요 결정사항 / 규칙
- 빌드 도구 없음, 모든 것이 `calendar.html` 한 파일에 인라인
- 외부 리소스는 CDN/정적URL만 사용 (로컬 CSS 파일 참조 없음)
- 참조 파일(`WORKS_calendar_files/`)은 git에 포함하지 않음 (회사 내부 리소스)
- Pretendard Variable 폰트 필수
