test: SkipJack.hs SkipJackTest.hs
	ghc -Wall -Werror -XTemplateHaskell TestSuite.hs && ./TestSuite

app: Encryptor.hs Decryptor.hs Hasher.hs XGenerator.hs Signaturer.hs Verifier.hs
	ghc -Wall -Werror Encryptor.hs
	ghc -Wall -Werror Decryptor.hs
	ghc -Wall -Werror Hasher.hs
	ghc -Wall -Werror XGenerator.hs
	ghc -Wall -Werror Signaturer.hs
	ghc -Wall -Werror Verifier.hs