def test_app_metadata():
    from flow_app.main import app

    assert app.title == "Flow App API"
    assert app.version == "1.0.0"


def test_health(client):
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"app": "Flow App API", "status": "ok"}
