{-# LANGUAGE LambdaCase, ViewPatterns #-}

-- Library for Aura output in different languages.
-- All normal restrictions on line length do not apply for this file, and this file only.

{- AURA TRANSLATORS - Thank you all
Chris "Kwpolska" Warrick             | Polish
Denis Kasak / "stranac"              | Croatian
Fredrik Haikarainen / Daniel Beecham | Swedish
Lukas Niederbremer / Jonas Platte    | German
Alejandro Gómez / Sergio Conde       | Spanish
Henry Kupty / Thiago Perrotta        | Portuguese
Ma Jiehong / Fabien Dubosson         | French
Kyrylo Silin                         | Russian
Bob Valantin                         | Italian
Filip Brcic                          | Serbian
"chinatsun"                          | Norwegian
"pak tua Greg"                       | Indonesia
Kai Zhang                            | Chinese
-}

{-

Copyright 2012 - 2017 Colin Woodbury <colingw@gmail.com>

This file is part of Aura.

Aura is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Aura is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Aura.  If not, see <http://www.gnu.org/licenses/>.

-}

module Aura.Languages
    ( module Aura.Languages
    , Language(..) ) where

import           Control.Arrow
import qualified Data.Map.Lazy as Map (Map, (!), fromList, toList, mapWithKey)
import           Data.Monoid

import           Aura.Colour.Text (cyan, green, red, blue, yellow, bForeground)
import           Aura.Languages.Base
import qualified Aura.Languages.Fields as Fields

---

translators :: Map.Map Language String
translators = Map.fromList
    [ (Polish,     "Chris \"Kwpolska\" Warrick")
    , (Croatian,   "Denis Kasak / \"stranac\"")
    , (Swedish,    "Fredrik Haikarainen / Daniel Beecham")
    , (German,     "Lukas Niederbremer / Jonas Platte")
    , (Spanish,    "Alejandro Gómez / Sergio Conde")
    , (Portuguese, "Henry \"Ingvij\" Kupty / Thiago \"thiagowfx\" Perrotta")
    , (French,     "Ma Jiehong / Fabien Dubosson")
    , (Russian,    "Kyrylo Silin")
    , (Italian,    "Bob Valantin")
    , (Serbian,    "Filip Brcic")
    , (Norwegian,  "\"chinatsun\"")
    , (Indonesia,  "\"pak tua Greg\"")
    , (Chinese,    "Kai Zhang")
    ]

-- These need updating! Or removing...
languageNames :: Language -> Map.Map Language String
languageNames = Map.fromList . zip [ Polish, Croatian, Swedish, German, Spanish, Portuguese, French, Russian, Italian, Serbian, Norwegian, Indonesia, Chinese ] . \case
    Japanese   -> [ "ポーランド語", "クロアチア語", "スウェーデン語", "ドイツ語", "スペイン語", "ポルトガル語", "フランス語", "ロシア語", "イタリア語", "セルビア語", "ノルウェー語", "インドネシア語", "中国語" ]
    Polish     -> [ "polski", "chorwacki", "szwedzki", "niemiecki", "hiszpański", "portugalski", "francuski", "rosyjski", "", "", "", "Indonesian", "Chinese" ]
    Croatian   -> [ "poljski", "hrvatski", "švedski", "njemački", "španjolski", "portugalski", "francuski", "ruski", "talijanski", "srpski", "norveški", "Indonesian", "Chinese" ]
    Swedish    -> [ "Polska", "Kroatiska", "Svenska", "Tyska", "Spanska", "Portugisiska", "Franska", "Ryska", "Italienska", "Serbiska", "Norska", "Indonesian", "Chinese" ]
    German     -> [ "Polnisch", "Kroatisch", "Schwedisch", "Deutsch", "Spanisch", "Portugiesisch", "Französisch", "Russisch", "Italienisch", "Serbisch", "Norwegisch", "Indonesisch", "Chinese" ]
    Spanish    -> [ "Polaco", "Croata", "Sueco", "Alemán", "Español", "Portugués", "Francés", "Ruso", "Italiano", "Serbio", "Noruego", "Indonesio", "Chinese" ]
    Portuguese -> [ "Polonês", "Croata", "Sueco", "Alemão", "Espanhol", "Português", "Francês", "Russo", "Italiano", "Sérvio", "Norueguês", "Indonesian", "Chinese" ]
    French     -> [ "Polonais", "Croate", "Suédois", "Allemand", "Espagnol", "Portugais", "Français", "Russe", "Italien", "Serbe", "Norvégien", "Indonesian", "Chinese" ]
    Russian    -> [ "Польский", "Хорватский", "Шведский", "Немецкий", "Испанский", "Португальский", "Русский", "Итальянский", "Сербский", "Норвежский", "Индонезийский", "Chinese" ]
    Italian    -> [ "Polacco", "Croato", "Svedese", "Tedesco", "Spagnolo", "Portoghese", "Francese", "Russo", "Italiano", "", "", "Indonesian", "Chinese" ]
    Serbian    -> [ "Пољски", "Хрватски", "Шведски", "Немачки", "Шпански", "Португалски", "Француски", "Руски", "Италијански", "Српски", "", "Indonesian", "Chinese" ]
    Norwegian  -> [ "Polsk", "Kroatisk", "Svensk", "Tysk", "Spansk", "Portugisisk", "Fransk", "Russisk", "Italiensk", "Serbisk", "Norsk", "Indonesian", "Chinese" ]
    Indonesia  -> [ "Polandia", "Kroasia", "Swedia", "Jerman", "Spanyol", "Portugis", "Prancis", "Rusia", "Italia", "Serbia", "Norwegia", "Indonesian", "Chinese" ]
    Chinese    -> [ "波兰语", "克罗地亚语", "瑞典语", "德语", "西班牙语", "葡萄牙语", "法语", "俄语", "意大利语", "塞尔维亚语", "挪威语", "印度尼西亚语", "中文" ]
    _          -> [ "Polish", "Croatian", "Swedish", "German", "Spanish", "Portuguese", "French", "Russian", "Italian", "Serbian", "Norwegian", "Indonesian", "Chinese" ]

translatorMsgTitle :: Language -> String
translatorMsgTitle = \case
    Japanese   -> "Auraの翻訳者："
    Polish     -> "Tłumacze Aury:"
    Croatian   -> "Aura Prevoditelji:"
    Swedish    -> "Aura Översättare:"
    German     -> "Aura Übersetzer:"
    Spanish    -> "Traductores de Aura:"
    Portuguese -> "Tradutores de Aura:"
    French     -> "Traducteurs d'Aura:"
    Russian    -> "Переводчики Aura:"
    Italian    -> "Traduttori di Aura:"
    Serbian    -> "Преводиоци Аура:"
    Norwegian  -> "Aura Oversettere:"
    Indonesia  -> "Penerjemah Aura:"
    Chinese    -> "Aura 的翻译者："
    _          -> "Aura Translators:"

translatorMsg :: Language -> [String]
translatorMsg lang = title : names
  where title = translatorMsgTitle lang
        names = fmap snd . Map.toList $
            Map.mapWithKey (\l t -> formatLang (assocLang l t)) translators
        assocLang lang' translator = (translator, languageNames lang Map.! lang')
        formatLang (translator, lang') = " " <> translator <> " (" <> lang' <> ")"

allLanguages :: [Language]
allLanguages = [English ..]

-- Wrap a String in backticks
bt :: String -> String
bt cs = "`" <> cyan cs <> "`"

whitespace :: Language -> String
whitespace Japanese = "　"  -- \12288
whitespace _ = " "          -- \32

langFromLocale :: String -> Language
langFromLocale = take 2 >>> \case
    "ja" -> Japanese
    "pl" -> Polish
    "hr" -> Croatian
    "sv" -> Swedish
    "de" -> German
    "es" -> Spanish
    "pt" -> Portuguese
    "fr" -> French
    "ru" -> Russian
    "it" -> Italian
    "sr" -> Serbian
    "nb" -> Norwegian
    "id" -> Indonesia
    "zh" -> Chinese
    _    -> English


----------------------
-- Aura/Core functions
----------------------
-- NEEDS TRANSLATION
checkDBLock_1 :: Language -> String
checkDBLock_1 = \case
    Japanese   -> "パッケージデータベースが閉鎖されている状態です。開放したらキーを押して続行してください。"
    Polish     -> "Baza pakietów jest zablokowana. Kiedy zostanie odblokowana naciśnij enter aby kontynuować"
    Croatian   -> "Baza paketa je zaključana. Kad se otključa, pritisnite enter da biste nastavili."
    German     -> "Die Paketdatenbank ist gesperrt. Drücken Sie Enter wenn sie entsperrt ist um fortzufahren."
    Spanish    -> "La base de datos de paquetes está bloqueada. Presiona enter cuando esté desbloqueada para continuar."
    Norwegian  -> "Pakkedatabasen er låst. Trykk enter når den er åpnet for å fortsette."
    French     -> "La base de données des paquets est bloquée. Appuyez sur enter pour continuer."
    Portuguese -> "Banco de dados de pacote travado. Aperte 'enter' quando estiver destravado para poder continuar."
    Russian    -> "База данных пакетов заблокирована. Нажмите \"Ввод\", когда она разблокируется, чтобы продолжить."
    Chinese    -> "包数据库已锁定。请在解锁后按下回车以继续。"
    Swedish    -> "Paketdatabasen är låst. Klicka på enter när den är upplåst."
    _          -> "The package database is locked. Press enter when it's unlocked to continue."

-- Packages should not be built if the user is logged in as root!
trueRoot_1 :: Language -> String
trueRoot_1 = \case
    Japanese   -> "rootユーザーとしてパッケージを作成するのは危険です。続行しますか？"
    Polish     -> "Nigdy nie powinieneś budować pakietów jako root. Na pewno kontynuować?"
    Croatian   -> "Pakete ne bi trebalo graditi sa root korisničkim računom. Nastaviti?"
    Swedish    -> "Det är starkt rekommenderat att INTE vara inloggad som root när man bygger paket. Vill du fortsätta ändå?"
    German     -> "Sie sollten niemals Pakete als der echte root-Nutzer bauen. Sind sie sicher, dass Sie dies tun wollen?"
    Spanish    -> "No deberías compilar paquetes como root nunca. ¿Deseas continuar?"
    Portuguese -> "Você nunca deveria compilar pacotes como usuário root. Deseja prosseguir mesmo assim?"
    French     -> "Il n'est pas recommandé de construire des paquets avec le compte root. Voulez-vous continuer ?"
    Russian    -> "Вам никогда не следует собирать пакеты под настоящим рутом. Договорились?"
    Italian    -> "Non si dovrebbero compilare pacchetti come root. Volete Continuare?"
    Serbian    -> "Не би требало градити пакете са правим root овлашћењима. Желите ли наставити?"
    Norwegian  -> "Du bør aldri bygge pakker som root. Er du helt sikker på at du vil gjøre dette?"
    Indonesia  -> "Paket tidak boleh dibangun oleh root. Apakah anda setuju dengan hal ini?"
    Chinese    -> "请不要以根用户构建包。以普通用户构建？"
    _          -> "You should never build packages as the true root. Are you okay with this?"

-- This is for when the user decides to refrain from building afterall.
trueRoot_2 :: Language -> String
trueRoot_2 = \case
    Japanese   -> "よしよし。"
    Polish     -> "Postąpiłeś słusznie."
    Croatian   -> "Ispravno ste postupili."
    Swedish    -> "Phew."
    German     -> "Eine weise Entscheidung."
    Spanish    -> "Has tomado la decision correcta."
    Portuguese -> "Ainda bem que tem juízo!"
    French     -> "C'est la bonne décision."
    Russian    -> "Вы выбрали православный путь."
    Italian    -> "Hai fatto la cosa giusta."
    Serbian    -> "Исправно сте поступили."
    Norwegian  -> "Du gjør det rette."
    Indonesia  -> "Bagus! Papa bangga sama kamu!"
    Chinese    -> "你做了正确的事情。"
    _          -> "You’ve done the right thing."

trueRoot_3 :: Language -> String
trueRoot_3 = \case
  Japanese -> "「root」としてパッケージを作成するのは「makepkg v4.2」で不可能になりました。"
  German   -> "Seit makepkg v4.2 ist es nicht mehr möglich als root zu bauen."
  Spanish  -> "Desde makepkg v4.2 no es posible compilar paquetes como root."
  Chinese  -> "自从 makepkg v4.2 以后，就不能以根用户身份构建软件了。"
  Swedish  -> "I makepkg v4.2 och uppåt är det inte tillåtet att bygga som root."
  _        -> "As of makepkg v4.2, building as root is no longer possible."

mustBeRoot_1 :: Language -> String
mustBeRoot_1 = let sudo = bt "sudo" in \case
    Japanese   -> sudo <> "を使わないとそれができない！"
    Polish     -> "Musisz użyć " <> sudo <> ", żeby to zrobić."
    Croatian   -> "Morate koristiti" <> sudo <> "za ovu radnju."
    Swedish    -> "Du måste använda " <> sudo <> " för det."
    German     -> "Sie müssen dafür " <> sudo <> " benutzen."
    Spanish    -> "Tienes que utilizar " <> sudo <> " para eso."
    Portuguese -> "Utilize " <> sudo <> " para isso."
    French     -> "Vous devez utiliser " <> sudo <> " pour ça."
    Russian    -> "Необходимо использовать " <> sudo <> " для этого."
    Italian    -> "È necessario utilizzare " <> sudo <> " per questo."
    Serbian    -> "Морате да користите " <> sudo <> " за ову радњу."
    Norwegian  -> "Du må bruke " <> sudo <> " for det."
    Indonesia  -> "Anda harus menggunakan " <> sudo <> " untuk melakukannya."
    Chinese    -> "除非是根用户，否则不能执行此操作。"
    _          -> "You cannot perform this operation unless you are root."

-----------------------
-- Aura/Build functions
-----------------------
buildPackages_1 :: String -> Language -> String
buildPackages_1 (bt -> p) = \case
    Japanese   -> p <> "を作成中・・・"
    Polish     -> "Budowanie " <> p <> "..."
    Croatian   -> "Gradim " <> p <> "..."
    Swedish    -> "Bygger paket " <> p <> "..."
    German     -> "Baue Paket " <> p <> "..."
    Spanish    -> "Compilando " <> p <> "..."
    Portuguese -> "Compilando " <> p <> "..."
    French     -> "Compilation de " <> p <> "..."
    Russian    -> "Сборка " <> p <> "..."
    Italian    -> "Compilazione di " <> p <> "..."
    Serbian    -> "Градим " <> p <> "..."
    Norwegian  -> "Bygger " <> p <> "..."
    Indonesia  -> "Membangun " <> p <> "..."
    Chinese    -> p <> " 正在构建中..."
    _          -> "Building " <> p <> "..."

buildFail_1 :: String -> Language -> String
buildFail_1 (bt -> p) = \case
    Japanese   -> p <> "の作成は失敗しました。"
    Polish     -> "Budowanie " <> p <> " zakończyło się niepowodzeniem."
    Croatian   -> "Izgradnja " <> p <> " nije uspjela."
    Swedish    -> "Det gick inte att bygga paketet " <> p <> "."
    German     -> "Bauen von " <> p <> " ist fehlgeschlagen."
    Spanish    -> "La compilación de " <> p <> " ha fallado."
    Portuguese -> "Falha na compilação do pacote " <> p <> "."
    French     -> "Bon, la compilation de " <> p <> " a échouée."
    Russian    -> "Что ж, сборка " <> p <> " не удалась."
    Italian    -> "La compilazione di " <> p <> "è fallita."
    Serbian    -> "Изградња пакета " <> p <> " није успела."
    Norwegian  -> "Bygging av " <> p <> " feilet."
    Indonesia  -> "Gagal membangun " <> p
    Chinese    -> p <> " 构建失败。"
    _          -> "Well, building " <> p <> " failed."

buildFail_2 :: Language -> String
buildFail_2 = \case
    Japanese   -> "ちなみに下記のパッケージも作成されませんでした："
    Polish     -> "Dodatkowo, następujące pakiety nie zostały zbudowane:"
    Croatian   -> "Osim toga, ni sljedeće nije izgrađeno:"
    Swedish    -> "Det gick heller inte att bygga följande paket:"
    German     -> "Außerdem wurden die folgenden Pakete nicht gebaut:"
    Spanish    -> "Los siguientes paquetes no se han compilado:"
    Portuguese -> "Os pacotes a seguir não foram compilados:"
    French     -> "En outre, les paquets suivants n'ont pu être compilés :"
    Russian    -> "К тому же, следующие пакеты не были собраны:"
    Italian    -> "Inoltre non è stato possibile cotruire i seguenti pacchetti:"
    Serbian    -> "Такође, ни следећи пакети нису изграђени::"
    Norwegian  -> "Det gikk heller ikke an å bygge følgende:"
    Indonesia  -> "Dan paket berikut juga tidak terbangun:"
    Chinese    -> "而且，以下包也不会被构建："
    _          -> "Also, the following weren’t built:"

buildFail_3 :: Language -> String
buildFail_3 = \case
    Japanese   -> "しかし、以下のパッケージファイルは無事作成されました："
    Polish     -> "Następujące pakiety zostały zbudowane pomyślnie:"
    Croatian   -> "Neki paketi su ipak uspješno izgrađeni:"
    Swedish    -> "Vissa paket kanske har byggts ordentligt (Osäker)."
    German     -> "Diese Pakete wurden wiederum erfolgreich gebaut:"
    Spanish    -> "Sin embargo, los siguientes paquetes se han compilado:"
    Portuguese -> "Entretanto, os seguintes pacotes compilaram com sucesso:"
    French     -> "Cependant, les paquets suivants ont été compilés avec succès :"
    Russian    -> "Однако, эти пакеты были успешно собраны:"
    Italian    -> "Comunque questi pacchetti sono stato compilati con successo:"
    Serbian    -> "Међутим, ови пакети су успешно изграђени:"
    Norwegian  -> "Heldigvis ble de følgende pakkene bygd:"
    Indonesia  -> "Namun, paket berikut berhasil dibangun:"
    Chinese    -> "但是，这些包已经成功构建："
    _          -> "However, these packages were successfully built:"

buildFail_4 :: Language -> String
buildFail_4 = \case
    Japanese   -> "それらをインストールしますか？"
    Polish     -> "Czy chcesz je zainstalować?"
    Croatian   -> "Želite li ih instalirati?"
    Swedish    -> "Vill du installera dem?"
    German     -> "Möchten Sie diese installieren?"
    Spanish    -> "¿Te gustaría instalarlos?"
    Portuguese -> "Gostaria de instalá-los?"
    French     -> "Voulez-vous les installer ?"
    Russian    -> "Желаете ли вы их установить?"
    Italian    -> "Volete installarli?"
    Serbian    -> "Желите ли их инсталирати?"
    Norwegian  -> "Vil du installere dem?"
    Indonesia  -> "Apakah anda ingin menginstal disini?"
    Chinese    -> "你希望安装这些包吗？"
    _          -> "Would you like to install them?"

buildFail_5 :: Language -> String
buildFail_5 = \case
    Japanese   -> "パッケージ作成に失敗しました。"
    Polish     -> "Budowanie nie powiodło się."
    Croatian   -> "Izgradnja nije uspjela."
    Swedish    -> "Gick inte att bygga paket."
    German     -> "Bauen fehlgeschlagen."
    Spanish    -> "La compilación falló."
    Portuguese -> "Falha na compilação."
    French     -> "Compilation échouée."
    Russian    -> "Сборка не удалась."
    Italian    -> "Compilazione fallita."
    Serbian    -> "Изградња пакета није успела."
    Norwegian  -> "Bygging feilet."
    Indonesia  -> "Proses gagal."
    Chinese    -> "构建失败。"
    _          -> "Building failed."

-- NEEDS TRANSLATION
buildFail_6 :: Language -> String
buildFail_6 = \case
    Japanese   -> "それでも続行しますか？"
    Polish     -> "Czy mimo to chcesz kontynuować?"
    Croatian   -> "Želite li svejedno nastaviti?"
    German     -> "Möchten Sie trotzdem fortfahren?"
    Spanish    -> "¿Deseas continuar de todas formas?"
    Norwegian  -> "Vil du fortsette likevel?"
    Italian    -> "Vuoi continuare comunque?"
    Portuguese -> "Gostaria de continuar mesmo assim?"
    French     -> "Voulez-vous tout de même continuer ?"
    Russian    -> "Продолжить, несмотря ни на что?"
    Indonesia  -> "Apakah anda tetap ingin melanjutkan?"
    Chinese    -> "你仍然希望继续吗？"
    Swedish    -> "Vill du fortsätta ändå?"
    _          -> "Would you like to continue anyway?"

-- NEEDS TRANSLATION
buildFail_7 :: String -> Language -> String
buildFail_7 (bt -> p) = \case
    Japanese   -> p <> "のビルドスクリプトを収得できませんでした。"
    Polish     -> "Nie udało się pozyskać skryptów budowania dla " <> p <> "."
    German     -> "Herunterladen der Build-Skripte für " <> p <> " fehlgeschlagen."
    Spanish    -> "No se han podido obtener los scripts de compilación de " <> p <> "."
    Portuguese -> "Falhou para obter scripts de compilação para " <> p <> "."
    Indonesia  -> "Gagal mendapatkan skrip untuk " <> p <> "."
    Russian    -> "Не удалось получить сценарии сборки для " <> p <> "."
    Chinese    -> "无法获得 " <> p <> " 的构建脚本。"
    Swedish    -> "Kunde inte hämta byggskript för " <> p <> "."
    _          -> "Failed to obtain build scripts for " <> p <> "."

displayBuildErrors_1 :: Language -> String
displayBuildErrors_1 = \case
    Japanese   -> "makepkgの出力をダンプ・・・"
    Polish     -> "Wyjście makepkg zostanie wypisane za "
    Croatian   -> "Zapisujem makepkg ispis u "
    Swedish    -> "Dumpar makepkgs utskrift i "
    German     -> "Schreibe makepkg-Ausgabe in "
    Spanish    -> "Volcando la salida de makepkg en "
    Portuguese -> "Despejando a saída do makepkg em "
    French     -> "Redirection de la sortie de makepkg vers "
    Russian    -> "Вывод makepkg записывается в "
    Italian    -> "Salvataggio dell'output di makepkg in "
    Serbian    -> "Уписујем излаз makepkg-а у "
    Norwegian  -> "Dumper makepkg's utskrift i "
    Indonesia  -> "Melimpahkan keluaran makepkg di "
    Chinese    -> "正在清理 makepkg 的输出... "
    _          -> "Dumping makepkg output in "

------------------------------
-- Aura/Dependencies functions
------------------------------
-- Is this still used?
getDepsToInstall_1 :: Language -> String
getDepsToInstall_1 = \case
    Japanese   -> "パッケージは一つも指摘されていない。"
    Polish     -> "Nie podano pakietów z AUR do zainstalowania."
    Croatian   -> "Nijedan AUR paket nije specificiran za instalaciju."
    Swedish    -> "Inga AUR-paket är valda för installation."
    German     -> "Keine AUR-Pakete zur Installation vermerkt."
    Spanish    -> "No se han especificado paquetes de AUR para instalar."
    Portuguese -> "Nenhum pacote do AUR foi especificado para instalação."
    French     -> "Aucun paquet AUR à installer n'a été spécifié."
    Russian    -> "Пакеты AUR для установки не указаны."
    Italian    -> "Nessun pacchetto di AUR specificato per l'installazione."
    Serbian    -> "Ниједан AUR пакет није специфициран за инсталацију."
    Norwegian  -> "Ingen pakker fra AUR er valgt for installasjon."
    Indonesia  -> "Tidak ada paket dari AUR yang ditentukan untuk diinstasl."
    Chinese    -> "没有指定要安装的 AUR 软件包。"
    _          -> "No AUR packages specified for install."

getRealPkgConflicts_1 :: String -> String -> String -> Language -> String
getRealPkgConflicts_1 (bt -> p) (bt -> r) (bt -> d) = \case
    Japanese   -> "パッケージ" <> p <> "はバージョン" <> d <> "を要するが" <> "一番最新のバージョンは" <> r <> "。"
    Polish     -> "Zależność " <> p <> " powinna być w wersji " <> d <> ", ale najnowsza wersja to " <> r <> "."
    Croatian   -> "Zavisnost " <> p <> " zahtjeva verziju " <> d <> ", a najnovija dostupna verzija je " <> r <> "."
    Swedish    -> "Beroendepaketet " <> p <> " kräver version " <> d <> " men den senaste versionen är " <> r <> "."
    German     -> "Die Abhängigkeit " <> p <> " verlangt Version " <> d <> ", aber die neuste Version ist " <> r <> "."
    Spanish    -> "La dependencia " <> p <> " requiere la versión " <> d <> " pero la versión más reciente es " <> r <> "."
    Portuguese -> "A dependência " <> p <> " exige a versão " <> d <> " mas a versão mais recente é " <> r <> "."
    French     -> p <> " est une dépendance nécessitant la version " <> d <> ", mais la plus récente est la version " <> r <> "."
    Russian    -> "Зависимость " <> p <> " требует версию " <> d <> ", однако самой последней версией является " <> r <> "."
    Italian    -> "La dipendenza " <> p <> " richiede la versione " <> d <> " ma la versione disponibile è " <> r <> "."
    Serbian    -> "Зависност " <> p <> " захтева верзију " <> d <> ", али најновија верзија је " <> r <> "."
    Norwegian  -> "Avhengigheten " <> p <> " krever versjon " <> d <>", men den nyeste versjonen er " <> r <> "."
    Indonesia  -> "Dependensi " <> p <> " meminta versi " <> d <> " namun versi paling baru adalah " <> r <> "."
    Chinese    -> "依赖 " <> p <> " 需要版本 " <> d <> "，但是最新的版本是 " <> r <> "。"
    _          -> "The dependency " <> p <> " demands version " <> d <> ", but the most recent version is " <> r <> "."

getRealPkgConflicts_2 :: String -> Language -> String
getRealPkgConflicts_2 (bt -> p) = \case
    Japanese   -> p <> "は無視されるパッケージ！`pacman.conf`を参考に。"
    Polish     -> p <> " jest ignorowany! Sprawdź plik `pacman.conf`."
    Croatian   -> p <> " je ignoriran paket! Provjerite svoj `pacman.conf`."
    Swedish    -> p <> " är ett ignorerat paket! Kolla din `pacman.conf`-fil."
    German     -> p <> " ist ein ignoriertes Paket! Siehe /etc/pacman.conf."
    Spanish    -> "¡" <> p <> " es un paquete ignorado! Revisa tu fichero `pacman.conf`."
    Portuguese -> p <> " é um pacote ignorado conforme configuração em `pacman.conf`!"
    French     -> "Le paquet " <> p <> " est ignoré. Vous devriez jeter un œil à votre `pacman.conf`."
    Russian    -> "Пакет " <> p <> " игнорируется! Проверьте ваш файл `pacman.conf`."
    Italian    -> p <> " è un pacchetto ignorato, controllare `pacman.conf`."
    Serbian    -> "Пакет " <> p <> " је игнорисан! Видите ваш фајл „pacman.conf“."
    Norwegian  -> p <> " er en ignorert pakke! Sjekk din `pacman.conf`-fil."
    Indonesia  -> p <> " merupakan paket yang diabaikan! Lihat `pacman.conf` anda."
    Chinese    -> p <> " 是一个被忽略的包！请查看你的 `pacman.conf` 文件。"
    _          -> p <> " is an ignored package! See your `pacman.conf` file."

-- NEEDS TRANSLATION
missingPkg_1 :: String -> Language -> String
missingPkg_1 (bt -> p) = \case
    Polish     -> "Zależność " <> p <> "nie została znaleziona. Musisz wyszukać pakiet, żeby spełnić zależność "
    Croatian   -> "Zavisnost  " <> p <> " nije pronađena. Pokušajte pronaći paket koji zadovoljava ovu zavisnost."
    German     -> "Die Abhängigkeit " <> p <> " wurde nicht gefunden." -- Second sentence not translated because I'm confused how it should
    Spanish    -> "La dependencia " <> p <> " no ha sido encontrada. Podría ser necesario buscar un paquete para satisfacerla."
    Norwegian  -> "Avhengigheten " <> p <> " ble ikke funnet. Du kan søke etter en pakke som tilfredsstiller avhengigheten."
    Italian    -> "La dipendenza " <> p <> " non è stata trovata. Potrebbe essere necessario cercare un pacchetto che possa soddisfarla?"
    Portuguese -> "A dependência" <> p <> " não foi achada. Talvez tenha que buscar um pacote que a satisfaça."
    French     -> "La dépendance " <> p <> " n'a pas pu être trouvée. Il vous faut trouver un paquet pour la satisfaire."
    Russian    -> "Зависимость " <> p <> " не найдена. Возможно, вам нужно поискать пакет, чтобы удовлетворить её."
    Indonesia  -> "Dependensi " <> p <> " tidak dapat ditemukan. Anda mungkin harus menemukan paket tersebut untuk mencukupi kebutuhan."
    Chinese    -> "无法找到依赖 " <> p <> "。你或许需要搜索一个包来满足这个依赖。"
    Swedish    -> "Beroendet " <> p <> " kunde inte hittas. Du kan behöva leta efter ett paket som tillfredställer det."
    _          -> "The dependency " <> p <> " could not be found. You may need to search for a package to satisfy it."

-----------------
-- aura functions
-----------------
executeOpts_1 :: Language -> String
executeOpts_1 = \case
    Japanese   -> "矛盾しているオプションがあります。"
    Polish     -> "Niektóre flagi są w konflikcie ze sobą!"
    Croatian   -> "Neke od danih zastavica nije moguće kombinirati!"
    Swedish    -> "Givna flaggor är i konflikt!"
    German     -> "Angegebene Kommandozeilen-Flags sind widersprüchlich!"
    Spanish    -> "¡Flags contradictorios!"
    Portuguese -> "Flags conflitantes!"
    French     -> "Arguments contradictoires !"
    Russian    -> "Даны конфликтующие флаги!"
    Italian    -> "Argomenti in conflitto!"
    Serbian    -> "Захтеване опције су контрадикторне!"
    Norwegian  -> "Motstridene flagg er spesifisert!"
    Indonesia  -> "Ditemukan flags yang bertabrakan!"
    Chinese    -> "指定了冲突的选项。"
    _          -> "Conflicting flags given!"

manpageMsg :: Language -> String
manpageMsg = \case
    Japanese   -> "選択肢の詳細は、auraのman pageまで。"
    Polish     -> "W podręczniku man dla aura znajduje się\xa0więcej informacji o opcjach."
    Croatian   -> "Za detalje o opcijama, pogledajte Aura man stranicu."
    Swedish    -> "Hänvisa till auras `man`-sida för detaljerade alternativ."
    German     -> "Lesen Sie die aura man-Seite für Details zu aura Optionen."
    Spanish    -> "Lee la página de manual de aura para detalles sobre las opciones."
    Portuguese -> "Leia a man page do aura para obter mais detalhes sobre as opções"
    French     -> "Lisez le manuel d'Aura (`man aura`) pour le détail des options."
    Russian    -> "Чтобы узнать подробное описание опций aura, см. мануал."
    Italian    -> "Guardare la man page di Aura per maggiori dettagli sulle opzioni."
    Serbian    -> "За детаље о опцијама, погледајте man страницу Аура."
    Norwegian  -> "Referer til Aura's `man`-side for instillingsdetaljer."
    Indonesia  -> "Lihat laman manual aura untuk opsi detail dari aura."
    Chinese    -> "请查看 aura 手册了解 aura 选项细节。"
    _          -> "See the aura man page for aura option details."

displayOutputLanguages_1 :: Language -> String
displayOutputLanguages_1 = \case
    Japanese   -> "aura は下記の言語に対応しています："
    Polish     -> "Następujące języki są dostępne:"
    Croatian   -> "Dostupni su sljedeći jezici:"
    Swedish    -> "Följande språk är tillängliga:"
    German     -> "Die folgenden Sprachen sind verfügbar:"
    Spanish    -> "Los siguientes idiomas están disponibles:"
    Portuguese -> "Os seguintes idiomas estão disponíveis:"
    French     -> "Les langues suivantes sont disponibles :"
    Russian    -> "Доступны следующие языки:"
    Italian    -> "Sono disponibili le seguenti lingue:"
    Serbian    -> "Доступни су следећи језици:"
    Norwegian  -> "Følgende språk er tilgjengelig:"
    Indonesia  -> "Berikut ini adalah bahasa yang tersedia:"
    Chinese    -> "以下语言是可用的："
    _          -> "The following languages are available:"

----------------------------
-- Aura/Commands/A functions
----------------------------
-- NEEDS TRANSLATION
auraCheck_1 :: Language -> String
auraCheck_1 = \case
    Japanese   -> "Aura が更新されています。Auraだけ先に更新しますか？"
    Polish     -> "Dostępna jest nowa wersja Aura. Czy chcesz ją najpierw aktualizować?"
    Croatian   -> "Dostupna je nova verzija Aura. Želite li prvo ažurirati?"
    German     -> "Ein Update für aura ist verfügbar. Dies zuerst aktualisieren?"
    Spanish    -> "Hay una actualización de aura disponible. ¿Deseas actualizar aura primero?"
    Norwegian  -> "En Aura-oppdatering er tilgjengelig. Oppdater den først?"
    Portuguese -> "Uma atualização para Aura está disponível. Deseja atualizar antes?"
    French     -> "Une mise à jour d'Aura est disponible. Voulez-vous la mettre à jour en premier ?"
    Russian    -> "Доступно обновление Aura. Обновить сперва её?"
    Indonesia  -> "Pemutakhiran aura tersedia. Mutakhirkan aura dulu?"
    Chinese    -> "Aura 可以升级。先升级 aura？"
    Swedish    -> "Det finns en uppdatering tillgänglig till Aura. Vill du uppdatera Aura först?"
    _          -> "Aura update available. Update it first?"

install_1 :: Language -> String
install_1 = \case
    Japanese   -> "従属パッケージの確認は以下の理由で失敗しました："
    Polish     -> "Sprawdzanie zależności nie powiodło się z następujących powodów:"
    Croatian   -> "Provjera zavisnosti nije uspjela iz sljedećih razloga:"
    Swedish    -> "Beroende-kollen misslyckades pga följande skäl:"
    German     -> "Abhängigkeitsüberprüfung schlug aus folgenden Gründen fehl:"
    Spanish    -> "La comprobación de dependencias falló por los siguientes motivos:"
    Portuguese -> "Não foi possível checar as dependências pelas seguintes razões:"
    French     -> "La vérification des dépendances a failli pour les raisons suivantes :"
    Russian    -> "Проверка зависимостей не удалась из-за:"
    Italian    -> "Il controllo delle dipendenze è fallito per i seguenti motivi:"
    Serbian    -> "Провера зависности није успела из следећих разлога:"
    Norwegian  -> "Avhengighets-sjekken mislyktes på grunn av følgende:"
    Indonesia  -> "Pemeriksaan dependensi gagal dengan alasan sebagai berikut:"
    Chinese    -> "依赖检查失败，因为："
    _          -> "Dependency checking failed for these reasons:"

install_2 :: Language -> String
install_2 = \case
    Japanese   -> "適切なパッケージを入力してください。"
    Polish     -> "Nie podano prawidłowych pakietów."
    Croatian   -> "Nije specificiran nijedan ispravan paket."
    Swedish    -> "Inga giltiga paket valda."
    German     -> "Keine gültigen Pakete angegeben."
    Spanish    -> "No se ha especificado ningún paquete válido."
    Portuguese -> "Nenhum pacote válido foi especificado."
    French     -> "Aucun paquet valide n'a été spécifié."
    Russian    -> "Валидные пакеты не указаны."
    Italian    -> "Nessun pacchetto valido specificato."
    Serbian    -> "Ниједан исправан пакет није специфициран."
    Norwegian  -> "Ingen gyldige pakker er valgte."
    Indonesia  -> "Tidak ada paket valid yang dispesifikkan."
    Chinese    -> "没有指定有效的包。"
    _          -> "No valid packages specified."

install_3 :: Language -> String
install_3 = \case
    Japanese   -> "続行しますか？"
    Polish     -> "Kontynuować?"
    Croatian   -> "Nastaviti?"
    Swedish    -> "Fortsätta?"
    German     -> "Fortsetzen?"
    Spanish    -> "¿Continuar?"
    Portuguese -> "Continuar?"
    French     -> "Continuer ?"
    Russian    -> "Продолжить?"
    Italian    -> "Continuare?"
    Serbian    -> "Наставити?"
    Norwegian  -> "Fortsett?"
    Indonesia  -> "Lanjut?"
    Chinese    -> "继续？"
    _          -> "Continue?"

install_4 :: Language -> String
install_4 = \case
    Japanese   -> "続行は意図的に阻止されました。"
    Polish     -> "Instalacja została przerwana przez użytkownika."
    Croatian   -> "Instalacija prekinuta od strane korisnika."
    Swedish    -> "Installationen avbröts manuellt."
    German     -> "Installation durch Benutzer abgebrochen."
    Spanish    -> "Instalación abortada manualmente."
    Portuguese -> "Instalação manual abortada."
    French     -> "Installation manuelle annulée."
    Russian    -> "Пользователь прервал установку."
    Italian    -> "Installazione manuale interrotta."
    Serbian    -> "Инсталација је ручно прекинута."
    Norwegian  -> "Installasjonen ble avbrutt manuelt."
    Indonesia  -> "Instalasi dibatalkan secara paksa."
    Chinese    -> "手动安装已中止。"
    _          -> "Installation manually aborted."

install_5 :: Language -> String
install_5 = \case
    Japanese   -> "従属パッケージを確認中・・・"
    Polish     -> "Ustalanie zależności..."
    Croatian   -> "Određivanje zavisnosti..."
    Swedish    -> "Avgör beroenden..."
    German     -> "Bestimme Abhängigkeiten..."
    Spanish    -> "Determinando dependencias..."
    Portuguese -> "Determinando as dependências..."
    French     -> "Détermination des dépendances en cours…"
    Russian    -> "Определение зависимостей..."
    Italian    -> "Determinazione dipendenze..."
    Serbian    -> "Утврђивање зависности..."
    Norwegian  -> "Bestemmer avhengigheter..."
    Indonesia  -> "Menentukan dependensi..."
    Chinese    -> "确定依赖中..."
    _          -> "Determining dependencies..."

-- 2014 December  7 @ 14:45 - NEEDS TRANSLATIONS
confirmIgnored_1 :: String -> Language -> String
confirmIgnored_1 (bt -> p) = \case
    Japanese   -> p <> "は無視されるはずのパッケージです。それでも続行しますか？"
    Polish     -> p <> " jest oznaczony jako ignorowany. Zainstalować mimo tego?"
    Spanish    -> p <> " está marcado como ignorado. ¿Deseas instalarlo de todas formas?"
    Portuguese -> p <> " está marcado como Ignored. Instalá-lo mesmo assim?"
    Russian    -> p <> " отмечен как игнорируемый. Всё равно установить?"
    Chinese    -> p <> " 已被标记为忽略。仍然安装？"
    Swedish    -> p <> " är markerad som ignorerad. Vill du installera ändå?"
    _          -> p <> " is marked as Ignored. Install anyway?"

-- NEEDS UPDATE TO REFLECT CHANGED ENGLISH
reportNonPackages_1 :: Language -> String
reportNonPackages_1 = \case
    Japanese   -> "下記はAURパッケージではありません："
    Polish     -> "To nie są pakiety:"
    Croatian   -> "Ovo nisu AUR paketi:"
    Swedish    -> "Följande är inte paket:"
    German     -> "Folgende sind keine AUR-Pakete:"
    Spanish    -> "Los siguientes paquetes no son de AUR:"
    Portuguese -> "Os seguintes não são pacotes AUR:"
    French     -> "Les éléments suivants ne sont pas des paquets AUR :"
    Russian    -> "Ниже указано то, что не является пакетами AUR:"
    Italian    -> "I seguenti pacchetti non sono presenti in AUR:"
    Serbian    -> "Ово нису пакети:"
    Norwegian  -> "Det følgende er ikke AUR-pakker:"
    Indonesia  -> "Paket berikut ini bukan merupakan paket AUR:"
    Chinese    -> "以下软件不是 AUR 包："
    _          -> "The following are not AUR packages:"

reportIgnoredPackages_1 :: Language -> String
reportIgnoredPackages_1 = \case
    Japanese   -> "下記のパッケージは無視されます："
    Polish     -> "Poniższe pakiety zostaną zignorowane:"
    Croatian   -> "Sljedeći paketi će biti ignorirani:"
    Swedish    -> "Följande paket kommer att ignoreras: "
    German     -> "Die folgenden Pakete werden ignoriert:"
    Spanish    -> "Los siguientes paquetes serán ignorados:"
    Portuguese -> "Os seguintes pacotes serão ignorados:"
    French     -> "Les paquets suivants seront ignorés :"
    Russian    -> "Следующие пакеты будут проигнорированы:"
    Italian    -> "I seguenti pacchetti verranno ignorati:"
    Serbian    -> "Следећи пакети ће бити игнорисани:"
    Norwegian  -> "De følgende pakker vil bli ignorert:"
    Indonesia  -> "Paket berikut ini akan diabaikan:"
    Chinese    -> "以下包将会被忽略："
    _          -> "The following packages will be ignored:"

-- NEEDS TRANSLATION
reportUnneededPackages_1 :: Language -> String
reportUnneededPackages_1 = \case
    Japanese   -> "下記のパッケージは既にインストールされています："
    Polish     -> "Następujące pakiety zostały już zainstalowane:"
    Portuguese -> "Os seguintes pacotes já estão instalados:"
    Russian    -> "Следующие пакеты уже установлены:"
    German     -> "Die folgenden Pakete sind bereits installiert:"
    Spanish    -> "Los siguientes paquetes ya están instalados:"
    Chinese    -> "以下包已被安装："
    Swedish    -> "Följande paket är redan installerade:"
    _          -> "The following packages are already installed:"

reportPkgsToInstall_1 :: Language -> String
reportPkgsToInstall_1 = \case
    Japanese   -> "Pacmanの従属パッケージ："
    Polish     -> "Zależności z repozytoriów:"
    Croatian   -> "Zavisnosti iz repozitorija:"
    Swedish    -> "Beroenden ifrån lager:"
    German     -> "Abhängigkeiten in den Paketquellen:"
    Spanish    -> "Dependencias del repositorio:"
    Portuguese -> "Dependências no repositório:"
    French     -> "Dépendances du dépôt :"
    Russian    -> "Зависимости из репозитория:"
    Italian    -> "Dipendenze nei repository:"
    Serbian    -> "Зависности из ризница:"
    Norwegian  -> "Avhengigheter fra depotet:"
    Indonesia  -> "Dependensi dari repositori:"
    Chinese    -> "仓库依赖："
    _          -> "Repository dependencies:"

-- NEEDS AN UPDATE
reportPkgsToInstall_2 :: String -> Language -> String
reportPkgsToInstall_2 l = \case
    Japanese   -> l <> "のパッケージ:"
    Polish     -> l <> " Pakiety:"
    Croatian   -> l <> " Paketi:"
    German     -> l <> " Pakete:"
    Spanish    -> l <> " Paquetes:"
    Norwegian  -> l <> " Pakker:"
    Italian    -> l <> " Pacchetti:"
    Portuguese -> l <> " Pacotes :"
    French     -> l <> " Paquets :"
    Russian    -> l <> " Пакеты:"
    Indonesia  -> l <> " Paket:"
    Chinese    -> l <> " 包："
    Swedish    -> l <> " Paket:"
    _          -> l <> " Packages:"

{-}
reportPkgsToInstall_2 :: String -> Language -> String
reportPkgsToInstall_2 l = \case
    Japanese   -> l <> "の従属パッケージ："
    Polish     -> "Zależności z " <> l <> ":"
    Croatian   -> "Zavisnosti iz " <> l <> "-a:"
    Swedish    -> "Beroenden ifrån " <> l <> ":"
    German     -> "Abhängigkeiten im " <> l <> ":"
    Spanish    -> "Dependencias en " <> l <> ":"
    Portuguese -> "Dependências no " <> l <> ":"
    French     -> "Dépendances " <> l <> "\xa0:"
    Russian    -> "Зависимости из " <> l <> ":"
    Italian    -> "Dipendenze in " <> l <> ":"
    Serbian    -> "Зависности из " <> l <> "-а:"
    Norwegian  -> "Avhengigheter fra " <> l <> ":"
    _          -> l <> " dependencies:"

reportPkgsToInstall_3 :: String -> Language -> String
reportPkgsToInstall_3 l = \case
    Japanese   -> "主な" <> l <> "パッケージ："
    Polish     -> "Główne pakiety z " <> l <> ":"
    Croatian   -> "Glavni " <> l <> " paketi:"
    Swedish    -> "Huvudpaket ifrån " <> l <> ":"
    German     -> "Hauptpaket aus dem " <> l <> ":"
    Spanish    -> "Paquetes principales de " <> l <> ":"
    Portuguese -> "Pacotes principais do " <> l <> ":"
    French     -> "Principaux paquets " <> l <> "\xa0:"
    Russian    -> "Главные пакеты из " <> l <> ":"
    Italian    -> "Pacchetto principale di " <> l <> ":"
    Serbian    -> "Главни пакети из " <> l <> "-а:"
    Norwegian  -> "Hovedpakker fra " <> l <> ":"
    _          -> "Main " <> l <> " packages:"
-}

-- NEEDS TRANSLATION
reportPkgbuildDiffs_1 :: String -> Language -> String
reportPkgbuildDiffs_1 (bt -> p) = \case
    Japanese   -> p <> "のPKGBUILDはまだ保存されていません。"
    Polish     -> p <> " nie ma jeszcze przechowywanego pliku PKGBUILD."
    Croatian   -> p <> " još nema pohranjen PKGBUILD."
    German     -> p <> " hat noch keinen gespeicherten PKGBUILD."
    Spanish    -> p <> " no tiene un PKGBUILD almacenado aún."
    Portuguese -> p <> " não possui PKGBUILD."
    French     -> p <> " n'a pas encore de PKGBUILD enregistré."
    Russian    -> "У " <> p <> " ещё нет сохраненного PKGBUILD."
    Italian    -> p <> " non ci sono PKGBUILD salvati"
    Serbian    -> p <> " још нема похрањен PKGBUILD."
    Norwegian  -> p <> " har ingen PKGBUILD ennå."
    Indonesia  -> p <> " tidak mempunyai PKGBUILD yang tersimpan untuk saat ini."
    Chinese    -> p <> " 还没有保存的 PKGBUILD。"
    Swedish    -> p <> " har ännu ingen PKGBUILD."
    _          -> p <> " has no stored PKGBUILD yet."

-- NEEDS TRANSLATION
reportPkgbuildDiffs_2 :: String -> Language -> String
reportPkgbuildDiffs_2 (bt -> p) = \case
    Japanese   -> p <> "のPKGBUILDは最新です。"
    Polish     -> "PKGBUILD pakietu " <> p <> " jest aktualny."
    Croatian   -> "PKGBUILD paketa " <> p <> " je na najnovijoj verziji."
    German     -> "PKGBUILD von " <> p <> " ist aktuell."
    Spanish    -> "El PKGBUILD de " <> p <> " está actualizado."
    Portuguese -> "O PKGBUILD de " <> p <> "está atualizado."
    Russian    -> "PKGBUILD " <> p <> " является новейшим."
    French     -> "Le PKGBUILD de " <> p <> " est à jour."
    Italian    -> "Il PKGBUILD di " <> p <> " è aggiornato."
    Serbian    -> "PKGBUILD пакета " <> p <> " је ажуран."
    Norwegian  -> p <> "'s PKGBUILD er oppdatert."
    Indonesia  -> "PKGBUILD dari paket " <> p <> " sudah mutakhir."
    Chinese    -> p <> " 的 PKGBUILD 已经最新。"
    Swedish    -> "PKGBUILD för " <> p <> " är aktuell."
    _          -> p <> " PKGBUILD is up to date."

-- NEEDS TRANSLATION
reportPkgbuildDiffs_3 :: String -> Language -> String
reportPkgbuildDiffs_3 (bt -> p) = \case
    Japanese   -> p <> "のPKGBUILD変更報告："
    Polish     -> "Zmiany w PKGBUILD dla " <> p <> ":"
    Croatian   -> "Promjene u PKGBUILD-u za " <> p <> ":"
    German     -> "PKGBUILD-Änderungen von " <> p <> ":"
    Spanish    -> "Cambios en el PKGBUILD de " <> p <> ":"
    Portuguese -> p <> " não tem PKGBUILD."
    Russian    -> "Изменения, вносимые " <> p <> " PKGBUILD:"
    French     -> "Changements du PKGBUILD de " <> p <> " :"
    Italian    -> "Cambiamenti nel PKGBUILD di " <> p <>":"
    Serbian    -> "Промене PKGBUILD-a за " <> p <> ":"
    Norwegian  -> p <> "'s endringer i PKGBUILD:"
    Indonesia  -> "Perubahan PKGBUILD " <> p <> ":"
    Chinese    -> p <> " 的 PKGBUILD 变化："
    Swedish    -> "Förändringar i PKGBUILD för " <> p <> ":"
    _          -> p <> " PKGBUILD changes:"

-- NEEDS TRANSLATION
reportPkgsToUpgrade_1 :: Language -> String
reportPkgsToUpgrade_1 = \case
    Japanese   -> "アップグレードするAURパッケージ："
    Polish     -> "Pakiety z AUR do zaktualizowania:"
    Croatian   -> "AUR paketi za nadogradnju:"
    Swedish    -> "AUR-paket att uppgradera:"
    German     -> "Zu aktualisierendes AUR-Paket:"
    Spanish    -> "Paquetes de AUR a actualizar:"
    Portuguese -> "Pacotes do AUR para atualizar:"
    French     -> "Paquets AUR à mettre à jour :"
    Russian    -> "Пакеты AUR, готовые для обновления:"
    Italian    -> "Pacchetti in AUR da aggiornare:"
    Serbian    -> "Пакети из AUR-а за надоградњу:"
    Norwegian  -> "AUR-pakker å oppgradere:"
    Indonesia  -> "Paket AUR yang akan ditingkatkan:"
    Chinese    -> "要升级的 AUR 包："
    _          -> "AUR Packages to upgrade:"

-- NEEDS UPDATING
reportBadDowngradePkgs_1 :: Language -> String
reportBadDowngradePkgs_1 = \case
    Japanese   -> "このパッケージはキャッシュには入っていないので、ダウングレードできません。"
    Polish     -> "Poniższe pakeity nie są zainstalowane, i nie mogą być zainstalowane w starszej wersji:"
    Croatian   -> "Sljedeći paketi nisu instalirani te se stoga ne mogu vratiti na stare verzije:"
    Swedish    -> "Följande paket är inte installerade, och kan därför inte bli nergraderade:"
    German     -> "Folgende Pakete sind in keiner Version im Cache und können daher nicht gedowngradet werden:"
    Spanish    -> "Los siguientes paquetes no tienen versiones en la caché, por lo que no se pueden bajar a versiones anteriores:"
    Portuguese -> "Os seguintes pacotes não estão instalados, logo não podem retornar a uma versão anterior:"
    French     -> "Aucune version des paquets suivants n'est présente dans le cache ; ils ne peuvent pas être mis à niveau à une version antérieure :"
    Russian    -> "Следующих пакетов нет в кэше. Следовательно, они не могут быть откачены к старой версии:"
    Italian    -> "I seguenti pacchetti non hanno versioni in cache e non posso essere retrocessi:"
    Serbian    -> "Следећи пакети нису ни инсталирани, те се не могу вратити на старију верзију:"
    Norwegian  -> "Følgende pakker har ingen versjoner i cache, og kan derfor ikke bli nedgradert:"
    Indonesia  -> "Berikut ini tidak mempunyai versi pada cache, sehingga tidak akan diturunkan:"
    Chinese    -> "以下包在缓存中没有版本，所以无法被降级："
    _          -> "The following have no versions in the cache, and thus can’t be downgraded:"

upgradeAURPkgs_1 :: Language -> String
upgradeAURPkgs_1 = \case
    Japanese   -> "パッケージ情報をダウンロード中・・・"
    Polish     -> "Pobieranie informacji o pakietach..."
    Croatian   -> "Preuzimanje podataka o paketima..."
    Swedish    -> "Hämtar paketinformation..."
    German     -> "Rufe Paketinformationen ab..."
    Spanish    -> "Obteniendo información de los paquetes..."
    Portuguese -> "Obtendo informação dos pacotes..."
    French     -> "Obtention des informations des paquets en cours…"
    Russian    -> "Сборка информации о пакетах..."
    Italian    -> "Ottengo le informazioni del pacchetto..."
    Serbian    -> "Преузимање информација о пакетима..."
    Norwegian  -> "Henter pakkeinformasjon..."
    Indonesia  -> "Mengambil informasi paket..."
    Chinese    -> "正在获取包信息..."
    _          -> "Fetching package information..."

upgradeAURPkgs_2 :: Language -> String
upgradeAURPkgs_2 = \case
    Japanese   -> "バージョンを比較中・・・"
    Polish     -> "Porównywanie wersji pakietów..."
    Croatian   -> "Uspoređivanje verzija paketa..."
    Swedish    -> "Jämför paket-versioner..."
    German     -> "Vergleiche Paketversionen..."
    Spanish    -> "Comparando versiones de los paquetes..."
    Portuguese -> "Comparando versões dos pacotes..."
    French     -> "Comparaison des versions des paquets en cours…"
    Russian    -> "Сравнение версий пакетов..."
    Italian    -> "Confronto le ersioni del pacchetto..."
    Serbian    -> "Упоређивање верзија пакета..."
    Norwegian  -> "Sammenligner pakkeversjoner..."
    Indonesia  -> "Membandingkan versi paket..."
    Chinese    -> "正在比较包的版本..."
    _          -> "Comparing package versions..."

upgradeAURPkgs_3 :: Language -> String
upgradeAURPkgs_3 = \case
    Japanese   -> "アップグレードは必要ありません。"
    Polish     -> "Nie jest wymagana aktualizacja pakietów z AUR."
    Croatian   -> "Svi AUR paketi su ažurirani."
    Swedish    -> "Inga AUR-paketsuppgraderingar behövs."
    German     -> "Keine Aktualisierungen für AUR-Paket notwendig."
    Spanish    -> "No es necesario actualizar paquetes de AUR."
    Portuguese -> "Nenhum pacote do AUR precisa de atualização."
    French     -> "Aucune mise à jour de paquet AUR n'est nécessaire."
    Russian    -> "Обновление пакетов из AUR не требуется."
    Italian    -> "Non è necessario aggiornare pacchetti di AUR."
    Serbian    -> "Ажурирање пакета из AUR-а није потребно."
    Norwegian  -> "Ingen pakkeoppgradering fra AUR nødvendig."
    Indonesia  -> "Tidak ada peningkatan AUR yang dibutuhkan."
    Chinese    -> "没有需要升级的 AUR 包。"
    _          -> "No AUR package upgrades necessary."

downloadTarballs_1 :: String -> Language -> String
downloadTarballs_1 (bt -> p) = \case
    Japanese   -> p <> "のソースコードの tarball をダウンロード中・・・"
    Polish     -> "Pobieranie paczki źródłowej " <> p <> "..."
    Croatian   -> "Preuzimanje izvornog paketa (tarball) " <> p <> "..."
    Swedish    -> "Laddar ner " <> p <> " källkodspaket (tarball)..."
    German     -> "Lade Quelltext (tarball) von " <> p <> " herunter..."
    Spanish    -> "Descargando los ficheros fuente comprimidos (tarball) de " <> p <> " ..."
    Portuguese -> "Baixando os fontes (tarball) de " <> p <> " ..."
    French     -> "Téléchargement de l'archive de " <> p <> " en cours…"
    Russian    -> "Загрузка исходного архива " <> p <> "..."
    Italian    -> "Downlaod del tarball di " <> p <> " in corso..."
    Serbian    -> "Преузимање архиве изворног кода за " <> p <> "..."
    Norwegian  -> "Laster ned " <> p <> " kildekodepakken (tarball)..."
    Indonesia  -> "Mengunduh tarbal untuk paket " <> p <> "..."
    Chinese    -> "正在下载 " <> p <> " 的源文件..."
    _          -> "Downloading " <> p <> " source tarball..."

displayPkgbuild_1 :: String -> Language -> String
displayPkgbuild_1 (bt -> p) = \case
    Japanese   -> p <> "は存在しません。"
    Polish     -> p <> " nie istnieje."
    Croatian   -> p <> " ne postoji."
    Swedish    -> p <> " finns inte."
    German     -> p <> " existiert nicht."
    Spanish    -> p <> " no existe."
    Portuguese -> p <> " não existe."
    French     -> p <> " n'existe pas."
    Russian    -> p <> " не существует."
    Italian    -> p <> " inesistente."
    Serbian    -> p <> " не постоји."
    Norwegian  -> p <> " finnes ikke."
    Indonesia  -> p <> " tidak ada."
    Chinese    -> p <> " 不存在。"
    _          -> p <> " does not exist."

removeMakeDepsAfter_1 :: Language -> String
removeMakeDepsAfter_1 = \case
    Japanese   -> "あと片付け。必要ないパッケージを削除："
    Polish     -> "Usuwanie niepotrzebnych zależności potrzebnych do budowy..."
    Croatian   -> "Uklanjanje nepotrebnih zavisnosti vezanih uz izgradnju..."
    Swedish    -> "Tar bort obehövda beroenden för `make`..."
    German     -> "Entferne nicht benötigte make-Abhängigkeiten..."
    Spanish    -> "Removiendo dependencias `make` innecesarias..."
    Portuguese -> "Removendo dependências `make` desnecessárias..."
    French     -> "Suppression des dépendances inutiles…"
    Russian    -> "Удаление ненужных зависимостей make..."
    Italian    -> "Rimuovo le dipendenze di compilazione..."
    Serbian    -> "Уклањање непотребних зависности за изградњу..."
    Norwegian  -> "Fjerner unødvendige make-avhengigheter..."
    Indonesia  -> "Menghapus dependensi `make` yang tidak dibutuhkan..."
    Chinese    -> "移除不需要的 make 依赖..."
    _          -> "Removing unneeded make dependencies..."

----------------------------
-- Aura/Commands/B functions
----------------------------
-- NEEDS TRANSLATION
cleanStates_1 :: Language -> String
cleanStates_1 = \case
    Japanese   -> "数字は入力できせん。"
    Polish     -> "Dane wejściowe nie są poprawną liczbą"
    Croatian   -> "Unos ne predstavlja broj."
    German     -> "Eingabe ist keine gültige Zahl."
    Spanish    -> "El valor introducido no es un número válido."
    Serbian    -> "Улаз није валидан број."
    Norwegian  -> "Oppføringen er ikke et gyldig nummer."
    Italian    -> "Non è un numero valido."
    Portuguese -> "Valor entrado não é um número válido."
    French     -> "La valeur entrée n'est pas un nombre valide."
    Russian    -> "Введенные данные -- не валидное число."
    Indonesia  -> "Masukan bukan angka valid."
    Chinese    -> "输入不是一个有效的数字。"
    Swedish    -> "Indata är inte ett tal."
    _          -> "Input isn't a valid number."

-- NEEDS TRANSLATION
cleanStates_2 :: Int -> Language -> String
cleanStates_2 (bt . show -> n) = \case
    Japanese   -> n <> "個のパッケージ状態記録だけが残される。その他削除？"
    Polish     -> n <> " stan pakietów zostanie zachowany. Usunąć resztę?"
    Croatian   -> n <> " stanja paketa će biti zadržano. Ukloniti ostatak?"
    German     -> n <> " Paketzustände werden behalten. Den Rest entfernen?"
    Spanish    -> "El estado del paquete" <> n <> " se mantendrá. ¿Deseas eliminar el resto?"
    Serbian    -> n <> " стања пакета ће бити сачувано. Уклонити остатак?"
    Norwegian  -> n <> " pakketilstander vil bli beholdt. Vil du fjerne resten?"
    Italian    -> n <> " lo stato dei pacchetti sarà mantenuto. Rimuovere i rimanenti?"
    Portuguese -> n <> " estados de pacotes serão mantidos. Remover o resto?"
    French     -> n <> " états des paquets vont être conservés. Supprimer le reste ?"
    Russian    -> n <> " -- столько состояний пакетов будут оставлены. Удалить оставшиеся?"
    Indonesia  -> n <> " paket akan tetap sama. Hapus yang lainnya?"
    Chinese    -> n <> " 个包的状态将会保留。删除其它的？"
    Swedish    -> n <> " paket kommer att bevaras. Ta bort resten?"
    _          -> n <> " package states will be kept. Remove the rest?"

-- NEEDS TRANSLATION
cleanStates_3 :: Language -> String
cleanStates_3 = \case
    Japanese   -> "何も削除しないで終了します。"
    Polish     -> "Żaden stan pakietu nie został usunięty."
    Croatian   -> "Nijedno stanje paketa nije uklonjeno."
    German     -> "Keine Paketzustände wurden entfernt."
    Spanish    -> "No se han eliminado estados de los paquetes."
    Serbian    -> "Ниједно стање пакета није уклоњено."
    Norwegian  -> "Ingen pakketilstander ble fjernet."
    Italian    -> "Nessuno stato di pacchetto verrà rimosso."
    Portuguese -> "Nenhum estado de pacote será removido."
    French     -> "Aucun état des paquets n'a été supprimé."
    Russian    -> "Состояния пакетов отались нетронутыми."
    Indonesia  -> "Tidak ada paket yang dihapus."
    Chinese    -> "没有删除任何包。"
    Swedish    -> "Inga paket togs bort."
    _          -> "No package states were removed."

----------------------------
-- Aura/Commands/C functions
----------------------------
getDowngradeChoice_1 :: String -> Language -> String
getDowngradeChoice_1 (bt -> p) = \case
    Japanese   -> p <> "はどのバージョンにしますか？"
    Polish     -> "Którą wersję pakietu " <> p <> " zainstalować?"
    Croatian   -> "Koju verziju paketa " <> p <> " želite?"
    Swedish    -> "Vilken version av " <> p <> " vill du ha?"
    German     -> "Welche Version von " <> p <> " möchten Sie haben?"
    Spanish    -> "¿Qué versión de " <> p <> " deseas?"
    Portuguese -> "Qual versão de " <> p <> " deseja?"
    French     -> "Quelle version de " <> p <> " voulez-vous ?"
    Russian    -> "Какую версию " <> p <> " вы хотите?"
    Italian    -> "Quale versione di " <> p <> " preferisci?"
    Serbian    -> "Коју верзију " <> p <> "-а желите?"
    Norwegian  -> "Hvilken versjon av " <> p <> " vil du ha?"
    Indonesia  -> "Versi dari paket " <> p <> " mana yang anda inginkan?"
    Chinese    -> "你希望安装 " <> p <> " 的哪个版本？"
    _          -> "What version of " <> p <> " do you want?"

backupCache_1 :: Language -> String
backupCache_1 = \case
    Japanese   -> "バックアップ先を入力してください。"
    Polish     -> "Nie podano lokalizacji kopii zapasowych."
    Croatian   -> "Lokacija sigurnosne kopije nije specifirana."
    Swedish    -> "Ingen backup-plats specifierad."
    German     -> "Kein Sicherungsort angegeben."
    Spanish    -> "No se ha especificado localización para la copia de seguridad."
    Portuguese -> "Ainda não disse onde quer guardar o backup..."
    French     -> "Aucun chemin pour les copies de sauvegarde n'est spécifié."
    Russian    -> "Не указан путь к бэкапу."
    Italian    -> "Path per il salvataggio non specificato."
    Serbian    -> "Није дата путања ка бекапу."
    Norwegian  -> "Ingen backup-plass spesifisert."
    Indonesia  -> "Tidak ada lokasi backup yang diberikan."
    Chinese    -> "没有指定备份位置。"
    _          -> "No backup location given."

backupCache_2 :: Language -> String
backupCache_2 = \case
    Japanese   -> "root でないとバックアップはできません。"
    Polish     -> "Musisz być rootem, by zrobić kopię\xa0zapasową pamięci podręcznej."
    Croatian   -> "Za stvaranje sigurnosne kopije cache-a potrebne su root ovlasti."
    Swedish    -> "Du måste vara root för att ta backup på cache-filer."
    German     -> "Sie müssen root sein um den Cache zu sichern."
    Spanish    -> "Debes ser root para hacer una copia de seguridad de la caché."
    Portuguese -> "Precisa ser root para fazer um backup do cache."
    French     -> "Vous devez être `root` pour faire une copie de sauvegarde du cache."
    Russian    -> "Чтобы создать бэкап кэша, вы должны быть рутом"
    Italian    -> "Devi essere root per salvare la cache."
    Serbian    -> "Морате бити root да бисте бекаповали кеш."
    Norwegian  -> "Du må være root for å ta backup på cache."
    Indonesia  -> "Anda harus menjadi root untuk mem-`backup` cache."
    Chinese    -> "只有根用户才能备份缓存。"
    _          -> "You must be root to backup the cache."

backupCache_3 :: Language -> String
backupCache_3 = \case
    Japanese   -> "バックアップ先は存在しません。"
    Polish     -> "Lokalizacja kopii zapasowych nie istnieje."
    Croatian   -> "Lokacija sigurnosne kopije ne postoji."
    Swedish    -> "Specifierad backup-plats finns inte."
    German     -> "Der Sicherungsort existiert nicht."
    Spanish    -> "La localización para copia de seguridad no existe."
    Portuguese -> "O caminho indicado para o backup não existe."
    French     -> "Le chemin des copies de sauvegarde spécifié n'existe pas."
    Russian    -> "Путь к бэкапу не существует."
    Italian    -> "L'indirizzo del salvataggio non esiste."
    Serbian    -> "Путања ка бекапу не постоји."
    Norwegian  -> "Spesifisert backup-plass finnes ikke."
    Indonesia  -> "Lokasi `backup` tidak ada."
    Chinese    -> "备份位置不存在。"
    _          -> "The backup location does not exist."

backupCache_4 :: FilePath -> Language -> String
backupCache_4 (bt -> dir) = \case
    Japanese   -> "キャッシュのバックアップ先：" <> dir
    Polish     -> "Tworzenie kopii zapasowej pamięci podręcznej w " <> dir
    Croatian   -> "Stvaram sigurnosnu kopiju u " <> dir
    Swedish    -> "Tar backup på cache-filer till " <> dir
    German     -> "Sichere Cache in " <> dir
    Spanish    -> "Haciendo una copia de seguridad de la caché en " <> dir
    Portuguese -> "Backup do cache sendo feito em " <> dir
    French     -> "Copie de sauvegarde dans " <> dir <> "."
    Russian    -> "Бэкап создается в директории " <> dir
    Italian    -> "Salvataggio della chace in " <> dir
    Serbian    -> "Бекапујем кеш у " <> dir
    Norwegian  -> "Tar backup på cache til " <> dir
    Indonesia  -> "Melakukan `backup` pada direktori " <> dir
    Chinese    -> "正在将缓存备份到 " <> dir
    _          -> "Backing up cache to " <> dir

backupCache_5 :: Int -> Language -> String
backupCache_5 (bt . show -> n) = \case
    Japanese   -> "パッケージのファイル数：" <> n
    Polish     -> "Pliki będące częścią\xa0kopii zapasowej: " <> n
    Croatian   -> "Datoteke koje su dio sigurnosne kopije: " <> n
    Swedish    -> "Paket-filer att ta backup på: " <> n
    German     -> "Zu sichernde Paketdateien: " <> n
    Spanish    -> "Ficheros de paquetes de los que se hará copia de seguridad: " <> n
    Portuguese -> "Arquivos de pacotes para backup: " <> n
    French     -> "Copie de sauvegarde des fichiers de paquets suivants : " <> n
    Russian    -> "Файлы пакета для бэкапа: " <> n
    Italian    -> "File del pacchetto da salvare: " <> n
    Serbian    -> "Датотеке за бекап: " <> n
    Norwegian  -> "Pakker som blir tatt backup på: " <> n
    Indonesia  -> "Jumlah paket yang di-`backup`: " <> n
    Chinese    -> "将要备份的包文件：" <> n
    _          -> "Package files to backup: " <> n

backupCache_6 :: Language -> String
backupCache_6 = \case
    Japanese   -> "バックアップを実行しますか？"
    Polish     -> "Kontynuować tworzenie kopii zapasowej?"
    Croatian   -> "Nastavi sa stvaranjem sigurnosne kopije?"
    Swedish    -> "Fortsätt med backup?"
    German     -> "Sicherung fortsetzen?"
    Spanish    -> "¿Proceder con la copia de seguridad?"
    Portuguese -> "Proceder com o backup?"
    French     -> "Procéder à la copie de sauvegarde ?"
    Russian    -> "Продолжить создание бэкапа?"
    Italian    -> "Procedere con il salvataggio?"
    Serbian    -> "Наставити бекаповање?"
    Norwegian  -> "Fortsett med backup?"
    Indonesia  -> "Lanjutkan dengan `backup`?"
    Chinese    -> "开始备份？"
    _          -> "Proceed with backup?"

backupCache_7 :: Language -> String
backupCache_7 = \case
    Japanese   -> "バックアップは意図的に阻止されました。"
    Polish     -> "Tworzenie kopii zapasowej zostało przerwane przez użytkownika."
    Croatian   -> "Stvaranje sigurnosne kopije prekinuto od strane korisnika."
    Swedish    -> "Backup avbröts manuellt."
    German     -> "Backup durch Benutzer abgebrochen."
    Spanish    -> "Copia de seguridad abortada manualmente."
    Portuguese -> "Backup manualmente abortado."
    French     -> "Copie de sauvegarde manuelle annulée."
    Russian    -> "Создание бэкапа прервано пользователем."
    Italian    -> "Salvataggio manuale interrotto."
    Serbian    -> "Бекаповање је ручно прекинуто."
    Norwegian  -> "Backup ble avbrutt manuelt."
    Indonesia  -> "Proses `backup` dibatalkan secara paksa."
    Chinese    -> "手动备份已中止。"
    _          -> "Backup manually aborted."

backupCache_8 :: Language -> String
backupCache_8 = \case
    Japanese   -> "バックアップ中。数分かかるかもしれません。"
    Polish     -> "Tworzenie kopii zapasowej. To może potrwać kilka minut..."
    Croatian   -> "Stvaranje sigurnosne kopije. Ovo može potrajati nekoliko minuta..."
    Swedish    -> "Tar backup. Det här kan ta ett tag..."
    German     -> "Sichere. Dies kann einige Minuten dauern..."
    Spanish    -> "Haciendo copia de seguridad. Esto puede tardar unos minutos..."
    Portuguese -> "Efetuando backup. Isso pode levar alguns minutos..."
    French     -> "Copie de sauvegarde en cours. Ceci peut prendre quelques minutes…"
    Russian    -> "Создается бэкап. Это может занять пару минут..."
    Italian    -> "Salvataggio. Questo potrebbe richiedere qualche minuto..."
    Serbian    -> "Бекапујем. Ово може да потраје пар минута..."
    Norwegian  -> "Tar backup. Dette kan ta en stund..."
    Indonesia  -> "Melakukan `backup`. Proses ini akan berjalan untuk beberapa menit..."
    Chinese    -> "正在备份中。可能需要几分钟的时间..."
    _          -> "Backing up. This may take a few minutes..."

copyAndNotify_1 :: Int -> Language -> String
copyAndNotify_1 (cyan . show -> n) = \case
    Japanese   -> "#[" <> n <>"]をコピー中・・・"
    Polish     -> "Kopiowanie #[" <> n <> "]"
    Croatian   -> "Kopiranje #[" <> n <> "]"
    Swedish    -> "Kopierar #[" <> n <> "]"
    German     -> "Kopiere #[" <> n <> "]"
    Spanish    -> "Copiando #[" <> n <> "]"
    Portuguese -> "Copiando #[" <> n <> "]"
    French     -> "Copie de #[" <> n <> "]"
    Russian    -> "Копируется #[" <> n <> "]"
    Italian    -> "Copiando #[" <>n <> "]"
    Serbian    -> "Копирам #[" <> n <> "]"
    Norwegian  -> "Kopierer #[" <> n <> "]"
    Indonesia  -> "Menyalin #[" <> n <> "]"
    Chinese    -> "正在复制 #[" <> n <> "]"
    _          -> "Copying #[" <> n <> "]"

preCleanCache_1 :: String -> Language -> String
preCleanCache_1 n = \case
    Japanese   -> n <> "は数字ではありません。"
    Polish     -> n <> " nie jest liczbą."
    Croatian   -> n <> " nije broj. "
    Swedish    -> n <> " är inte ett nummer."
    German     -> n <> " ist keine Nummer."
    Spanish    -> n <> " no es un número."
    Portuguese -> n <> " não é um número."
    French     -> n <> " n'est pas un nombre."
    Russian    -> n <> " не является числом."
    Italian    -> n <> " non è un numero."
    Serbian    -> n <> " није број."
    Norwegian  -> n <> " er ikke et nummer."
    Indonesia  -> n <> " bukan angka, coy!"
    Chinese    -> n <> " 不是一个数字。"
    _          -> n <> " is not a number."

cleanCache_1 :: Language -> String
cleanCache_1 = \case
    Japanese   -> "入力の数字は適切ではありません。"
    Polish     -> "Nieprawidłowa liczba."
    Croatian   -> "Broj nije ispravan."
    Swedish    -> "Ogiltigt nummer specifierat."
    German     -> "Ungültige Nummer gegeben."
    Spanish    -> "Número inválido."
    Portuguese -> "Número inválido."
    French     -> "Nombre donné invalide."
    Russian    -> "Дано невалидное число."
    Italian    -> "Numero non valido."
    Serbian    -> "Број није валидан."
    Norwegian  -> "Ugyldig number spesifisert."
    Indonesia  -> "Angka yang diberikan tidak valid."
    Chinese    -> "指定了无效的数字。"
    _          -> "Invalid number given."

cleanCache_2 :: Language -> String
cleanCache_2 = \case
    Japanese   -> "パッケージ・キャッシュは完全に削除されます。"
    Polish     -> "To usunie WSZYSTKIE pakiety z pamięci podręcznej."
    Croatian   -> "Ovo će izbrisati CIJELI cache paketa."
    Swedish    -> "Detta kommer ta bort HELA paket-cachen."
    German     -> "Dies wird den GESAMTEN Paketcache leeren."
    Spanish    -> "Esto eliminará POR COMPLETO la caché de paquetes."
    Portuguese -> "Isso eliminara TODOS OS PACOTES do cache."
    French     -> "Ceci va supprimer la TOTALITÉ du cache des paquets."
    Russian    -> "Это действие ВСЕЦЕЛО уничтожит кэш пакетов."
    Italian    -> "Questo cancellera l'INTERA cache dei pacchetti."
    Serbian    -> "Ово ће избрисати ЦЕО кеш пакета."
    Norwegian  -> "Dette vil slette HELE pakke-cachen."
    Indonesia  -> "Akan menghapus SEMUA `cache` paket"
    Chinese    -> "这将会删除全部的包缓存。"
    _          -> "This will delete the ENTIRE package cache."

cleanCache_3 :: Int -> Language -> String
cleanCache_3 (bt . show -> n) = \case
    Japanese   -> "パッケージ・ファイルは" <> n <> "個保存されます。"
    Polish     -> n <> " wersji każdego pakietu zostanie zachowane."
    Croatian   -> n <> " zadnjih verzija svakog paketa će biti zadržano."
    Swedish    -> n <> " av varje paketfil kommer att sparas."
    German     -> n <> " jeder Paketdatei wird behalten."
    Spanish    -> "Se mantendrán " <> n <> " ficheros de cada paquete."
    Portuguese -> n <> " arquivos de cada pacote serão mantidos."
    French     -> n <> " fichiers de chaque paquet sera conservé."
    Russian    -> n <> " версии каждого пакета будут нетронуты."
    Italian    -> n <> " di ciascun pacchetto sarà mantenuto."
    Serbian    -> n <> " верзије сваког од пакета ће бити сачуване."
    Norwegian  -> n <> " av hver pakkefil blir beholdt."
    Indonesia  -> n <> " berkas dari tiap paket akan disimpan."
    Chinese    -> "每个包文件将会保存 " <> n <> " 个版本。"
    _          -> n <> " of each package file will be kept."

cleanCache_4 :: Language -> String
cleanCache_4 = \case
    Japanese   -> "残りは全部削除されます。承知していますか？"
    Polish     -> "Wszystko inne zostanie usunięte. Na pewno?"
    Croatian   -> "Ostali paketi će biti izbrisani. Jeste li sigurni?"
    Swedish    -> "Resten kommer att tas bort. Är det OK?"
    German     -> "Der Rest wird gelöscht. Ist das OK?"
    Spanish    -> "El resto se eliminarán. ¿De acuerdo?"
    Portuguese -> "O resto será deletado. OK?"
    French     -> "Le reste sera supprimé. Êtes-vous d'accord ?"
    Russian    -> "Всё остальное будет удалено. Годится?"
    Italian    -> "Il resto verrà mantenuto. Continuare?"
    Serbian    -> "Остатак ће бити избрисан. Да ли је то у реду?"
    Norwegian  -> "Resten vil bli slettet. Er det OK?"
    Indonesia  -> "Selainnya akan dihapus. Ikhlas kan?"
    Chinese    -> "其余的将会被删除。确定？"
    _          -> "The rest will be deleted. Okay?"

cleanCache_5 :: Language -> String
cleanCache_5 = \case
    Japanese   -> "削除の続行は意図的に阻止されました。"
    Polish     -> "Czyszczenie pamięci podręcznej zostało przerwane przez użytkownika."
    Croatian   -> "Čišćenje cache-a paketa prekinuto od strane korisnika."
    Swedish    -> "Cache-rensning avbröts manuellt."
    German     -> "Leeren des Caches durch Benutzer abgebrochen."
    Spanish    -> "Limpieza de la caché abortada manualmente."
    Portuguese -> "Limpeza do cache abortada manualmente."
    French     -> "Le nettoyage du cache a été arrêté manuellement."
    Russian    -> "Очистка кэша прервана пользователем."
    Italian    -> "Pulitura manuale della cache interrotta."
    Serbian    -> "Чишћење кеша је ручно прекинуто."
    Norwegian  -> "Cache-rensing ble avbrutt manuelt."
    Indonesia  -> "Pembersihan `cache` dibatalkan secara paksa."
    Chinese    -> "手动清理缓存已中止。"
    _          -> "Cache cleaning manually aborted."

cleanCache_6 :: Language -> String
cleanCache_6 = \case
    Japanese   -> "パッケージ・キャッシュを掃除中・・・"
    Polish     -> "Czyszczenie pamięci podręcznej..."
    Croatian   -> "Čišćenje cache-a paketa..."
    Swedish    -> "Rensar paket-cache..."
    German     -> "Leere Paketcache..."
    Spanish    -> "Limpiando la caché de paquetes..."
    Portuguese -> "Limpando cache de pacotes..."
    French     -> "Nettoyage du cache des paquets…"
    Russian    -> "Очистка кэша пакета..."
    Italian    -> "Ripulisco la cache..."
    Serbian    -> "Чишћење кеша..."
    Norwegian  -> "Renser pakke-cache..."
    Indonesia  -> "Membersihkan `cache` paket..."
    Chinese    -> "正在清理包缓存..."
    _          -> "Cleaning package cache..."

-- NEEDS TRANSLATION
cleanNotSaved_1 :: Language -> String
cleanNotSaved_1 = \case
    Japanese   -> "不要パッケージファイルを確認・・・"
    Polish     -> "Określanie niepotrzebnych plków pakietów"
    Croatian   -> "Pronalazim nepotrebne datoteke paketa..."
    German     -> "Bestimme nicht benötigte Paketdateien..."
    Spanish    -> "Determinando ficheros de paquetes innecesarios..."
    Norwegian  -> "Finner unødige pakkefiler..."
    Italian    -> "Determino i pacchetti non più necessari..."
    Portuguese -> "Determinando arquivos não necessários nos pacotes ..."
    French     -> "Détermination des fichiers de paquet inutiles…"
    Russian    -> "Вычисляются ненужные файлы пакетов..."
    Indonesia  -> "Menentukan berkas paket yang tidak dibutuhkan..."
    Chinese    -> "正在确定不需要的包文件..."
    Swedish    -> "Beräknar onödiga paketfiler..."
    _          -> "Determining unneeded package files..."

-- NEEDS TRANSLATION
cleanNotSaved_2 :: Int -> Language -> String
cleanNotSaved_2 (cyan . show -> s) = \case
    Japanese   -> "「" <> s <> "」の不要パッケージファイルがあります。削除しますか？"
    Polish     -> s <> " niepotrzebnych plików zostało znalezionych. Usunąć?"
    Croatian   -> s <> " nepotrebnih datoteka pronađeno. Obrisati?"
    German     -> s <> " nicht benötigte Paketdateien gefunden. Löschen?"
    Spanish    -> s <> " ficheros innecesarios de paquetes encontrados. ¿Deseas eliminarlos?"
    Norwegian  -> s <> " unødige pakkefiler funnet. Vil du slette?"
    Italian    -> s <> " pacchetti non necessari trovati. Cancellarli?"
    Portuguese -> s <> " pacotes não necessários encontrados. Removê-los?"
    French     -> s <> " paquets inutiles trouvés. Les supprimer ?"
    Russian    -> s <> " -- столько ненужных пакетных файлов обнаружено. Удалить?"
    Indonesia  -> s <> " berkas paket yang tidak dibutuhkan ditemukan. Hapus?"
    Chinese    -> "发现了 " <> s <> " 个不需要的包文件。是否删除？"
    Swedish    -> s <> " oanvända paket hittades. Ta bort?"
    _          -> s <> " unneeded package files found. Delete?"

----------------------------
-- Aura/Commands/L functions
----------------------------
logLookUpFields :: Language -> [String]
logLookUpFields = sequence [ Fields.package
                           , Fields.firstInstall
                           , Fields.upgrades
                           , Fields.recentActions
                           ]

reportNotInLog_1 :: Language -> String
reportNotInLog_1 = \case
    Japanese   -> "logファイルには出ていない："
    Polish     -> "Tych pakietów nie ma w dzienniku:"
    Croatian   -> "Ovih paketa nema u dnevniku:"
    Swedish    -> "Dessa har inte framkommit i loggfiler:"
    German     -> "Diese sind nicht in der Logdatei aufgetaucht:"
    Spanish    -> "Estos no aparecen en el fichero log:"
    Portuguese -> "Os seguintes não apareceram no log de arquivo:"
    French     -> "Ceci n'apparaît pas des les journaux (log) :"
    Russian    -> "Следующих пакетов нет в лог-файле:"
    Italian    -> "Questo non apparirà nei file di log;"
    Serbian    -> "Ови пакети се не спомињу у дневнику:"
    Norwegian  -> "Følgende har ikke vist seg i loggen:"
    Indonesia  -> "Tidak terlihat pada berkas log:"
    Chinese    -> "这些没有在日志文件中出现："
    _          -> "These have not appeared in the log file:"

----------------------
-- Aura/Flags functions
----------------------
inheritedOperTitle :: Language -> String
inheritedOperTitle = \case
    Japanese    -> "Pacmanからの引継選択肢"
    Polish      -> "Operacje z Pacmana"
    Croatian    -> "Pacman operacije"
    Swedish     -> "Ärvda pacman-operationer"
    German      -> "Von Pacman geerbte Operationen"
    Spanish     -> "Operaciones heredadas de pacman"
    Portuguese  -> "Operações herdadas do Pacman"
    French      -> "Opérations héritées de Pacman"
    Russian     -> "Позаимствованные из pacman действия"
    Italian     -> "Operazioni riguardanti Pacman"
    Serbian     -> "Наслеђене pacman-ове операције"
    Norwegian   -> "Arvede `pacman`-operasjoner"
    Indonesia   -> "Operasi pacman yang diwarisi"
    Chinese     -> "继承自 Pacman 的操作"
    _           -> "Inherited Pacman Operations"

auraOperTitle :: Language -> String
auraOperTitle = \case
    Japanese   -> "Auraだけの選択肢："
    Polish     -> "Operacje Aury:"
    Croatian   -> "Aura operacije:"
    Swedish    -> "Aura-specifika operationer:"
    German     -> "Aura-spezifische Operationen:"
    Spanish    -> "Operaciones exclusivas de Aura:"
    Portuguese -> "Operações exclusivas do Aura:"
    French     -> "Opérations propres à Aura :"
    Russian    -> "Специфичные для aura действия:"
    Italian    -> "Operazioni esclusive di Aura:"
    Serbian    -> "Аура-специфичне операције:"
    Norwegian  -> "Aura-spesifikke operasjoner:"
    Indonesia  -> "Operasi Aura:"
    Chinese    -> "Aura 特有的操作："
    _          -> "Aura Only Operations:"

aurSy :: Language -> String
aurSy = green . \case
    Japanese   -> "[A]URに関連する処理\n" <> "デフォルトでAURからインストール"
    Polish     -> "Wykonuje akcje związane z [A]UR.\n" <> "Domyślnie instaluje pakiety z AUR."
    Croatian   -> "Izvršava radnje s [A]UR-om.\n" <> "Uobičajena (default) radnja je instaliranje paketa iz AUR-a."
    Swedish    -> "Utför åtgärder involverandes [A]UR.\n" <> "Standard-åtgärd installerar ifrån AUR."
    German     -> "Führe Aktionen aus, die das [A]UR betreffen.\n" <> "Standardaktion installiert aus dem AUR."
    Spanish    -> "Realizar acciones relacionadas con [A]UR.\n" <> "La acción por omisión es instalar desde AUR."
    Portuguese -> "Realizar ações envolvendo o [A]UR.\n" <> "Ação padrão instala do AUR."
    French     -> "Actions impliquant [A]UR.\n" <> "Par défaut, installe depuis AUR."
    Russian    -> "Совершить действия с участием [A]UR.\n" <> "Действие по умолчанию устанавливает из AUR."
    Italian    -> "Azioni riguardanti [A]UR.\n" <> "Di default installa da AUR."
    Serbian    -> "Извршава радње везане за [A]UR.\n" <> "Уобичајена радња инсталира из AUR-а."
    Norwegian  -> "Utfør handlinger som innebærer [A]UR.\n" <> "Standard-handling installerer fra AUR."
    Indonesia  -> "Melakukan perbuatan yang berhubungan dengan [A]UR.\n" <> "Instalasi bawaan dari AUR."
    Chinese    -> "执行涉及到 [A]UR 的指令。\n" <> "默认从 AUR 安装。"
    _          -> "Perform actions involving the [A]UR.\n" <> "Default action installs from the AUR."

-- NEEDS TRANSLATION
saveS :: Language -> String
saveS = yellow . \case
    Japanese   -> "パッケージの設置状態に関する処理\n" <> "デフォルトでインストール状態を保存する。"
    Polish     -> "Zarządza zachowywaniem oraz odtwarzaniem globalnego stanu pakietów.\n" <> "Domyślnie zachowuje stan"
    Croatian   -> "Upravlja spremanjem i vraćanjem globalnog stanja paketa.\n" <> "Uobičajena (default) radnja je spremanje trenutnog stanja paketa."
    German     -> "Verwalte das [S]peichern und Wiederherstellen der globalen Paketzustände.\n" <> "Standardaktion sichert die Zustände."
    Spanish    -> "Administrar el [S]alvado y restaurado del estado de los paquetes.\n" <> "La acción por omisión es salvar el estado."
    Serbian    -> "Управља чувањем и враћањем глобалног стања пакета.\n" <> "Уобичајена радња чува тренутно стање."
    Norwegian  -> "Administer lagring og gjenoppretting av den globale pakketilstanden.\n" <> "Standard-handling lagrer denne tilstanden."
    Portuguese -> "Genrencia o [S]alvamento e restauração do estado global de pacotes" <> "Por padrão salva o estado atual."
    Italian    -> "Gestisco il [S]alvataggio e ripristino dello stato globale dei pacchetti.\n" <> "Salva lo stato in maniera predefinita."
    French     -> "Gestion de la [S]auvegarde et de la restauration de l'état global des paquets.\n" <> "Par défaut, sauvegarde l'état actuel."
    Russian    -> "Настроить [S]охранение и восстановление глобального состояние пакетов.\n" <> "Действие по умолчанию сохраняет это состояние."
    Indonesia  -> "Mengatur [S]impan dan pengembalian keadaan paket global.\n" <> "Perilaku bawaan adalah menyimpan keadaan berikut."
    Chinese    -> "管理对全局包状态的保存（[S]aving）和恢复。\n" <> "默认保存当前状态。"
    _          -> "Manage the [S]aving and restoring of the global package state.\n" <> "Default action saves this state."

downG :: Language -> String
downG = red . \case
    Japanese   -> "キャッシュに関連する処理\n" <> "デフォルトでパッケージをダウングレード"
    Polish     -> "Wykonuje akcje związane z pamięcią podręczną ([C]ache) pakietów.\n" <> "Domyślnie instaluje starsze wersje podanych pakietów."
    Croatian   -> "Izvršava radnje sa [C]ache-om paketa.\n" <> "Uobičajena (default) radnja je vraćanje paketa na prijašnju verziju."
    Swedish    -> "Utför åtgärder involverandes paket-[C]ache.\n" <> "Standard-åtgärd nergraderar valda paket."
    German     -> "Führe Aktionen aus die den Paket[C]ache betreffen.\n" <> "Standardaktion downgradet gegebene Pakete."
    Spanish    -> "Realizar acciones relacionadas con la [C]aché.\n" <> "La acción por omisión es volver a versiones antiguas de los paquetes especificados."
    Portuguese -> "Realiza ações relacionadas ao [C]ache.\n" <> "Ação padrão retorna os pacotes informados às suas versões anteriores."
    French     -> "Actions impliquant le [C]ache des paquets.\n" <> "Par défaut, mets les paquets spécifiés à niveau vers une version antérieure."
    Russian    -> "Совершить действия с участием кэша пакета ([C]ache).\n" <> "Действие по умолчанию откатывает данные пакеты к старым версиям."
    Italian    -> "Azioni riguardanti la [C]ache dei pacchetti.\n" <> "Di default retrocede il pacchetti."
    Serbian    -> "Извршава радње везане за кеш пакета.\n" <> "Уобичајена радња враћа претходну верзију датих пакета."
    Norwegian  -> "Utfør handlinger som involverer pakke-[C]achen.\n" <> "Standard-handling nedgraderer den valgte pakken."
    Indonesia  -> "Melakukan hal yang berhubugnan dengan [C]ache paket.\n" <> "Perilaku bawaan adalah menurunkan versi dari paket yang diberikan."
    Chinese    -> "执行涉及到缓存（[C]ache）的指令。\n" <> "默认降级指定包。"
    _          -> "Perform actions involving the package [C]ache.\n" <> "Default action downgrades given packages."

viewL :: Language -> String
viewL = cyan . \case
    Japanese   -> "[L]ogfileに関連する処理\n" <> "デフォルトでlogfileを閲覧用に開く"
    Polish     -> "Wykonuje akcje związane z dziennikiem ([L]ogiem) pacmana.\n" <> "Domyślnie otwiera log w trybie tylko do odczytu."
    Croatian   -> "Izvršavanje radnje sa pacman dnevnikom ([L]ogfile).\n" <> "Uobičajena (default) radnja je ispis dnevnika."
    Swedish    -> "Utför åtgärder involverandes pacmans [L]ogfil.\n" <> "Standard-åtgärd öppnar loggen med read-only-attribut."
    German     -> "Führe Aktionen aus, die die Pacman-[L]ogdatei betreffen.\n" <> "Standardaktion öffnet den Log (nur Lesen)"
    Spanish    -> "Realizar acciones relacionadas con el fichero [L]og de pacman.\n" <> "La acción por omisión es abrir el log en modo sólo lectura."
    Portuguese -> "Realiza ações relacionadas ao [L]ogfile do Pacman.\n" <> "Ação padrão abre o arquivo de log apenas para leitura."
    French     -> "Actions impliquant le fichier de [L]og (journal) de Pacman.\n" <> "Par défaut, ouvre le journal en lecture seule."
    Russian    -> "Совершить действия с участием [L]og-файлов pacman.\n" <> "Действие по умолчанию открывает лог для просмотра в режиме для чтения."
    Italian    -> "Azioni riguardanti i [L]ogfile di pacman.\n" <> "Di default visualizza il log in sola lettura."
    Serbian    -> "Извршава радње везане за pacman-ов дневник.\n" <> "Уобичајена радња даје преглед дневника."
    Norwegian  -> "Utfør handlinger som involverer `pacman`'s [L]oggfil.\n" <> "Standard-handling åpner loggen for skrivebeskyttet lesing."
    Indonesia  -> "Melakukan hal yang berhubungan dengan berkas [L]og pacman.\n"<>"Aksi bawaan adalah membuka log dengan aturan `baca-saja`."
    Chinese    -> "执行涉及到 pacman 的日志文件（[L]ogfile）的指令。\n" <> "默认以只读模式打开日志。"
    _          -> "Perform actions involving the pacman [L]ogfile.\n" <> "Default action opens the log for read-only viewing."

orpha :: Language -> String
orpha = blue . \case
    Japanese   -> "必要とされていない従属パッケージに関する処理\n" <> "デフォルトでその従属パッケージの名前を出力"
    Polish     -> "Wykonuje akcje związane z [O]sieroconymi pakietami.\n" <> "Domyślnie wyświetla wszystkie osierocone pakiety."
    Croatian   -> "Izvršava radnje s paketima bez roditelja ([O]rphan).\n" <> "Uobičajena (default) radnja je izlistavanje paketa bez roditelja."
    Swedish    -> "Utför åtgärder involverandes [O]rphan-paket.\n" <> "Standard-åtgärd listar alla orphan-paket."
    German     -> "Führe Aktionen aus, die verwaiste Pakete ([O]rphans) betreffen.\n" <> "Standardaktion listet alle verwaisten Pakete auf."
    Spanish    -> "Realizar acciones relacionadas con paquetes huérfanos ([O]rphan).\n" <> "La acción por omisión es listar todos los paquetes huérfanos."
    Portuguese -> "Realiza ações com pacotes [O]rfãos.\n" <> "Ação padrão lista todos os pactes orfãos."
    French     -> "Actions impliquant les paquets [O]rphelins.\n" <> "Par défaut, liste l'ensemble des paquets orphelins."
    Russian    -> "Совершить действия с участием [O]сиротевших пакетов.\n" <> "Действие по умолчанию перечисляет все осиротевшие пакеты."
    Italian    -> "Azioni riguardanti i pacchetti [O]rfani.\n" <> "Di default elenca i pacchetti orfani."
    Serbian    -> "Извршава радње везане за пакете без родитеља.\n" <> "Уобичајена радња листа пакете без родитеља."
    Norwegian  -> "Utfør handlinger som involverer foreldreløse pakker ([O]rphans).\n" <> "Standard-handling åpner alle foreldreløse pakker."
    Indonesia  -> "Melakukan hal yang berhubungan dengan paket [O]rphan.\n" <> "Perilaku bawaan adalah mencetak daftar semua paket orphan."
    Chinese    -> "执行涉及到孤包（[O]rphan packages）的指令。\n" <> "默认列出全部的孤包。"
    _          -> "Perform actions involving [O]rphan packages.\n" <> "Default action lists all orphan packages."

-------------------------------
-- Aura/AUR functions
-------------------------------
-- NEEDS TRANSLATION
getAURPkgInfo_1 :: Language -> String
getAURPkgInfo_1 = \case
    Japanese   -> "AURのAPIに接続できませんでした。ネット接続状態を確認して下さい。"
    Polish     -> "AUR API wyszukiwanie nie powiodło się. Sprawdź swoje połączenie"
    Croatian   -> "Pristup AUR-u nije uspio. Provjerite svoju vezu."
    German     -> "AUR-API-Suche fehlgeschlagen. Bitte überprüfen Sie Ihre Internet-Verbindung."
    Spanish    -> "Fallo en la consulta a la API de AUR. Comprueba tu conexión a Internet."
    Serbian    -> "Приступ AUR-у није успео. Проверите вашу везу."
    Norwegian  -> "AUR API-oppslag feilet. Vennligst sjekk tilkoblingen din."
    Italian    -> "connessione ad AUR API fallita. Controllare la propria connessione."
    Portuguese -> "Falha buscando na API AUR. Por favor, verifique a conexão."
    French     -> "La recherche dans l'API AUR a échouée. Veuillez vérifiez votre connexion."
    Russian    -> "Запрос к AUR API не удался. Пожалуйста, проверьте ваше соединение."
    Indonesia  -> "Pemeriksaan API AUR gagal. Sila periksa sambungan anda."
    Chinese    -> "查找 AUR API 失败。请检查网络连接。"
    Swedish    -> "Misslyckades med AUR API-anrop. Är du ansluten till internet?"
    _          -> "AUR API lookup failed. Please check your connection."

infoFields :: Language -> [String]
infoFields = sequence [ Fields.repository
                      , Fields.name
                      , Fields.version
                      , Fields.aurStatus
                      , Fields.maintainer
                      , Fields.projectUrl
                      , Fields.aurUrl
                      , Fields.license
                      , Fields.dependsOn
                      , Fields.buildDeps
                      , Fields.votes
                      , Fields.popularity
                      , Fields.description
                      ]

outOfDateMsg :: Maybe Int -> Language -> String
outOfDateMsg (Just _) = red . \case
    Japanese   -> "AURで要更新！"
    Polish     -> "Nieaktualny!"
    Croatian   -> "Zastarjelo!"
    Swedish    -> "Utdaterad!"
    German     -> "Veraltet!"
    Spanish    -> "¡Desactualizado!"
    Portuguese -> "Desatualizado!"
    French     -> "Périmé !"
    Russian    -> "Устарел!"
    Italian    -> "Out of Date!"
    Serbian    -> "Застарео!"
    Norwegian  -> "Utdatert!"
    Indonesia  -> "Ketinggalan Zaman!"
    Chinese    -> "过期！"
    _          -> "Out of Date!"
outOfDateMsg Nothing = green . \case
    Japanese   -> "最新"
    Polish     -> "Aktualny"
    Croatian   -> "Ažurirano"
    Swedish    -> "Aktuell"
    German     -> "Aktuell"
    Spanish    -> "Actualizado"
    Portuguese -> "Atualizado"
    French     -> "À jour"
    Russian    -> "Новейший"
    Italian    -> "Aggiornato"
    Serbian    -> "Ажуран"
    Norwegian  -> "Oppdatert"
    Indonesia  -> "Mutakhir"
    Chinese    -> "最新"
    _          -> "Up to Date"

-- NEEDS TRANSLATION
orphanedMsg :: Maybe String -> Language -> String
orphanedMsg (Just m) = const $ bForeground m
orphanedMsg Nothing = red . \case
    Japanese   -> "孤児です!"
    Polish     -> "Osierocony!"
    Croatian   -> "Nema roditelja!"
    German     -> "Verwaist!"
    Spanish    -> "¡Huérfano!"
    Norwegian  -> "Foreldreløs!"
    Portuguese -> "Orfão!"
    French     -> "Abandonné !"
    Russian    -> "Осиротевший!"
    Indonesia  -> "Tak dipelihara!"
    Chinese    -> "孤包！"
    Swedish    -> "Föräldralös!"
    _          -> "Orphaned!"

repository_1 :: String -> Language -> String
repository_1 p = \case
    Japanese   -> p <> "はどのリポジトリにも存在しない。"
    Polish     -> p <> " nie jest pakietem w żadnym repozytorium"
    Croatian   -> p <> "nije paket u repozitoriju."
    German     -> p <> " ist kein Paket in irgendeinem Repository."
    Spanish    -> p <> " no es un paquete en ningún repositorio."
    Norwegian  -> p <> " er ikke en pakke i noe depot."
    Italian    -> p <> " non è un pacchetto di nessun repository."
    Portuguese -> p <> " não é um pacote em nenhum do repositório."
    French     -> p <> " n'est pas un paquet dans aucun des dépôts."
    Russian    -> "Пакет " <> p <> " не найден ни в одном репозитории."
    Indonesia  -> p <> " bukan merupakan paket pada repositori manapun."
    Chinese    -> "所有仓库均不包含 " <> p <> "。"
    Swedish    -> p <> " är inte ett paket-repo."
    _          -> p <> " is not a package in any repository."

pkgbuildKeyMissing :: String -> Language -> String
pkgbuildKeyMissing key = \case
    Polish     -> "Nie można sprawdzić klucza " <> key <> "z PKGBUILD"
    Croatian   -> "Nemoguće izvući vrijednost za " <> key <> " iz PKGBUILD-a."
    German     -> "Kann Schlüssel " <> key <> " nicht aus PKGBUILD parsen."
    Spanish    -> "Imposible leer la clave " <> key <> " del PKGBUILD."
    Norwegian  -> "Forstår ikke " <> key <> " fra PKGBUILD."
    Italian    -> "Inpossibile elaborare la chiave " <> key <> " dal PKGBUILD."
    Portuguese -> "Impossível parsear " <> key <> " no PKGBUILD."
    French     -> "Impossible d'analyser la clef " <> key <> " depuis le PKGBUILD."
    Russian    -> "Не получилось разобрать ключ " <> key <> " из PKGBUILD."
    Indonesia  -> "Tidak dapat menerjemahkan kunci " <> key <> " dari PKGBUILD."
    Chinese    -> "无法解析 PKGBUILD 的秘钥 " <> key <> "。"
    Swedish    -> "Kan inte läsa nyckel " <> key <> " från PKGBUILD."
    _          -> "Unable to parse key " <> key <> " from PKGBUILD."

missingDescription :: Language -> String
missingDescription = \case
    Polish     -> "Brak opisu"
    Croatian   -> "Nema opisa."
    German     -> "Keine Beschreibung."
    Spanish    -> "Sin descripción."
    Norwegian  -> "Ingen beskrivelse."
    Italian    -> "Nessuna Descrizione."
    Portuguese -> "Descrição faltante."
    French     -> "Aucune description."
    Russian    -> "Без описания."
    Indonesia  -> "Tidak ada deskripsi."
    Chinese    -> "没有任何描述。"
    Swedish    -> "Ingen beskrivning."
    _          -> "No description."

-----------------------
-- Aura/State functions
-----------------------
-- NEEDS TRANSLATION
saveState_1 :: Language -> String
saveState_1 = \case
    Japanese   -> "パッケージ状態の保存完了。"
    Polish     -> "Zachowano stan pakietów"
    Croatian   -> "Stanje paketa spremljeno."
    German     -> "Paketzustand gesichert."
    Spanish    -> "Estado del paquete salvado."
    Serbian    -> "Сачувано стање пакета."
    Norwegian  -> "Lagret pakketilstand."
    Italian    -> "Stato del pacchetto salvato."
    Portuguese -> "Estados de pacote salvos."
    French     -> "État des paquets sauvegardé."
    Russian    -> "Состояние пакетов сохранено."
    Indonesia  -> "Kondisi paket tersimpan."
    Chinese    -> "已保存包状态。"
    Swedish    -> "Det lokala pakettillståndet har sparats."
    _          -> "Saved package state."

-- NEEDS TRANSLATION
restoreState_1 :: Language -> String
restoreState_1 = \case
    Japanese   -> "対象バージョンがないパッケージ："
    Polish     -> "Starsze wersje nie są dostępne dla:"
    Croatian   -> "Tražene stare verzije nisu dostupne za:"
    German     -> "Gewünschte Downgrade-Versionen nicht verfügbar für:"
    Spanish    -> "Versiones anteriores no disponibles para:"
    Serbian    -> "Захтеване старе верзије нису доступне за:"
    Norwegian  -> "De spesifiserte nedgraderingsversjonene er ikke tilgjengelig for:"
    Italian    -> "Richiesta di retrocessione di versione non disponibile per:"
    Portuguese -> "Versões anteriores requisitadas não disponívels para:"
    French     -> "Version antérieure requise non disponible pour :"
    Russian    -> "Запрошенные версии для отката не доступны для:"
    Indonesia  -> "Versi yang diturunkan tidak tersedia untuk: "
    Chinese    -> "请求的降级版本对以下包不可用："
    Swedish    -> "Den begärda nedgraderingen finns inte tillgänglig för:"
    _          -> "Requested downgrade versions not available for:"

restoreState_2 :: Language -> String
restoreState_2 = \case
  Japanese -> "保存されたパッケージ状態がない。作るには「-B」を。"
  Chinese  -> "没有要恢复的已保存状态。（使用 -B 保存当前状态）"
  Swedish  -> "Inga sparade tillstånd att återhämta. (Använd -B för att spara det nuvarande tillståndet)"
  _        -> "No saved states to be restored. (Use -B to save the current state)"

-- NEEDS TRANSLATION
reinstallAndRemove_1 :: Language -> String
reinstallAndRemove_1 = \case
    Japanese   -> "パッケージを変更する必要はありません。"
    Polish     -> "Żaden pakiet nie wymaga zmian"
    Croatian   -> "Nema paketa kojima su potrebne izmjene."
    German     -> "Keine Pakete brauchen Änderungen."
    Spanish    -> "Ningún paquete necesita cambios."
    Serbian    -> "Ниједан пакет не захтева измене."
    Norwegian  -> "Ingen pakker trenger forandring."
    Italian    -> "Nessun pacchetto necessita cambiamenti."
    Portuguese -> "Nenhum pacote requer alteração."
    French     -> "Aucun paquet n'a besoin de changement."
    Russian    -> "Пакеты не нуждаются в изменениях."
    Indonesia  -> "Tidak ada paket yang diubah."
    Chinese    -> "没有包需要改变。"
    Swedish    -> "Inga paket behöver ändras."
    _          -> "No packages need changing."

--------------------------------------
-- Aura/Settings/BadPackages functions
--------------------------------------
-- NEEDS TRANSLATION
circDep_1 :: String -> Language -> String
circDep_1 (bt  -> p) = \case
    Japanese   -> p <> "と互いに従属している。"
    Polish     -> "Posiada cykliczną zależność z" <> p <> "."
    Croatian   -> "Ima kružnu zavisnost sa " <> p <> "."
    German     -> "Hat eine zirkuläre Abhängigkeit mit " <> p <> "."
    Spanish    -> "Tiene una dependencia circular con " <> p <> "."
    Serbian    -> "Има кружну зависност са " <> p <> "."
    Norwegian  -> "Har en sirkulær avhengighet med " <> p <> "."
    Italian    -> "E' una dipendenza circolare di " <> p <> "."
    Portuguese -> "Há uma dependência circular em " <> p <> "."
    French     -> "A une dépendance circulaire avec " <> p <> "."
    Russian    -> "Имеет круговую зависимость с " <> p <> "."
    Indonesia  -> "Mempunyai dependensi sirkular dengan " <> p <> "."
    Chinese    -> "有对 " <> p <> " 的循环依赖。"
    Swedish    -> "Har ett cirkulärt beroende med " <> p <> "."
    _          -> "Has a circular dependency with " <> p <> "."

-- NEEDS TRANSLATION
bashisms_1 :: Language -> String
bashisms_1 = \case
    Japanese   -> "PKGBUILDのBashコードが複雑すぎます。"
    Polish     -> "Za dużo Bash-ismu w PKGBUILD"
    Croatian   -> "Previše „bash-izama“ u PKGBUILD-u."
    German     -> "Zu viele „bashismen“ im PKGBUILD."
    Spanish    -> "Demasiados \"bashismos\" en el PKGBUILD"
    Serbian    -> "Превише „bash-изама“ у PKGBUILD-у."
    Norwegian  -> "For mange „bashismer“ i PKGBUILD."
    Italian    -> "Troppo 'bashisms' nel PKGBUILD."
    Portuguese -> "Excesso de `bashismo` no PKGBUILD."
    French     -> "Trop de « bashisms » dans le PKGBUILD."
    Russian    -> "В PKGBUILD слишком много башизмов."
    Indonesia  -> "Terlalu banyak bashism pada PKGBUILD."
    Chinese    -> "PKGBUILD 里包含了太多的 bash 扩展特性。"
    Swedish    -> "För många bashisms i PKGBUILD."
    _          -> "Too many bashisms in PKGBUILD."

------------------------
-- Aura/Pacman functions
------------------------
-- NEEDS TRANSLATION
pacmanFailure_1 :: Language -> String
pacmanFailure_1 = \case
    Japanese   -> "入力を確認して下さい。"
    Polish     -> "Sprawdź swoje dane wejściowe"
    Croatian   -> "Molim vas, provjerite svoj unos."
    German     -> "Bitte überprüfen Sie Ihre Eingabe."
    Spanish    -> "Por favor comprueba los datos proporcionados."
    Serbian    -> "Молим Вас, проверите ваш унос."
    Norwegian  -> "Vennligst sjekk din oppføring."
    Italian    -> "Controllare il proprio input."
    Portuguese -> "Por favor, verifique os dados entrados."
    French     -> "Merci de vérifier les donnés entrées."
    Russian    -> "Пожалуйста, проверьте ваши введенные данные."
    Indonesia  -> "Mohon periksa masukan anda."
    Chinese    -> "请检查你的输入。"
    Swedish    -> "Var god dubbelkolla indata."
    _          -> "Please check your input."

----------------------------------
-- Aura/Pkgbuild/Editing functions
----------------------------------
hotEdit_1 :: String -> Language -> String
hotEdit_1 (bt -> p) = \case
    Japanese   -> p <> "のPKGBUILDを編成しますか？"
    Polish     -> "Czy chcesz edytować PKGBUILD " <> p <> "?"
    Croatian   -> "Želite li izmjeniti PKGBUILD " <> p <> "?"
    Swedish    -> "Vill du ändra PKGBUILD-filen ifrån " <> p <> "?"
    German     -> "Möchten Sie die PKGBUILD-Datei für " <> p <> " bearbeiten?"
    Spanish    -> "¿Deseas editar el PKGBUILD de " <> p <> "?"
    Portuguese -> "Desejaria editar o PKGBUILD de " <> p <> "?"
    French     -> "Voulez-vous éditer le PKGBUILD de " <> p <> " ?"
    Russian    -> "Отредактировать PKGBUILD пакета " <> p <> "?"
    Italian    -> "Volete modificare il PKGBUILD di " <> p <> "?"
    Serbian    -> "Желите ли да измените PKGBUILD за " <> p <> "?"
    Norwegian  -> "Vil du endre PKGBUILD for " <> p <> "?"
    Indonesia  -> "Apakah anda ingin menyunting PKGBUILD untuk paket " <> p <> "?"
    Chinese    -> "你希望编辑 " <> p <> " 的 PKGBUILD 文件吗？"
    _          -> "Would you like to edit the PKGBUILD of " <> p <> "?"

customizepkg_1 :: Language -> String
customizepkg_1 = let customizepkg = bt "customizepkg" in \case
    Japanese   -> customizepkg <> "はインストールされていません。"
    Polish     -> customizepkg <> "nie zainstalowany."
    Croatian   -> customizepkg <> "nije instaliran."
    German     -> customizepkg <> "ist nicht installiert."
    Spanish    -> customizepkg <> "no está instalado."
    Norwegian  -> customizepkg <> "er ikke installert."
    Italian    -> customizepkg <> "non è installato."
    Portuguese -> customizepkg <> "não está instalado."
    French     -> customizepkg <> "n'est pas installé."
    Russian    -> customizepkg <> "не установлен."
    Indonesia  -> customizepkg <> "tidak terinstal."
    Chinese    -> customizepkg <> " 没有被安装。"
    Swedish    -> customizepkg <> "är inte installerad"
    _          -> customizepkg <> "isn't installed."

-----------------------
-- Aura/Utils functions
-----------------------

yesNoMessage :: Language -> String
yesNoMessage = \case
    Polish     -> "[T/n]"
    Croatian   -> "[D/n]"
    German     -> "[J/n]"
    Spanish    -> "[S/n]"
    Norwegian  -> "[J/n]"
    Italian    -> "[S/n]"
    Portuguese -> "[S/n]"
    French     -> "[O/n]"
    _          -> "[Y/n]"

yesRegex :: Language -> String
yesRegex = (<> "|^$") . \case
    Polish     -> "[tT][aA][kK]?"
    Croatian   -> "[dD][aA]?"
    German     -> "[jJ][aA]?"
    Spanish    -> "[sS]([iI])?"
    Norwegian  -> "[jJ][aA]?"
    Italian    -> "[sS][iI]?"
    Portuguese -> "[sS]([iI][mM])?"
    French     -> "[oO]([uU][iI])?"
    _          -> "[yY]([eE][sS])?"
