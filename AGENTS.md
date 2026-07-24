# AGENTS.md — G-TAPS

정부 원천 데이터 기반 부동산 매수/매도 AI 시뮬레이터.
핵심 목표: **할루시네이션 ZERO** — 주장·수치·근거는 검증 가능한 정부 원천 데이터에만 의존한다.

## Project goals

- 매수/매도 의사결정을 돕는 시뮬레이터
- 응답에 출처(기관·데이터셋·기준일)를 명시
- 원천에 없는 내용은 추측하지 않고 "데이터 없음 / 확인 불가"로 처리

## Stack (initial)

- Node.js 22 + pnpm/npm (프론트·앱 서버)
- Python 3.12 + uv (데이터 파이프라인·분석)
- 기본 포트: web `3000`, api `8000`

스택이 확정되면 이 섹션과 `.cursor/environment.json`을 함께 갱신한다.

## Repo conventions

- 한국어 UI/문서, 코드·커밋 메시지는 영문 또는 한국어 모두 가능 (팀 합의 따름)
- 비밀값(API 키, DB URL 등)은 레포에 커밋하지 않는다 — Cursor Dashboard → Cloud Agents → Secrets 사용
- 정부 데이터 수집 시 이용약관·라이선스·호출 제한을 준수한다

## Cursor Cloud specific instructions

### Environment

- 설정 파일: `.cursor/environment.json`
- 이미지: `.cursor/Dockerfile`
- 의존성 갱신: `bash .cursor/install.sh` (idempotent)
- 현재 레포는 초기 단계라 lockfile/앱 코드가 없을 수 있다. install 스크립트는 매니페스트가 없으면 스킵한다.

### After adding app code

1. Node 앱이면 루트에 `package.json` (+ lockfile) 추가
2. Python 패키지면 `pyproject.toml` 또는 `requirements.txt` 추가
3. 로컬/클라우드에서 `bash .cursor/install.sh`가 성공하는지 확인
4. 실행·테스트 명령을 아래 표에 기입

| Task | Command |
|------|---------|
| Install deps | `bash .cursor/install.sh` |
| Dev web | _(앱 추가 후 기입)_ |
| Dev API | _(앱 추가 후 기입)_ |
| Lint | _(앱 추가 후 기입)_ |
| Test | _(앱 추가 후 기입)_ |

### Secrets (do not commit)

필요한 값이 생기면 Cursor Secrets에만 등록한다. 예:

- `OPENAI_API_KEY` / 모델 제공자 키
- DB·캐시 URL
- 외부 공공 API 키 (있는 경우)

### Data integrity rules for agents

1. 시세·세금·규제·통계를 생성할 때 출처 없는 수치를 만들지 말 것
2. 출처가 불명확하면 답변을 보류하거나 명시적으로 한계를 밝힐 것
3. 스크래핑/수집 코드를 추가할 때 robots·이용약관·개인정보 관련 제약을 확인할 것
