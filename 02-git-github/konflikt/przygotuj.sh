#!/usr/bin/env bash
# Przygotowuje zadanie "konflikt": tworzy gałąź przepis-babci ze zmianą w przepis.md
# i sprzeczną zmianę na main. Zmienia tylko plik konflikt/przepis.md.
# Użycie (z głównego folderu repozytorium): bash 02-git-github/konflikt/przygotuj.sh

# Uruchomiony przez sh przechodzi do basha.
[ -n "$BASH_VERSION" ] || exec bash "$0" "$@"

KONF="$(dirname "$(realpath "$0")")"
PLIK="02-git-github/konflikt/przepis.md"
GALAZ="przepis-babci"

stop() { echo "Nie przygotowano zadania: $*"; exit 1; }

REPO="$(git -C "$KONF" rev-parse --show-toplevel 2>/dev/null)" || stop "ten folder nie jest w repozytorium Git."
g() { git -C "$REPO" "$@"; }

[[ -n "$(g config user.name)" && -n "$(g config user.email)" ]] ||
  stop "Git nie zna Twojego imienia i adresu e-mail (sekcja „Dane do commitów” w głównym README)."
[[ "$(g branch --show-current)" == "main" ]] || stop "przełącz się na gałąź main (teraz: $(g branch --show-current))."
if g show-ref --verify --quiet "refs/heads/$GALAZ"; then
  stop "gałąź $GALAZ już istnieje. Zadanie jest już przygotowane: scal ją do main. Żeby zacząć od nowa, usuń gałąź i cofnij zmianę w przepis.md."
fi
[[ -z "$(g status --porcelain)" ]] || stop "masz niezapisane zmiany (git status). Zapisz je commitem, a potem uruchom skrypt ponownie."
[[ -f "$REPO/$PLIK" ]] && grep -qx -- '- 1 łyżka cukru' "$REPO/$PLIK" ||
  stop "plik $PLIK jest zmieniony. Przywróć go z repozytorium."

zmien() { # nowa treść linii z cukrem, komunikat commitu
  sed -i "s/^- 1 łyżka cukru\$/$1/" "$REPO/$PLIK"
  g add -- "$PLIK"
  g commit -q -m "$2" || stop "commit się nie udał."
}

g switch -q -c "$GALAZ" || stop "nie udało się utworzyć gałęzi $GALAZ."
zmien '- 2 łyżki miodu' "Przepis: miód zamiast cukru"
g switch -q main || stop "nie udało się wrócić na main."
zmien '- 3 łyżki cukru' "Przepis: więcej cukru"

echo "Gotowe. Na main i na gałęzi $GALAZ zmieniono tę samą linię w $PLIK."
echo "Teraz scal gałąź $GALAZ do main i rozwiąż konflikt (opis w README modułu)."
