run: SkipJack.hs SkipJackTest.hs
	ghc -Wall -Werror -XTemplateHaskell TestSuite.hs && ./TestSuite