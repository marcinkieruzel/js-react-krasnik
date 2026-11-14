#!/usr/bin/env bash
# Strażnik modułu 2. Użycie: bash 02-git-github/sprawdz.sh <repo|konflikt|pr|pages|wszystko> [adres-strony]
# Działa z dowolnego katalogu: ścieżki liczy od własnego położenia. Niczego nie zmienia i nie łączy się z GitHubem
# (wyjątek: zadanie pages pobiera Twoją stronę).

MOD="$(dirname "$(realpath "$0")")"
REPO="$(dirname "$MOD")"
BRAKI=0
export GIT_TERMINAL_PROMPT=0

brak() { echo "Brakuje: $*"; BRAKI=$((BRAKI + 1)); }
info() { echo "Info: $*"; }
g() { git -C "$REPO" "$@" 2>/dev/null; }

# Wzorzec adresu origin przez SSH. Zmienna służy tylko testom strażnika.
ORIGIN_SSH="${KURS_ORIGIN_WZORZEC:-^git@github\.com:}"
ORIGIN_HTTPS='^https://github\.com/'
KURS_REPO='marcinkieruzel/js-react-krasnik'

jest_repo() { g rev-parse --git-dir >/dev/null; }

# ---------------------------------------------------------------- repo
zadanie_repo() {
  if ! command -v git >/dev/null 2>&1; then brak "Gita (polecenie git nie działa)"; return; fi
  if ! jest_repo; then
    brak "repozytorium Git: ten folder nie ma historii Gita. Pracuj w sklonowanym forku, nie w pobranym archiwum"
    return
  fi

  # Tożsamość
  if [[ -z "$(g config user.name)" || -z "$(g config user.email)" ]]; then
    brak "ustawionych w Gicie user.name i user.email (sekcja „Dane do commitów” w głównym README)"
  fi

  # Klucz SSH (w Codespaces niepotrzebny)
  local w_codespaces=0
  [[ "${CODESPACES:-}" == "true" ]] && w_codespaces=1
  if [[ $w_codespaces -eq 0 ]]; then
    compgen -G "$HOME/.ssh/*.pub" >/dev/null || brak "klucza SSH (w folderze ~/.ssh nie ma pliku .pub)"
  fi

  # origin
  local origin
  origin="$(g remote get-url origin)"
  if [[ -z "$origin" ]]; then
    brak "zdalnego repozytorium o nazwie origin (git remote -v nic nie pokazuje). Sklonuj swój fork albo dodaj origin"
  elif [[ "$origin" =~ $ORIGIN_SSH ]]; then
    :
  elif [[ "$origin" =~ $ORIGIN_HTTPS ]]; then
    if [[ $w_codespaces -eq 1 ]]; then
      info "Codespaces: push przez HTTPS działa bez klucza SSH, więc zmiana origin nie jest wymagana"
    else
      echo "Brakuje: Repo sklonowane przez HTTPS — przełącz na SSH: zmień adres zdalnego repozytorium origin na adres SSH swojego forka (zaczyna się od git@github.com:), tym samym poleceniem, które dodaje i zmienia adresy remote."
      BRAKI=$((BRAKI + 1))
    fi
  else
    brak "adresu origin wskazującego na github.com (teraz: ${origin:0:60})"
  fi

  # upstream
  local up
  up="$(g remote get-url upstream)"
  if [[ -z "$up" ]]; then
    brak "zdalnego repozytorium upstream wskazującego na oryginał kursu ($KURS_REPO)"
  elif ! grep -qiF -- "github.com/$KURS_REPO" <<<"$up" && ! grep -qiF -- "github.com:$KURS_REPO" <<<"$up"; then
    brak "upstream wskazującego na oryginał kursu ($KURS_REPO), a nie na ${up:0:60}"
  fi

  # Commity uczestniczki: autor inny niż autor pierwszego (korzeniowego) commitu repozytorium kursu
  if ! g rev-parse --verify -q HEAD >/dev/null; then
    brak "Twojego commita (repozytorium nie ma jeszcze żadnych commitów)"
  else
    local korzen autor liczba
    korzen="$(g rev-list --max-parents=0 HEAD | tail -n 1)"
    autor="$(g log -1 --format=%ae "$korzen")"
    liczba="$(g log --no-merges --format=%ae HEAD | grep -cvxF -- "$autor")"
    [[ "$liczba" -ge 1 ]] || brak "Twojego commita (w historii są tylko commity autora kursu). Zapisz swoje rozwiązania modułu 1 commitem z własnym opisem"
  fi

  # Czyste drzewo
  local brudne
  brudne="$(g status --porcelain | wc -l | tr -d '[:space:]')"
  [[ "$brudne" -eq 0 ]] || brak "zapisania zmian: git status pokazuje niezapisane lub nowe pliki ($brudne). Dodaj je do commita"

  # Śledzenie i wysłanie
  local sledzi
  sledzi="$(g rev-parse --abbrev-ref main@{upstream})"
  if [[ "$sledzi" != "origin/main" ]]; then
    brak "gałęzi main śledzącej origin/main (po pierwszym wysłaniu ustaw śledzenie)"
  else
    local przed
    przed="$(g rev-list --count origin/main..main)"
    [[ "$przed" -eq 0 ]] || brak "wysłania zmian: Twój main ma $przed commit(y) więcej niż origin/main. Wykonaj git push"
  fi
}

# ---------------------------------------------------------------- konflikt
zadanie_konflikt() {
  local plik="$MOD/konflikt/przepis.md"
  if ! jest_repo; then brak "repozytorium Git (ten folder nie ma historii Gita)"; return; fi
  if ! g show-ref --verify --quiet refs/heads/main; then brak "gałęzi main"; return; fi

  local galaz_jest=0
  g show-ref --verify --quiet refs/heads/przepis-babci && galaz_jest=1
  if [[ $galaz_jest -eq 0 ]] && ! g log main --merges --format=%s | grep -q 'przepis-babci'; then
    brak "gałęzi przepis-babci: uruchom skrypt konflikt/przygotuj.sh z folderu modułu"
    return
  fi

  if [[ -e "$(g rev-parse --git-path MERGE_HEAD)" ]]; then
    brak "dokończenia scalania: konflikt nie jest jeszcze zapisany commitem"
  fi

  # Commit scalający z gałęzią przepis-babci na main
  local m scalono=0 tip=""
  [[ $galaz_jest -eq 1 ]] && tip="$(g rev-parse refs/heads/przepis-babci)"
  for m in $(g rev-list --merges main); do
    if [[ -n "$tip" ]] && g merge-base --is-ancestor "$tip" "$m" && ! g merge-base --is-ancestor "$tip" "$m^1"; then scalono=1; break; fi
    if g log -1 --format=%s "$m" | grep -q 'przepis-babci'; then scalono=1; break; fi
  done
  [[ $scalono -eq 1 ]] || brak "scalenia gałęzi przepis-babci do main (na main ma być commit scalający)"

  if [[ ! -f "$plik" ]]; then brak "pliku konflikt/przepis.md"; return; fi
  if grep -qE '^(<<<<<<<|=======$|>>>>>>>)' "$plik"; then
    brak "usunięcia z przepis.md: w pliku nadal są znaczniki konfliktu (linie <<<<<<<, ======= i >>>>>>>)"
  fi
  grep -qxF -- '- 3 łyżki cukru' "$plik" || brak "w przepis.md linii ze zmianą z main (więcej cukru)"
  grep -qxF -- '- 2 łyżki miodu' "$plik" || brak "w przepis.md linii ze zmianą z gałęzi przepis-babci (miód)"
}

# ---------------------------------------------------------------- pr
zadanie_pr() {
  local o="$MOD/o-mnie.md"
  if ! jest_repo; then brak "repozytorium Git (ten folder nie ma historii Gita)"; return; fi
  if ! g show-ref --verify --quiet refs/heads/main; then brak "gałęzi main"; return; fi

  if ! g log main --merges --format=%s | grep -qE '^Merge pull request #[0-9]+ from .*/opis-o-mnie$'; then
    brak "w historii main commitu „Merge pull request #...” z gałęzi opis-o-mnie (scal pull request przyciskiem na GitHubie, a potem pobierz zmiany do lokalnego main)"
  fi
  if [[ ! -f "$o" ]]; then
    brak "pliku 02-git-github/o-mnie.md"
  elif [[ "$(grep -c '[^[:space:]]' "$o")" -lt 3 ]]; then
    brak "co najmniej 3 niepustych linii w o-mnie.md"
  fi
}

# ---------------------------------------------------------------- pages
zadanie_pages() {
  local adres="${1:-}"
  if [[ -z "$adres" ]]; then
    brak "adresu strony: podaj go po nazwie zadania (adres Twojej strony GitHub Pages, zaczyna się od https://)"
    return
  fi
  command -v curl >/dev/null 2>&1 || { brak "polecenia curl"; return; }
  adres="${adres%/}"
  adres="${adres%/02-git-github/strona}"
  local url="$adres/02-git-github/strona/" tresc blad
  blad="$(mktemp)"
  if ! tresc="$(curl -fsS --max-time 15 "$url" 2>"$blad")"; then
    brak "odpowiedzi 200 pod adresem $url ($(tr '\n' ' ' <"$blad" | cut -c1-120)). Sprawdź w Settings → Pages, czy strona jest opublikowana (po zapisaniu trwa to 1-2 minuty)"
    rm -f "$blad"
    return
  fi
  rm -f "$blad"
  grep -qi '<title>' <<<"$tresc" || brak "znacznika <title> na stronie $url"
  if grep -q 'TODO' <<<"$tresc"; then
    brak "uzupełnienia strony: na stronie nadal jest tekst TODO (opublikowana jest wersja ze szkieletu)"
  fi
  local linki
  linki="$(grep -oiE '<a [^>]*href="https?://[^"]+"' <<<"$tresc" | wc -l | tr -d '[:space:]')"
  [[ "$linki" -ge 2 ]] || brak "co najmniej 2 linków (adresów zaczynających się od http) na stronie (jest $linki)"
}

# ---------------------------------------------------------------- start
uruchom() {
  local nazwa="$1" przed="$BRAKI"
  shift
  echo "== $nazwa =="
  "zadanie_$nazwa" "$@"
  if [[ "$BRAKI" -eq "$przed" ]]; then echo "OK: zadanie $nazwa zaliczone"; else echo "Nie zaliczone: $nazwa"; fi
}

case "${1:-}" in
  repo | konflikt | pr) uruchom "$1" ;;
  pages) uruchom pages "${2:-}" ;;
  wszystko)
    for z in repo konflikt pr; do uruchom "$z"; done
    uruchom pages "${2:-}"
    ;;
  *)
    echo "Użycie: bash 02-git-github/sprawdz.sh <repo|konflikt|pr|pages|wszystko> [adres-strony]"
    exit 2
    ;;
esac

[[ "$BRAKI" -eq 0 ]]
