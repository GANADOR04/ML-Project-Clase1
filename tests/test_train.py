from pathlib import Path

from src.app.train import load_cfg, main


def test_load_cfg():
    cfg = load_cfg()
    assert "seed" in cfg
    assert "test_size" in cfg
    assert "max_depth" in cfg
    assert 0.0 < cfg["test_size"] < 1.0


def test_training_pipeline(tmp_path, monkeypatch):
    # Asegurar que corre sin errores
    main()
    runs_dir = Path("runs")
    assert runs_dir.exists()
    latest_run = max(runs_dir.iterdir(), key=lambda p: p.stat().st_mtime)
    assert (latest_run / "model.joblib").exists()
    assert (latest_run / "metrics.json").exists()
