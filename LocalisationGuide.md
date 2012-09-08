Language Localisation Guide for AURA
====================================

Welcome!

こんにちは！

  If you're reading this then it's likely that you want to help localise Aura
into another language. Arch users everywhere can benefit from your
contribution, and its a great opportunity to contribute to Open Source.


## WHAT YOU NEED 
1. The aura source code. Get it at:
   https://github.com/fosskers/aura
2. An editor. Whichever one you like.
   Vim users, run the following easter-egg command to unlock a better version:

   `:! perl -e "system('hpdfv' =~ tr/a-z/x-za-w/r)"`

   Emacs users can achieve a similar enhanced version with:

   `M-! perl -e "system('ylp' =~ tr/a-z/x-za-w/r)"`

3. git. As Aura is hosted on github, cloning, making changes and adding pull
   requests will just be easiest if you have a working git/github setup.
4. Minimal Haskell knowledge. You'll see just how much below.
5. A brain (hopefully yours) with a language in it. I don't sprechen Deutsch,
   говорить России, nor do I يتكلم العربية, so that's where you come in.


## GETTING STARTED
### STEP ONE - TELL HASKELL ABOUT THE NEW LANGUAGE 

  All strings that contain messages for the user are stored in a single
source file: `AuraLanguages.hs`. Let's take a look at the top:

```haskell
data Language = English
              | Japanese
                deriving (Eq,Enum,Show)
```

  This is where we define output languages for Aura. For the purpose of
demonstration, we'll use `French` as the language we're adding.
Add a new language by adding a new value to the Language data type.
Like this:

```haskell
data Language = English
              | Japanese
              | French
                deriving (Eq,Enum,Show)
```

###  STEP TWO - ALLOW ACCESS TO YOUR LANGUAGE

  To do this we need to define a very simple function.
Here is the English version:

```haskell
english :: Language
english = English
```

  The format is thus:

```haskell
someLanguageName :: Language
someLanguageName = ExactlyWhatYouAddedToTheLanguageFieldAbove
```

### STEP THREE - TRANSLATION

  This is the real work. Let's take a look at a simple message. 
The user has passed some bogus / conflicting flags to Aura. 
What to tell them?

```haskell
-- aura functions
executeOptsMsg1 :: Language -> String
executeOptsMsg1 English  = "Conflicting flags given!"
executeOptsMsg1 Japanese = "矛盾しているオプションあり。"
```

  All functions in Aura code that output messages to the user get that
message with a dispatch. That is, they call a function with the current
language they're using, and that function returns the appropriate message.

  Notice the handy label in the comment there. This tells _where_ in the Aura
code the calling function is located. If you ever need more context as to 
what kind of message you're writing, checking the code directly will be
quickest. The format is:

nameOfCallingFunctionMsgx SomeLanguage = "The message."

  Where `x` would be a number. 
  
  This naming is nothing more than a convention. 
  So let's go ahead and add the French message:

```haskell
-- aura functions
executeOptsMsg1 :: Language -> String
executeOptsMsg1 English  = "Conflicting flags given!"
executeOptsMsg1 Japanese = "矛盾しているオプションあり。"
executeOptsMsg1 French   = "Oh non! Les options sont terribles!"
```

  High-school French at its finest.

  Sometimes you'll get functions with extra variables to put in the message:

```haskell
-- AuraLib functions
buildPackagesMsg1 :: Language -> String -> String
buildPackagesMsg1 English p  = "Building " ++ bt p ++ "..."
buildPackagesMsg1 Japanese p = bt p ++ "を作成中・・・"
```

  What the heck is `p`? Well it's probably a package name.
To double check, just check out the function that calls this message dipatch.
We know it's in `AuraLib.hs`, and the function is called `buildPackages`.
Once you know what's going on, go ahead and add the translation:

```haskell
-- AuraLib functions
buildPackagesMsg1 :: Language -> String -> String
buildPackagesMsg1 English p  = "Building " ++ bt p ++ "..."
buildPackagesMsg1 Japanese p = bt p ++ "を作成中・・・"
buildPackagesMsg1 French p   = bt p ++ " est en cours de construction."
```

  Obviously the syntax among languages is different, and so where you insert
the variables you've been given into the sentence depends on your language.

  Also, I enjoy backticks. As a convention I wrap up all package names in these
messages in backticks, using the `bt` function as seen in the examples.
This also colours them cyan.

### STEP 4 - COMMAND LINE FLAG

  We choose output languages in Aura by using flags on the command line.
Japanese, for example, uses the `--japanese` flag. We'll have to make a flag
for the new language you're adding too.
  
  This step is not actually necessary for you to do... so long as 
the translations are done I can take care of the rest of the code editing.
But for the interested:

(In `AuraFlags.hs`)

```haskell
data Flag = AURInstall  |
            Cache       |
            GetPkgbuild |
            Search      |
            Refresh     |
            Languages   |
            Version     |
            Help        |
            JapOut
            deriving (Eq,Ord)
```

  You could add French like this:

```haskell
data Flag = AURInstall  |
            Cache       |
            GetPkgbuild |
            Search      |
            Refresh     |
            Languages   |
            Version     |
            Help        |
            JapOut      |  -- Added a pipe character...
            FrenchOut      -- ...and a Flag value for French!
            deriving (Eq,Ord)
```

  Then we need to add it to the options to be checked for:

  (In `AuraFlags.hs`)

```haskell
languageOptions :: [OptDescr Flag]
languageOptions = map simpleMakeOption
                  [ ( [], ["japanese","日本語"], JapOut ) ]
```

  ...would thus become:

```haskell
languageOptions :: [OptDescr Flag]
languageOptions = map simpleMakeOption
                  [ ( [], ["japanese","日本語"],  JapOut    ) 
                  , ( [], ["french", "francais"], FrenchOut ) ]
```

  Notice how each language has two long options. Please feel free to
  add your language's _real_ name in its native characters.

  Last step in the flag making:

```haskell
getLanguage :: [Flag] -> Language
getLanguage = fishOutFlag flagsAndResults english
    where flagsAndResults = zip langFlags langFuns
          langFlags       = [JapOut]
          langFuns        = [japanese]
```

  This function extracts your language selection from the rest of the options.
Let's add French.

```haskell
getLanguage :: [Flag] -> Language
getLanguage = fishOutFlag flagsAndResults english
    where flagsAndResults = zip langFlags langFuns
          langFlags       = [JapOut,FrenchOut]  -- We added
          langFuns        = [japanese,french]   -- some values here.
```

  Where `FrenchOut` is the value you added to `Flags` above. `french` is
the function you wrote in `AuraLanguages.hs` to return the name of your
language. 

### STEP FIVE - PULL REQUEST

  With the translations complete, you'll need to tell me about it on github.
Once I check over your changes I'll release a new version of Aura with your
language included as soon as possible. Provided you followed the above
instructions, this shouldn't take long. Furthermore, I won't be able to
proofread the translation itself, as I don't speak your language.
You could hide your doomsday take-over plans in my code and I'd never know.

### STEP SIX - INTERNET GLORY?

  You've done a great thing by increasing Aura's usability. Your name
will be included in both Aura's README and in its `-V` version message.
Thanks a lot for your hard work!
