# G-TAPS — Government Truth AI Property Simulator

부동산 매수/매도 AI 시뮬레이터입니다.

**목표:** 할루시네이션 ZERO — 정부 원천 데이터 기반 의사결정

## Cursor Cloud

이 레포는 Cursor Cloud Agents용 환경이 포함되어 있습니다.

- `.cursor/environment.json` — Cloud Agent 환경 정의
- `.cursor/Dockerfile` — 베이스 이미지 (Node 22 + Python 3.12 + uv)
- `.cursor/install.sh` — 의존성 갱신 스크립트
- `AGENTS.md` — 에이전트 작업 가이드

## Quick start

```bash
bash .cursor/install.sh
npm run dev:api   # http://localhost:8000
npm run dev       # http://localhost:3000
```

| Path | Role |
|------|------|
| `web/` | Vite + React UI |
| `api/` | FastAPI backend |
| `.cursor/` | Cloud Agent environment |

시크릿(API 키 등)은 레포에 넣지 말고 [Cursor Cloud Agents Secrets](https://cursor.com/dashboard/cloud-agents)에 등록하세요.
