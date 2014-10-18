run: SkipJack.hs SkipJackTest.hs
	ghc -Wall -Werror -XTemplateHaskell SkipJackTest.hs && ./SkipJackTest