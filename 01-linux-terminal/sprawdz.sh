#!/usr/bin/env bash
# Strażnik modułu 1. Użycie (z głównego folderu repozytorium): bash 01-linux-terminal/sprawdz.sh <srodowisko|struktura|logi|path|wszystko>
# W folderze modułu: bash sprawdz.sh <zadanie>. Ścieżki liczy od własnego położenia, nie od bieżącego katalogu.

# Uruchomiony przez sh (np. sh sprawdz.sh) przechodzi do basha.
[ -n "$BASH_VERSION" ] || exec bash "$0" "$@"

MOD="$(dirname "$(realpath "$0")")"
REPO="$(dirname "$MOD")"
BRAKI=0

brak() { echo "Brakuje: $*"; BRAKI=$((BRAKI + 1)); }
info() { echo "Info: $*"; }

# ---------------------------------------------------------------- srodowisko
zadanie_srodowisko() {
  local nvm_sh="" kat
  for kat in "${NVM_DIR:-}" /usr/local/share/nvm "$HOME/.nvm"; do
    if [[ -n "$kat" && -s "$kat/nvm.sh" ]]; then nvm_sh="$kat/nvm.sh"; break; fi
  done

  if [[ -z "$nvm_sh" ]]; then
    brak "nvm (nie znaleziono pliku nvm.sh ani w NVM_DIR, ani w katalogu domowym)"
  elif ! bash -c 'source "$1" >/dev/null 2>&1; type nvm >/dev/null 2>&1' _ "$nvm_sh"; then
    brak "działającego nvm (po wczytaniu nvm.sh polecenie nvm nie istnieje)"
  fi

  local wersja
  wersja="$(bash -c 'if [[ -n "$1" ]]; then source "$1" >/dev/null 2>&1; fi; node -v 2>/dev/null' _ "$nvm_sh")"
  if [[ -z "$wersja" ]]; then
    brak "Node.js (polecenie node nie działa)"
  else
    local major="${wersja#v}"; major="${major%%.*}"
    if [[ ! "$major" =~ ^[0-9]+$ || "$major" -lt 24 ]]; then
      brak "Node.js w wersji 24 lub nowszej (masz $wersja)"
    fi
  fi

  local npmv
  npmv="$(bash -c 'if [[ -n "$1" ]]; then source "$1" >/dev/null 2>&1; fi; npm -v 2>/dev/null' _ "$nvm_sh")"
  [[ -n "$npmv" ]] || brak "npm (polecenie npm nie działa)"

  git --version >/dev/null 2>&1 || brak "Gita (polecenie git nie działa)"

  if command -v code >/dev/null 2>&1; then
    info "polecenie code (VS Code) jest dostępne"
  else
    info "polecenia code nie ma w terminalu. W Codespaces to normalne, w WSL uruchom VS Code z Windows i połącz go z WSL"
  fi
}

# ---------------------------------------------------------------- struktura
zadanie_struktura() {
  local s="$MOD/struktura" d
  if [[ ! -d "$s" ]]; then
    brak "folder 01-linux-terminal/struktura"
    return
  fi
  for d in portfolio/css portfolio/js portfolio/img; do
    [[ -d "$s/$d" ]] || { brak "folder struktura/$d"; continue; }
    [[ -e "$s/$d/.gitkeep" ]] || brak "plik .gitkeep w folderze struktura/$d (bez niego Git nie zapisze pustego folderu)"
  done
  [[ -f "$s/portfolio/index.html" ]] || brak "plik struktura/portfolio/index.html"

  if [[ ! -f "$s/notatki/linux.txt" ]]; then
    brak "plik struktura/notatki/linux.txt"
  else
    local n
    n="$(grep -c '[^[:space:]]' "$s/notatki/linux.txt")"
    [[ "$n" -ge 5 ]] || brak "co najmniej 5 niepustych linii w notatki/linux.txt (jest $n)"
  fi

  local st="$s/skrypty/start.sh"
  if [[ ! -f "$st" ]]; then
    brak "plik struktura/skrypty/start.sh"
    return
  fi
  local prawa
  prawa="$(stat -c %A "$st")"
  if [[ "${prawa:0:4}" != "-rwx" ]]; then
    brak "prawa do wykonywania dla właściciela pliku start.sh (teraz: ${prawa:0:4})"
    return
  fi
  local wynik oczekiwany
  wynik="$(cd "$s/skrypty" && timeout 10 ./start.sh 2>&1)"
  oczekiwany="$(cd "$s/skrypty" && pwd)"
  [[ "$wynik" == *"Start kursu"* ]] || brak "w wyniku start.sh tekstu: Start kursu"
  if ! grep -qxF "$oczekiwany" <<<"$wynik"; then
    brak "w wyniku start.sh osobnej linii z bieżącym katalogiem (pwd)"
  fi
}

# ---------------------------------------------------------------- logi
# Uruchamia funkcję z polecenia.sh w folderze modułu i wypisuje jej standardowe wyjście.
# Drugi argument (opcjonalny): folder roboczy zamiast folderu modułu.
uruchom_funkcje() {
  (cd "${2:-$MOD}" && timeout 20 bash -c 'source "$3" >/dev/null 2>&1; "$1"' _ "$1" "" "$MOD/polecenia.sh" 2>/dev/null)
}

funkcja_istnieje() {
  (cd "$MOD" && bash -c 'source ./polecenia.sh >/dev/null 2>&1; declare -F "$1" >/dev/null' _ "$1")
}

porownaj_wyniki() { # nazwa, wynik, oczekiwany
  if [[ "$2" != "$3" ]]; then
    brak "poprawnego wyniku funkcji $1 (wypisała: \"${2:0:80}\")"
  fi
}

zadanie_logi() {
  local log="$MOD/dane/serwer.log"
  if [[ ! -f "$log" || ! -d "$MOD/dane/strona" ]]; then
    brak "plików startowych w folderze dane (serwer.log i strona). Przywróć je z repozytorium"
    return
  fi
  if [[ ! -f "$MOD/polecenia.sh" ]]; then
    brak "pliku polecenia.sh w folderze modułu"
    return
  fi
  if ! bash -n "$MOD/polecenia.sh" 2>/dev/null; then
    brak "poprawnej składni w polecenia.sh (bash zgłasza błąd)"
    return
  fi
  local f
  for f in ile_404 najczestszy_ip pliki_css duze_pliki zapisz_bledy dopisz_raport; do
    funkcja_istnieje "$f" || brak "funkcji $f w polecenia.sh"
  done

  local wynik oczekiwany

  if funkcja_istnieje ile_404; then
    wynik="$(uruchom_funkcje ile_404 | tr -d '[:space:]')"
    oczekiwany="$(awk '$9 == 404' "$log" | wc -l | tr -d '[:space:]')"
    porownaj_wyniki ile_404 "$wynik" "$oczekiwany"
  fi

  if funkcja_istnieje najczestszy_ip; then
    wynik="$(uruchom_funkcje najczestszy_ip)"
    oczekiwany="$(awk '{c[$1]++} END {for (i in c) if (c[i] > m) {m = c[i]; b = i}; print b}' "$log")"
    if [[ "$(grep -cE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' <<<"$wynik")" -ne 1 ]] || ! grep -qwF "$oczekiwany" <<<"$wynik"; then
      brak "poprawnego wyniku funkcji najczestszy_ip (ma wypisać dokładnie jeden adres, ten najczęstszy)"
    fi
  fi

  if funkcja_istnieje pliki_css; then
    wynik="$(uruchom_funkcje pliki_css | sed 's|.*/||' | sort)"
    oczekiwany="$(find "$MOD/dane/strona" -type f -name '*.css' -printf '%f\n' | sort)"
    porownaj_wyniki pliki_css "$wynik" "$oczekiwany"
  fi

  if funkcja_istnieje duze_pliki; then
    wynik="$(uruchom_funkcje duze_pliki | sed 's|.*/||' | sort)"
    oczekiwany="$(find "$MOD/dane/strona" -type f -size +20480c -printf '%f\n' | sort)"
    porownaj_wyniki duze_pliki "$wynik" "$oczekiwany"
  fi

  # Funkcje zapisujące pliki uruchamiamy na tymczasowej kopii folderu dane, więc Twoje pliki zostają nietknięte.
  local tmp
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  cp -a "$MOD/dane" "$tmp/dane"
  rm -f "$tmp/dane/bledy.txt" "$tmp/dane/raport.txt"

  if funkcja_istnieje zapisz_bledy; then
    uruchom_funkcje zapisz_bledy "$tmp" >/dev/null
    if [[ ! -f "$tmp/dane/bledy.txt" ]]; then
      brak "pliku dane/bledy.txt po uruchomieniu funkcji zapisz_bledy"
    elif ! cmp -s "$tmp/dane/bledy.txt" <(awk '$9 == 404 || $9 == 500' "$log"); then
      brak "poprawnej zawartości dane/bledy.txt po uruchomieniu funkcji zapisz_bledy"
    fi
  fi

  if funkcja_istnieje dopisz_raport; then
    printf 'Raport serwera\n' >"$tmp/dane/raport.txt"
    uruchom_funkcje dopisz_raport "$tmp" >/dev/null
    local linie
    linie="$(wc -l <"$log" | tr -d '[:space:]')"
    if [[ "$(head -n 1 "$tmp/dane/raport.txt")" != "Raport serwera" ]]; then
      brak "dopisywania w funkcji dopisz_raport (stara zawartość raport.txt zniknęła)"
    elif ! tail -n 1 "$tmp/dane/raport.txt" | grep -qw "$linie" || [[ "$(wc -l <"$tmp/dane/raport.txt")" -ne 2 ]]; then
      brak "w funkcji dopisz_raport jednej nowej linii z liczbą linii pliku serwer.log"
    fi
  fi
}

# ---------------------------------------------------------------- path
zadanie_path() {
  local w="$HOME/bin/witaj"
  if [[ ! -f "$w" ]]; then
    brak "skryptu ~/bin/witaj"
  elif [[ ! -x "$w" ]]; then
    brak "prawa do wykonywania dla ~/bin/witaj"
  fi
  [[ -f "$HOME/.bashrc" ]] || { brak "pliku ~/.bashrc"; return; }

  # Czyste środowisko: bez ~/bin w PATH i bez zmiennej, żeby sprawdzić tylko to, co daje .bashrc.
  local czysty wynik
  czysty="$(tr ':' '\n' <<<"$PATH" | grep -vxF "$HOME/bin" | paste -sd: -)"
  wynik="$(env -u KURS_KATALOG PATH="$czysty" timeout 30 bash -ic '
    echo "@@W=$(command -v witaj)"
    echo "@@K=$KURS_KATALOG"
    echo "@@O=$(witaj 2>&1)"
    echo "@@N=$(node -v 2>&1)"
    echo "@@P=$PATH"
  ' 2>/dev/null </dev/null)"
  local sciezka katalog powitanie wersja nowy_path
  sciezka="$(sed -n 's/^@@W=//p' <<<"$wynik")"
  katalog="$(sed -n 's/^@@K=//p' <<<"$wynik")"
  powitanie="$(sed -n 's/^@@O=//p' <<<"$wynik")"
  wersja="$(sed -n 's/^@@N=//p' <<<"$wynik")"
  nowy_path="$(sed -n 's/^@@P=//p' <<<"$wynik")"

  # Częste pomyłki w ~/.bashrc: PATH bez :$PATH na końcu i tylda w cudzysłowie (nie jest rozwijana).
  if [[ -n "$wynik" ]] && ! tr ':' '\n' <<<"$nowy_path" | grep -qxF /usr/bin; then
    brak "w PATH ustawionym przez ~/.bashrc katalogów systemowych (/usr/bin): linia z PATH ma kończyć się :\$PATH, żeby dopisać ~/bin do listy, a nie ją zastąpić (naprawa: README, zadanie 4)"
  fi
  if tr ':' '\n' <<<"$nowy_path" | grep -q '^~'; then
    info "w PATH jest katalog z tyldą w cudzysłowie (np. \"~/bin\"). Bash go rozumie, ale inne programy nie: bezpieczniej zapisać \$HOME/bin"
  fi
  [[ "$sciezka" == "$HOME/bin/witaj" ]] || brak "~/bin w PATH ustawionego w ~/.bashrc (nowy terminal nie widzi polecenia witaj)"
  if [[ -z "$katalog" ]]; then
    brak "wyeksportowanej zmiennej KURS_KATALOG w ~/.bashrc"
  elif [[ "$katalog" == "~"* ]]; then
    brak "w KURS_KATALOG rozwiniętej ścieżki: jest \"${katalog:0:60}\", bo tylda w cudzysłowie nie jest rozwijana (użyj \$HOME)"
  elif [[ "$(realpath "$katalog" 2>/dev/null)" != "$(realpath "$REPO")" ]]; then
    brak "w KURS_KATALOG ścieżki do głównego folderu Twojego repozytorium kursu"
  fi
  if [[ -n "$sciezka" && "$powitanie" != "Cześć, ${USER:-$(id -un)}! Node: $wersja" ]]; then
    brak "wyniku witaj w formacie: Cześć, <użytkownik>! Node: <wersja> (wypisało: \"${powitanie:0:80}\")"
  fi
}

# ---------------------------------------------------------------- start
uruchom() {
  local nazwa="$1" przed="$BRAKI"
  echo "== $nazwa =="
  "zadanie_$nazwa"
  if [[ "$BRAKI" -eq "$przed" ]]; then echo "OK: zadanie $nazwa zaliczone"; else echo "Nie zaliczone: $nazwa"; fi
}

case "${1:-}" in
  srodowisko | struktura | logi | path) uruchom "$1" ;;
  wszystko) for z in srodowisko struktura logi path; do uruchom "$z"; done ;;
  *)
    echo "Użycie (z głównego folderu repozytorium): bash 01-linux-terminal/sprawdz.sh <srodowisko|struktura|logi|path|wszystko>"
    echo "W folderze modułu 01-linux-terminal: bash sprawdz.sh <zadanie>"
    exit 2
    ;;
esac

[[ "$BRAKI" -eq 0 ]]
