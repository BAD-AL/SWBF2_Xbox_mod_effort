Localization in SWBF2 is done through the MultiLanguageTool.exe program in the shipped mod tools.
Strings are typically given identifiers like 'entity.imp.hero_darthvader'. For efficiency reasons
these identifiers (or keys) are hashed when 'munging' localization. So even though 'entity.imp.hero_darthvader'
is 27 characters long, the identifier ends up as 4 bytes  in the game files. 
The game uses hashes in several places instead of actual strings.

The problem is that the localization tool doesn't know how to deal with hashes. Once these string 
ids are 'hashed' it is not easy or fast to 'unhash' them. When resolving these ids, one would 
typically create a dictionary of known 'keys' with their hash values in order to do a look up. 

The mod tools ships with a handy program called 'hash.exe' that uses the same hash algorithm.
This can be useful to check keys and key hashes. It also has an inverse hash function that can be 
useful to 'unhash'. But... It takes a very long time to resolve longer keys.

When the modtools shipped, it gave us common localization + PC localization. We did not get the 
Xbox, PS2 or PSP specialized content. 

I have been working on resolving as many of those ids as I can and have put the results in this 
folder.
