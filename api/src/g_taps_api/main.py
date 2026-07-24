from fastapi import FastAPI

from g_taps_api.routes import health, meta

app = FastAPI(
    title="G-TAPS API",
    description="Government Truth AI Property Simulator API",
    version="0.1.0",
)

app.include_router(health.router)
app.include_router(meta.router)
