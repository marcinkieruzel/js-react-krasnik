![Logotypy: Fundusze Europejskie dla Lubelskiego, Rzeczpospolita Polska, Dofinansowane przez Unię Europejską, Lubelskie](../materialy/logotypy-fe.png)

Projekt „Kształcenie zawodowe – nowe perspektywy” współfinansowany ze środków Europejskiego Funduszu Społecznego Plus w ramach programu Fundusze Europejskie dla Lubelskiego 2021–2027

# Moduł 2. Git i GitHub

Cztery zadania na łącznie 4 godziny. Po nich Twoje repozytorium kursowe jest połączone z GitHubem kluczem SSH, umiesz rozwiązać konflikt, scalić pull request i opublikować stronę. Teorię masz w prezentacji tego modułu.

Wszystkie polecenia wpisujesz w terminalu WSL (Ubuntu) albo w terminalu Codespaces, w głównym folderze repozytorium (u Ciebie `~/kurs/js-react-krasnik`, w Codespaces `/workspaces/js-react-krasnik`). Fork i klon masz już z modułu 1.

## Jak sprawdzić swoją pracę

Po każdym zadaniu uruchom strażnika. Możesz to zrobić z dowolnego folderu:

```bash
bash 02-git-github/sprawdz.sh <zadanie>
```

Zamiast `<zadanie>` wpisz: `repo`, `konflikt`, `pr`, `pages` albo `wszystko`. Zadanie `pages` wymaga adresu Twojej strony jako drugiego słowa (opis w zadaniu 4), a `wszystko` przyjmuje ten adres tak samo. Strażnik mówi, czego brakuje (linie `Brakuje: ...`), ale nie podaje gotowych poleceń. Gdy wszystko jest dobrze, wypisuje `OK` i kończy się kodem 0. Strażnik niczego nie zmienia i (poza `pages`) nie łączy się z internetem: patrzy tylko na Twoje lokalne repozytorium.

Wskazówki, gdy utkniesz: `git status` (mówi, co się dzieje i co dalej), `git help <polecenie>`, notatki z prezentacji.

Dwie rzeczy, które pomagają przy całym module:

- Gdy `git pull` albo `git merge` otworzy edytor z komunikatem commita (zwykle nano), zapisz i zamknij go: Ctrl+O, Enter, Ctrl+X. Możesz też z góry dopisać `--no-edit`, np. `git pull --no-edit`.
- Gdy coś pójdzie nie tak w trakcie scalania, `git status` pokaże, w którym kroku jesteś. Scalanie można w każdej chwili przerwać poleceniem `git merge --abort` i zacząć od nowa.

---

## Zadanie 1. Repozytorium, klucz SSH i pierwszy commit (ok. 1,5 h)

**Cel.** Twój lokalny klon łączy się z Twoim forkiem przez SSH (bez wpisywania hasła), zna oryginał kursu pod nazwą `upstream` i ma Twój pierwszy commit z rozwiązaniami modułu 1.

**Kroki.**

1. Upewnij się, że masz konto GitHub, fork `js-react-krasnik` i klon w `~/kurs/js-react-krasnik` (zrobiłaś to w module 1) oraz ustawione `user.name` i `user.email` (główne README, sekcja „Dane do commitów”).
2. Utwórz klucz SSH typu ed25519: `ssh-keygen -t ed25519 -C "ola.nowak@example.com"` (wpisz własny adres albo adres `…@users.noreply.github.com`). Na pytania o plik i hasło możesz odpowiedzieć Enterem. Powstają dwa pliki w `~/.ssh`: `id_ed25519` (prywatny, nigdy go nikomu nie pokazuj) i `id_ed25519.pub` (publiczny).
3. Wyświetl klucz publiczny (`cat ~/.ssh/id_ed25519.pub`) i skopiuj całą linię. Na GitHubie wejdź w **Settings → SSH and GPG keys → New SSH key**, wklej klucz, nadaj mu nazwę (np. „laptop WSL”) i zapisz.
4. Sprawdź połączenie: `ssh -T git@github.com`. Przy pierwszym razie wpisz `yes`. Poprawny wynik zaczyna się od „Hi TWOJ-LOGIN! You've successfully authenticated”.
5. Przełącz zdalne repozytorium `origin` z adresu HTTPS na SSH. Zobacz obecny adres poleceniem `git remote -v`, a potem zmień go poleceniem `git remote set-url origin <adres>`. Adres SSH swojego forka skopiujesz z przycisku **Code → SSH** na GitHubie (ma postać `git@github.com:TWOJ-LOGIN/js-react-krasnik.git`).
6. Dodaj oryginalne repozytorium kursu jako zdalne repozytorium `upstream`: `git remote add upstream git@github.com:marcinkieruzel/js-react-krasnik.git`. Sprawdź: `git remote -v` pokazuje `origin` (Twój fork) i `upstream` (oryginał).
7. Zapisz rozwiązania modułu 1 w Gicie i wyślij je na GitHuba: `git status`, `git add -A`, `git commit -m "<opis>"`, `git push`. Opis commita ma mówić, co zrobiłaś, np. „Moduł 1: struktura projektu i polecenia do logów”, a nie „zmiany” albo „aaa”.

**Sync fork a `upstream`.** Są dwa sposoby pobierania nowych modułów z oryginału:

- **Sync fork → Update branch** na GitHubie i potem `git pull` w terminalu: najprostszy, ale wymaga przeglądarki. Tak robisz na co dzień.
- **`git pull upstream main`** (albo `git fetch upstream`, a potem `git merge upstream/main`): to samo bez przeglądarki. Pobiera zmiany prosto z oryginału. Potem wyślij je do forka: `git push`.

Oba sposoby dają ten sam wynik. `upstream` jest też Twoim zabezpieczeniem, gdyby przycisk **Sync fork** był niedostępny.

**Codespaces.** W Codespaces nie musisz tworzyć klucza SSH ani przełączać `origin`: `git push` działa tam przez HTTPS z automatycznym logowaniem. Wykonaj kroki 6 i 7. Strażnik wypisze wtedy tylko informację, że HTTPS wystarcza.

**Oczekiwany wynik.**

```text
uczen@pracownia:~/kurs/js-react-krasnik$ git remote -v
origin	git@github.com:TWOJ-LOGIN/js-react-krasnik.git (fetch)
origin	git@github.com:TWOJ-LOGIN/js-react-krasnik.git (push)
upstream	git@github.com:marcinkieruzel/js-react-krasnik.git (fetch)
upstream	git@github.com:marcinkieruzel/js-react-krasnik.git (push)
uczen@pracownia:~/kurs/js-react-krasnik$ git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

**Sprawdzenie.**

```bash
bash 02-git-github/sprawdz.sh repo
```

Strażnik sprawdza: jest klucz SSH, `origin` używa SSH, `upstream` wskazuje oryginał kursu, w historii jest co najmniej jeden Twój commit (autor inny niż autor kursu), `git status` jest czysty, a `main` śledzi `origin/main` i nie ma niewysłanych commitów. Jeśli `origin` nadal jest przez HTTPS, strażnik powie „Repo sklonowane przez HTTPS” i opisze, co zrobić.

---

## Zadanie 2. Konflikt przy scalaniu (ok. 1 h)

**Cel.** Rozwiązujesz konflikt ręcznie i zachowujesz zmiany z obu gałęzi.

**Kroki.**

1. Zapisz wszystkie zmiany commitem (zadanie 1), bo skrypt przygotowujący odmówi pracy przy niezapisanych zmianach, i stań na gałęzi `main`.
2. Uruchom skrypt: `bash 02-git-github/konflikt/przygotuj.sh`. Zmienia on tylko plik `konflikt/przepis.md`: tworzy gałąź `przepis-babci` (w przepisie „2 łyżki miodu”) i commit na `main` (w tej samej linii „3 łyżki cukru”). Skrypt możesz uruchomić tylko raz, bo odmówi, gdy gałąź już istnieje.
3. Scal gałąź do `main`: `git merge przepis-babci`. Git zgłosi konflikt (`CONFLICT (content): Merge conflict in ...`) i zatrzyma scalanie w połowie.
4. Otwórz `02-git-github/konflikt/przepis.md` (w VS Code: `code 02-git-github/konflikt/przepis.md`; w Codespaces kliknij plik). Znajdziesz fragment ze znacznikami:

```text
<<<<<<< HEAD
- 3 łyżki cukru
=======
- 2 łyżki miodu
>>>>>>> przepis-babci
```

   Część między `<<<<<<< HEAD` a `=======` to wersja z `main`, a część do `>>>>>>> przepis-babci` to wersja z gałęzi. Zostaw w pliku obie linie ze składnikami, a trzy linie ze znacznikami usuń.
5. Zapisz plik, a potem `git add 02-git-github/konflikt/przepis.md` i `git commit` (otworzy się edytor z gotowym komunikatem „Merge branch 'przepis-babci'”: zapisz go Ctrl+O, Enter, Ctrl+X). Zrobiłaś commit scalający.
6. Wyślij wynik: `git push`.

**Oczekiwany wynik.** W `git log --oneline --graph` widać rozwidlenie i commit scalający, a w pliku obie linie:

```text
uczen@pracownia:~/kurs/js-react-krasnik$ git log --oneline --graph -4
*   3f2a9c1 Merge branch 'przepis-babci'
|\
| * 8b1d0e4 Przepis: miód zamiast cukru
* | c47e2a9 Przepis: więcej cukru
|/
```

Ten sam konflikt może się przytrafić przy `git pull`, bo `git pull` to pobranie i scalenie. Rozwiązujesz go dokładnie tak samo jak tu: edytujesz plik, `git add`, `git commit`. (Konflikty przy pobieraniu nowych modułów kursu to osobna sprawa, opisana w głównym README.)

**Sprawdzenie.**

```bash
bash 02-git-github/sprawdz.sh konflikt
```

Strażnik sprawdza: na `main` jest commit scalający z gałęzią `przepis-babci`, w `przepis.md` nie ma znaczników konfliktu, a w pliku są obie linie.

---

## Zadanie 3. Pull request we własnym forku (ok. 1 h)

**Cel.** Zmiana trafia na `main` przez pull request, tak jak w zespołach programistów. Pull request otwierasz **wewnątrz swojego forka**: z gałęzi `opis-o-mnie` do `main` w Twoim repozytorium.

**Kroki.**

1. Stań na `main` i utwórz gałąź: `git switch -c opis-o-mnie`.
2. Utwórz plik `02-git-github/o-mnie.md` z kilkoma zdaniami o sobie (co robisz, czego się uczysz, co Cię interesuje). Strażnik wymaga co najmniej 3 niepustych linii.
3. Zapisz i wyślij gałąź: `git add -A`, `git commit -m "<opis>"`, `git push -u origin opis-o-mnie`.
4. Na stronie swojego forka na GitHubie kliknij żółty pasek **Compare & pull request** (albo **Pull requests → New pull request**).
5. **Ustaw base repository na swój fork.** To najważniejszy krok. GitHub domyślnie ustawia bazę na oryginalne repozytorium kursu. Na górze strony porównania kliknij lewą listę **base repository** i wybierz `TWOJ-LOGIN/js-react-krasnik` (nie `marcinkieruzel/...`). Obok ma być `base: main` i `compare: opis-o-mnie`. Pod listami nie powinno być komunikatu o różnicach w innym repozytorium.
6. Nadaj pull requestowi tytuł, kliknij **Create pull request**.
7. Kliknij zielony **Merge pull request**, a potem **Confirm merge**. Zostaw domyślny sposób „Create a merge commit”: strażnik szuka właśnie takiego commita (nie wybieraj „Squash and merge” ani „Rebase and merge”).
8. W terminalu wróć na `main` i pobierz scaloną zmianę: `git switch main`, `git pull` (jeśli otworzy się edytor: Ctrl+O, Enter, Ctrl+X albo `git pull --no-edit`).

Gdybyś przez pomyłkę otworzyła pull request do oryginalnego repozytorium kursu, nic złego się nie stało: nie ma on wpływu na nikogo, bo właściciel go nie scali. Otwórz stronę tego pull requesta i kliknij **Close pull request**, a potem utwórz poprawny we własnym forku.

**Oczekiwany wynik.** W `git log --oneline -3` na `main` widać commit scalający utworzony przez GitHuba:

```text
uczen@pracownia:~/kurs/js-react-krasnik$ git log --oneline -3
a91c3d7 Merge pull request #1 from TWOJ-LOGIN/opis-o-mnie
5e07b12 Opis o mnie
3f2a9c1 Merge branch 'przepis-babci'
```

**Sprawdzenie.**

```bash
bash 02-git-github/sprawdz.sh pr
```

Strażnik sprawdza: w historii `main` jest commit „Merge pull request #… from …/opis-o-mnie” oraz plik `o-mnie.md` z treścią.

---

## Zadanie 4. Strona na GitHub Pages (ok. 0,5 h)

**Cel.** Twoja strona jest publiczna pod adresem w internecie.

**Kroki.**

1. Otwórz `02-git-github/strona/index.html` i zastąp wszystkie teksty `TODO`: tytuł strony (w `<title>`), imię w nagłówku, jedno zdanie o sobie i dwa linki (np. do Twojego profilu na GitHubie i do repozytorium kursu). Linki muszą zaczynać się od `https://`.
2. Zapisz zmiany w Gicie i wyślij je: `git add -A`, `git commit -m "<opis>"`, `git push`.
3. Na stronie forka na GitHubie wejdź w **Settings → Pages**. W sekcji **Build and deployment** wybierz **Source: Deploy from a branch**, **Branch: main**, folder **/ (root)** i kliknij **Save**.
4. Poczekaj minutę lub dwie i odśwież stronę ustawień: pojawi się adres `https://TWOJ-LOGIN.github.io/js-react-krasnik/`. GitHub Pages publikuje cały folder repozytorium, więc Twoja strona jest pod adresem z dopisaną ścieżką: `https://TWOJ-LOGIN.github.io/js-react-krasnik/02-git-github/strona/`. Otwórz go w przeglądarce.

**Sprawdzenie.** Przekaż strażnikowi adres główny (bez ścieżki, ścieżkę dopisze sam):

```bash
bash 02-git-github/sprawdz.sh pages https://TWOJ-LOGIN.github.io/js-react-krasnik
```

Strażnik sprawdza: strona odpowiada (kod 200), ma `<title>`, nie zawiera już tekstu `TODO` i ma co najmniej dwa linki. Jeśli dostajesz błąd 404 zaraz po włączeniu Pages, odczekaj kilka minut.

---

## Na koniec

Uruchom wszystko naraz (z adresem strony) i wyślij wynik na GitHuba:

```bash
bash 02-git-github/sprawdz.sh wszystko https://TWOJ-LOGIN.github.io/js-react-krasnik
git push
```

Potem na platformie Python Lab wklej link do swojego forka (instrukcja w głównym README, sekcja „Jak oddać zadanie”).
