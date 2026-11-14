![Logotypy: Fundusze Europejskie dla Lubelskiego, Rzeczpospolita Polska, Dofinansowane przez Unię Europejską, Lubelskie](materialy/logotypy-fe.png)

Projekt „Kształcenie zawodowe – nowe perspektywy” współfinansowany ze środków Europejskiego Funduszu Społecznego Plus w ramach programu Fundusze Europejskie dla Lubelskiego 2021–2027

# Kurs „JavaScript Developer React” — ćwiczenia

Ćwiczenia do kursu „JavaScript Developer React” (Technikum nr 2 w Kraśniku). Uczysz się sama, we własnym tempie, na platformie Python Lab. Teorię masz w prezentacjach, a praktykę w tym repozytorium: każdy moduł ma swój folder z zadaniami i skryptem, który sprawdza Twoją pracę.

To repozytorium jest wzorem kursu. Nie pracujesz w nim bezpośrednio. Tworzysz własną kopię (fork) i w niej zapisujesz swoje rozwiązania.

## Jak zacząć

1. Nie masz konta na GitHubie? Załóż je na stronie `github.com/signup`: podajesz adres e-mail, hasło i login, a GitHub wysyła na e-mail kod, którym potwierdzasz adres.
   - Login będzie częścią publicznych adresów Twojego forka i Twojej strony (np. `github.com/TWOJ-LOGIN/js-react-krasnik`). Wybierz neutralny: nie musi zawierać imienia ani nazwiska.
   - Włącz weryfikację dwuetapową (2FA). GitHub wymaga jej od osób, które wysyłają kod, więc i tak o nią poprosi. Kliknij swoje zdjęcie profilowe (prawy górny róg) → **Settings → Password and authentication → Enable two-factor authentication** i wybierz aplikację uwierzytelniającą w telefonie. Kody odzyskiwania (recovery codes) zapisz w bezpiecznym miejscu: bez nich zgubiony telefon oznacza utratę dostępu do konta.
2. Zaloguj się na GitHubie i otwórz stronę `github.com/marcinkieruzel/js-react-krasnik`.
3. Kliknij **Fork**, a potem **Create fork**. Powstaje Twoja własna kopia repozytorium. Będzie publiczna, bo tak działają forki publicznych repozytoriów. To normalne w kursach: Twoje rozwiązania staną się portfolio, które możesz pokazać innym.
4. Sklonuj swój fork na komputer przez HTTPS (w terminalu WSL). Wszystkie prace kursowe trzymasz w folderze `~/kurs`:

```bash
mkdir -p ~/kurs && cd ~/kurs
git clone https://github.com/TWOJ-LOGIN/js-react-krasnik.git
cd js-react-krasnik
```

   Po module 2 będziesz mieć klucz SSH i wtedy możesz klonować tak: `git clone git@github.com:TWOJ-LOGIN/js-react-krasnik.git`. Na początku używaj HTTPS, bo SSH bez klucza nie zadziała.

   Pracujesz w GitHub Codespaces zamiast na własnym komputerze? Na stronie swojego forka kliknij **Code → Codespaces → Create codespace on main**. Repozytorium jest tam od razu otwarte (w folderze `/workspaces/js-react-krasnik`), więc pomiń `mkdir`, `cd ~/kurs` i `git clone`. Codespace, którego nie używasz przez 30 dni, GitHub usuwa razem ze wszystkim, czego nie wysłałaś do forka. Dlatego po każdej sesji zapisz pracę commitem i wyślij ją poleceniem `git push` (sekcja „Jak oddać zadanie”).

### Dane do commitów

Zanim zrobisz pierwszy commit, ustaw w Gicie swoje imię i adres e-mail. To obowiązkowe: bez tego commit się nie uda albo Git wstawi dane zgadnięte z systemu. Poniżej przykładowe dane, wpisz własne:

```bash
git config --global user.name "Ola Nowak"
git config --global user.email "ola.nowak@example.com"
```

Ustaw też raz sposób łączenia zmian przy `git pull`. Dzięki temu Git zwyczajnie połączy zmiany, zamiast zatrzymywać się z błędem:

```bash
git config --global pull.rebase false
```

Jeśli nie chcesz, żeby Twój prawdziwy adres był widoczny w historii, na GitHubie wejdź w **Settings → Emails** i użyj adresu `…@users.noreply.github.com`, który tam znajdziesz.

### Czego potrzebujesz

- WSL 2 (Ubuntu) albo GitHub Codespaces,
- Node.js w aktualnej wersji LTS (w listopadzie 2026: Node.js 26), instalowany przez nvm,
- VS Code,
- Git.

Node przez nvm instalujesz dwoma poleceniami (szczegóły w module 1). Po pierwszym zamknij i otwórz terminal:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.41.0/install.sh | bash
nvm install --lts
```

W Codespaces nvm już jest. Wpisz tylko `nvm install --lts`, a potem `nvm alias default lts/*`: drugie polecenie sprawia, że każdy nowy terminal (i skrypt sprawdzający) używa tej wersji Node.js.

Każdy moduł zaczyna się od krótkiego opisu w jego `README.md`. Czytaj go przed zadaniami.

## Moduły

| Nr | Moduł | Praktyka (h) | Folder |
| --- | --- | --- | --- |
| 1 | Moduł 1. Linux — praca w terminalu | 4 | [`01-linux-terminal/`](01-linux-terminal/) |
| 2 | Moduł 2. Git i GitHub | 4 | [`02-git-github/`](02-git-github/) |
| 3 | Moduł 3. Podstawy programowania | 5 | pojawi się |
| 4 | Moduł 4. HTML i CSS — poziom podstawowy | 7 | pojawi się |
| 5 | Moduł 5. JavaScript — poziom podstawowy | 8 | pojawi się |
| 6 | Moduł 6. HTML i CSS — poziom zaawansowany | 6 | pojawi się |
| 7 | Moduł 7. JavaScript — poziom zaawansowany | 9 | pojawi się |
| 8 | Moduł 8. Gulp / Sass | 4 | pojawi się |
| 9 | Moduł 9. RWD i Accessibility | 5 | pojawi się |
| 10 | Moduł 10. jQuery oraz Webpack | 4 | pojawi się |
| 11 | Moduł 11. ECMAScript (ES6+) | 5 | pojawi się |
| 12 | Moduł 12. React — poziom podstawowy | 9 | pojawi się |
| 13 | Moduł 13. React — poziom zaawansowany | 10 | pojawi się |

## Nowe moduły

Foldery kolejnych modułów pojawiają się w repozytorium kursu z czasem. Żeby pobrać je do swojego forka:

1. Na stronie swojego forka na GitHubie kliknij **Sync fork**, a potem **Update branch**.
2. W terminalu, w folderze repozytorium, wpisz:

```bash
git pull
```

Jeśli GitHub zamiast **Update branch** proponuje **Discard N commits** (N to liczba), nie klikaj tego przycisku: usuwa on z forka Twoje commity, czyli Twoje rozwiązania. Pobierz wtedy nowy moduł w terminalu przez `upstream` (moduł 2, zadanie 1) albo napisz do opiekuna kursu.

Jeśli `git pull` utworzy scalenie (merge) i otworzy edytor z komunikatem, zapisz go i zamknij: w nano Ctrl+O, Enter, Ctrl+X. Możesz też od razu wpisać `git pull --no-edit`.

Jeśli GitHub albo `git pull` zgłosi konflikt (zdarza się tylko wtedy, gdy autor kursu zmienił plik, który Ty też edytowałaś), niczego nie usuwaj i nie rozwiązuj go na ślepo. Napisz do opiekuna kursu przez platformę Python Lab. Czym jest fork i zdalne repozytorium (remote), wyjaśnia moduł 2. Tam też uczysz się rozwiązywać konflikty, ale to dotyczy Twoich własnych zmian: konflikt z aktualizacją kursu zgłoś opiekunowi.

## Jak oddać zadanie

1. Skończ zadanie i uruchom skrypt sprawdzający z głównego folderu repozytorium (`~/kurs/js-react-krasnik`, w Codespaces `/workspaces/js-react-krasnik`): `bash 01-linux-terminal/sprawdz.sh …` (z folderem modułu, nad którym pracujesz). Jeśli jesteś w folderze modułu: `bash sprawdz.sh …`.
2. Zapisz zmiany w Gicie i wyślij je do swojego forka. W opisie commita zamiast `N` wpisz numer modułu, a po dwukropku krótko, co zrobiłaś, np. „Moduł 1: struktura projektu i polecenia do logów”:

```bash
git add -A
git commit -m "Moduł N: co zrobiłaś"
git push
```

`git push` wpisz w terminalu VS Code (w WSL albo w Codespaces): przy pierwszym wysłaniu VS Code poprosi o zalogowanie do GitHuba. W zwykłym oknie Ubuntu wysyłanie przez HTTPS się nie uda, bo GitHub nie przyjmuje haseł.

3. Na platformie Python Lab otwórz formularz zadań i wklej link do swojego forka.

## Kontakt

Masz pytanie albo coś nie działa? Napisz przez platformę Python Lab. Adres e-mail opiekuna znajdziesz na platformie.
