from pathlib import Path

s = Path(__file__).resolve()

print(s)

print(s.parent.parent)
