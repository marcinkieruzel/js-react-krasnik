![Logotypy: Fundusze Europejskie dla Lubelskiego, Rzeczpospolita Polska, Dofinansowane przez Unię Europejską, Lubelskie](../materialy/logotypy-fe.png)

Projekt „Kształcenie zawodowe – nowe perspektywy” współfinansowany ze środków Europejskiego Funduszu Społecznego Plus w ramach programu Fundusze Europejskie dla Lubelskiego 2021–2027

# Moduł 1. Linux — praca w terminalu

Cztery zadania na łącznie 4 godziny. Po nich masz gotowe środowisko pracy, folder projektu kursowego i pierwsze skrypty w bashu. Teorię masz w prezentacji tego modułu.

Wszystkie polecenia wpisujesz w terminalu WSL (Ubuntu) albo w terminalu Codespaces. Folder repozytorium to u Ciebie `~/kurs/js-react-krasnik` (w Codespaces: `/workspaces/js-react-krasnik`). Polecenia `cd` w przykładach zakładają, że stoisz w głównym folderze repozytorium.

## Jak sprawdzić swoją pracę

Po każdym zadaniu uruchom strażnika. Możesz to zrobić z dowolnego folderu:

```bash
bash 01-linux-terminal/sprawdz.sh <zadanie>
```

Zamiast `<zadanie>` wpisz: `srodowisko`, `struktura`, `logi`, `path` albo `wszystko`. Strażnik mówi, czego brakuje (linie `Brakuje: ...`). Nie podaje gotowych poleceń, bo to Ty masz je znaleźć. Gdy wszystko jest dobrze, wypisuje `OK` i kończy się kodem 0. Strażnik nie zmienia Twoich plików.

Wskazówki, gdy utkniesz: `man polecenie`, `polecenie --help`, notatki z prezentacji.

---

## Zadanie 1. Środowisko pracy (ok. 1 h)

**Cel.** Masz w terminalu działające: nvm, Node.js 24, npm i Git.

**Kroki.**

1. Zainstaluj WSL 2 z Ubuntu (Windows) albo otwórz repozytorium w Codespaces. W Codespaces nvm, Node i Git są już gotowe, więc przejdź do sprawdzenia.
2. Zainstaluj nvm i przez niego Node.js w wersji 24 (polecenia z głównego README). Zamknij i otwórz terminal.
3. Zainstaluj VS Code. W WSL otwórz go tak, żeby był połączony z Ubuntu. W Codespaces jest wbudowany.
4. Sprawdź wersje: Node, npm i Git.

**Oczekiwany wynik.** Wersje wyglądają podobnie do tych (numery mogą być nowsze):

```text
uczen@pracownia:~$ node -v
v24.18.0
uczen@pracownia:~$ npm -v
11.6.2
uczen@pracownia:~$ git --version
git version 2.43.0
```

**Sprawdzenie.**

```bash
bash 01-linux-terminal/sprawdz.sh srodowisko
```

Brak polecenia `code` to tylko informacja, nie błąd. Strażnik szuka nvm w `$NVM_DIR`, w `/usr/local/share/nvm` (Codespaces) i w `~/.nvm` (WSL).

---

## Zadanie 2. Struktura projektu kursowego (ok. 1 h)

**Cel.** Budujesz w terminalu szkielet projektu, z którego będziesz korzystać w kolejnych modułach. Używasz tylko terminala, bez myszki.

**Dane startowe.** Nic nie ma. Wszystko tworzysz w folderze `01-linux-terminal/struktura/` (dzięki temu zapiszesz to w Gicie i autor może to ocenić).

**Utwórz** takie drzewo:

```text
struktura/
├── portfolio/
│   ├── css/
│   ├── js/
│   ├── img/
│   └── index.html
├── notatki/
│   └── linux.txt
└── skrypty/
    └── start.sh
```

Wymagania:

- `index.html` może być pusty.
- Git nie zapisuje pustych folderów. Dlatego w `css`, `js` i `img` utwórz pusty plik `.gitkeep`. Strażnik to sprawdza.
- `notatki/linux.txt` ma co najmniej 5 niepustych linii. Zapisz w nich własnymi słowami 5 poleceń, które poznałaś w module.
- `skrypty/start.sh` jest skryptem basha. Wypisuje tekst `Start kursu`, a w następnej linii bieżący katalog (`pwd`). Ma prawo wykonywania dla właściciela, więc uruchamiasz go jako `./start.sh`.

**Oczekiwany wynik.** Gdy wejdziesz do folderu `skrypty`, skrypt działa tak (ścieżka u Ciebie będzie inna):

```text
uczen@pracownia:~/kurs/js-react-krasnik/01-linux-terminal/struktura/skrypty$ ./start.sh
Start kursu
/home/uczen/kurs/js-react-krasnik/01-linux-terminal/struktura/skrypty
uczen@pracownia:~/kurs/js-react-krasnik/01-linux-terminal/struktura/skrypty$ ls -l start.sh
-rwxr-xr-x 1 uczen uczen 38 lis 14 10:00 start.sh
```

**Sprawdzenie.**

```bash
bash 01-linux-terminal/sprawdz.sh struktura
```

---

## Zadanie 3. Analiza logów (ok. 1,5 h)

**Cel.** Wyciągasz informacje z logu serwera i ze struktury plików strony, używając `grep`, `find`, `sort`, `uniq`, `wc`, potoków (`|`) i przekierowań (`>`, `>>`).

**Dane startowe.**

- `dane/serwer.log` to 2000 linii logu w formacie Common Log Format. Przykład jednej linii:

```text
192.168.1.48 - - [12/Nov/2026:08:00:34 +0100] "GET /js/menu.js HTTP/1.1" 200 64955
```

  Pola to kolejno: adres IP, dwa myślniki, data, żądanie, kod odpowiedzi (tu 200) i rozmiar.
- `dane/strona/` to drzewo kilkudziesięciu plików strony (HTML, CSS, JS, obrazy, dokumenty).
- `polecenia.sh` zawiera 6 pustych funkcji z opisami w komentarzach.

**Napisz** ciała 6 funkcji w `polecenia.sh`. Każda to jedno polecenie albo jeden potok:

| Funkcja | Co robi |
| --- | --- |
| `ile_404` | wypisuje liczbę linii logu z kodem 404 |
| `najczestszy_ip` | wypisuje najczęstszy adres IP |
| `pliki_css` | wypisuje ścieżki plików `.css` z `dane/strona` |
| `duze_pliki` | wypisuje pliki z `dane/strona` większe niż 20 KB |
| `zapisz_bledy` | zapisuje linie z kodem 404 lub 500 do `dane/bledy.txt` (przekierowanie `>`) |
| `dopisz_raport` | dopisuje do `dane/raport.txt` linię `Linie w logu: <liczba>` (przekierowanie `>>`) |

Uwaga: nazwa pliku z `.css` w środku (na przykład `styl.css.bak`) nie jest plikiem CSS.

**Oczekiwany wynik.** Funkcje uruchamiasz z folderu modułu. Liczby u Ciebie wyjdą takie, jakie są w danych. Kształt wyniku:

```text
uczen@pracownia:~/kurs/js-react-krasnik/01-linux-terminal$ source polecenia.sh
uczen@pracownia:~/kurs/js-react-krasnik/01-linux-terminal$ ile_404
<jedna liczba>
uczen@pracownia:~/kurs/js-react-krasnik/01-linux-terminal$ najczestszy_ip
<liczba powtórzeń i adres IP, np. "  123 192.168.x.x">
uczen@pracownia:~/kurs/js-react-krasnik/01-linux-terminal$ pliki_css
dane/strona/css/...css
...
uczen@pracownia:~/kurs/js-react-krasnik/01-linux-terminal$ zapisz_bledy
uczen@pracownia:~/kurs/js-react-krasnik/01-linux-terminal$ head -n 2 dane/bledy.txt
<dwie pierwsze linie logu z kodem 404 lub 500>
uczen@pracownia:~/kurs/js-react-krasnik/01-linux-terminal$ dopisz_raport
uczen@pracownia:~/kurs/js-react-krasnik/01-linux-terminal$ cat dane/raport.txt
Linie w logu: 2000
```

**Sprawdzenie.** Strażnik sam liczy poprawne odpowiedzi z danych i porównuje je z tym, co wypisują Twoje funkcje:

```bash
bash 01-linux-terminal/sprawdz.sh logi
```

---

## Zadanie 4. Własne polecenie w PATH (ok. 0,5 h)

**Cel.** Masz własne polecenie `witaj`, które działa w każdym nowym terminalu, oraz zmienną z lokalizacją Twojego repozytorium.

**Kroki.**

1. Utwórz folder `~/bin` i w nim skrypt `witaj` z prawem wykonywania. Skrypt wypisuje: `Cześć, <Twój użytkownik>! Node: <wersja Node>`. Użytkownika weź ze zmiennej `$USER`, a wersję z polecenia `node -v`.
2. W pliku `~/.bashrc` dopisz dwie linie: dodanie `~/bin` do `PATH` oraz wyeksportowanie zmiennej `KURS_KATALOG`, która wskazuje główny folder Twojego repozytorium (czyli `~/kurs/js-react-krasnik`, a w Codespaces `/workspaces/js-react-krasnik`).
3. Otwórz nowy terminal (albo wczytaj plik poleceniem `source ~/.bashrc`).

**Oczekiwany wynik.**

```text
uczen@pracownia:~$ witaj
Cześć, uczen! Node: v24.18.0
uczen@pracownia:~$ echo $KURS_KATALOG
/home/uczen/kurs/js-react-krasnik
uczen@pracownia:~$ command -v witaj
/home/uczen/bin/witaj
```

**Sprawdzenie.** Strażnik uruchamia nowy, czysty terminal i patrzy, co daje Twój `~/.bashrc`:

```bash
bash 01-linux-terminal/sprawdz.sh path
```

---

## Na koniec

Uruchom wszystkie sprawdzenia naraz:

```bash
bash 01-linux-terminal/sprawdz.sh wszystko
```

Potem zapisz pracę w Gicie i wyślij do swojego forka (instrukcja w głównym README, sekcja „Jak oddać zadanie”). W module 2 wrócisz do folderu `struktura`.
