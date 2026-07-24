from fastapi.testclient import TestClient

from g_taps_api.main import app

client = TestClient(app)


def test_health() -> None:
    response = client.get("/api/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_meta() -> None:
    response = client.get("/api/meta")
    assert response.status_code == 200
    body = response.json()
    assert body["goal"] == "hallucination-zero"
