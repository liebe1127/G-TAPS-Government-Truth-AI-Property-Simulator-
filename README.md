![고신뢰 부동산 의사결정 AI 시뮬레이터 - 가이드라인 인포그래픽](./가이드라인인포그래픽.png)

# G-TAPS — Government Truth AI Property Simulator

대한민국 최신 공식 부동산 정책(대출, 세금 등)을 바탕으로, 사용자의 **매수·매도 의사결정**을 돕는 고신뢰성 AI 시뮬레이터입니다.

## 왜 만드나요?

부동산 관련 AI 답변은 시세·세금·규제 수치를 지어내거나, 이미 바뀐 정책을 최신인 것처럼 말하는 경우가 많습니다.

G-TAPS는 그 위험을 줄이기 위해 **무작위 웹 스크래핑을 배제**하고, 정부 공식 기관의 원천 데이터(Ground Truth)만 쓰는 RAG 파이프라인을 목표로 합니다.

> **핵심 원칙: 할루시네이션 ZERO**  
> 원천에 없는 내용은 추측하지 않고, “데이터 없음 / 확인 불가”로 처리합니다.  
> 응답에는 출처(기관·데이터셋·기준일)를 명시합니다.

## 무엇을 하나요?

사용자가 상황(예: “서울 2주택자인데 하나 팔까?”)을 입력하면,

1. 쿼리 의도를 분석해 **최신·확정 정책**만 걸러 검색하고
2. 그 근거를 Context로 삼아 **예상 세액·대출 한도** 등을 계산하며
3. 매수/매도 관점의 시뮬레이션 결과를 제시합니다

## 어떤 데이터를 쓰나요?

| 구분 | 원천 | 예시 |
|------|------|------|
| 법령 | 국가법령정보센터 ([law.go.kr](https://www.law.go.kr)) Open API | 세법, 주택법 |
| 정책 보도자료 | 국토교통부, 기획재정부, 금융위원회 공식 게시판 | HWP/HWPX·PDF 등 |
| 시장·거시 지표 | 공공데이터포털 ([data.go.kr](https://www.data.go.kr)), 한국은행 ECOS | 실거래가, 기준금리·주담대 금리 |

## 어떻게 동작하나요?

1. **데이터 수집** — 법령 API, 부처 보도자료, 공공·한은 지표를 수집  
2. **추출·전처리** — HWP/HWPX에서 텍스트를 추출하고, 문서 구조(섹션·정책 항목) 기준으로 의미 기반 청킹  
3. **Vector DB + 메타데이터** — 시행일·상태(확정/예고)·부처·정책 분류 등을 주입해, 시간·상태 필터로 정책 충돌을 방지  
4. **AI 시뮬레이션** — 필터를 통과한 청크만으로 세금·대출·매수/매도 전략을 산출

자세한 설계·스택 후보·To-Do는 [`개발_가이드라인.md`](./개발_가이드라인.md)를 참고하세요.

## 기술 방향

- **확정:** Cursor, Python (수집·HWP 파싱·RAG), HWPX는 `zipfile`+XML / HWP는 `pyhwp` 등
- **검토 중:** Vector DB(Pinecone / Milvus / Qdrant), RAG 프레임워크(LangChain / LlamaIndex), 클라우드(GCP / AWS), UI(React 계열 또는 Streamlit·Gradio)

## 개발 셋업

현재 레포에는 `web/`(Vite + React)과 `api/`(FastAPI) 스캐폴드가 포함되어 있습니다. 에이전트 작업 안내는 [`AGENTS.md`](./AGENTS.md)를 보세요.

```bash
bash .cursor/install.sh
npm run dev:api   # http://localhost:8000
npm run dev       # http://localhost:3000
```

| Path | Role |
|------|------|
| `web/` | Vite + React UI |
| `api/` | FastAPI backend |
| `.cursor/` | Cloud Agent 환경 |

이 레포는 Cursor Cloud Agents용 환경이 포함되어 있습니다.

- `.cursor/environment.json` — Cloud Agent 환경 정의
- `.cursor/Dockerfile` — 베이스 이미지 (Node 22 + Python 3.12 + uv)
- `.cursor/install.sh` — 의존성 갱신 스크립트

시크릿(API 키 등)은 레포에 넣지 말고 [Cursor Cloud Agents Secrets](https://cursor.com/dashboard/cloud-agents)에 등록하세요.
