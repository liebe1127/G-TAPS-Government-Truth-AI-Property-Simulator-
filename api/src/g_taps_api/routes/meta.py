from fastapi import APIRouter

router = APIRouter(tags=["meta"])


@router.get("/api/meta")
def meta() -> dict[str, object]:
    return {
        "name": "G-TAPS",
        "goal": "hallucination-zero",
        "data_policy": "cite_government_sources_or_declare_unavailable",
    }
