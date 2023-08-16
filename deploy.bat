@echo off
REM 7z a -tzip sample_lcp.lcp content/*.json
typst compile --font-path ./fonts main.typ manual.pdf
pause