mock.patch("app.user_store")
monkeypatch.setattr(service, "load", fake_load)
