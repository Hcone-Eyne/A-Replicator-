from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .api.routers import auth, categories, listings, messages, notifications, orders, profiles
from .config import settings

app = FastAPI(
    title="Flow App API",
    version="1.0.0",
    description="Backend for the Flow marketplace app. Serves MySQL data to the Flutter client.",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[origin.strip() for origin in settings.cors_origins.split(",")],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(listings.router)
app.include_router(categories.router)
app.include_router(profiles.router)
app.include_router(orders.router)
app.include_router(messages.router)
app.include_router(notifications.router)


@app.get("/")
def root():
    return {"app": "Flow App API", "status": "ok"}
