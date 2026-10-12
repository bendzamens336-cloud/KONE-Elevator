from pathlib import Path
import sys
import webview

def resource_path(*parts):
    if getattr(sys, 'frozen', False) and hasattr(sys, '_MEIPASS'):
        base = Path(sys._MEIPASS)
    else:
        base = Path(__file__).resolve().parent
    return base.joinpath(*parts)

index = resource_path('web', 'index.html').resolve()
window = webview.create_window(
    'KONE EcoDisc Elevator',
    index.as_uri(),
    width=1500,
    height=920,
    min_size=(1000, 650),
    resizable=True,
)
webview.start(debug=False)
