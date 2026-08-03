import pytest
from fastapi.testclient import TestClient

from flow_app.main import app


@pytest.fixture()
def client():
    with TestClient(app) as test_client:
        yield test_client
