--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Table of defaults for the credit lines. Values in here are used if
-- an individual line later doesn't have the parallel entry.

CreditsDefaults = {
	str = "", -- Can be a localization database entry, or a raw string.
	font = "gamefont_small",
	ySpacing = 2, -- # of pixels between this line and the next (after formatting)
	ColorR = 255,
	ColorG = 255,
	ColorB = 255,

	MinHeight = 20, -- minimum height of a line of text (i.e. what's used by a blank line)

	-- Add one (or more) of the below entries (without being commented
	-- out) to a line to exclude it from that platform. For an example
	-- of it in action, look at the Gamespy line below and how it's turned
	-- off on the XBox

	-- bNoPS2 = 1,
	-- bNoXBox = 1,
	-- bNoPC = 1,

	ySpeed = 40, -- pixels/second. Used by *ALL* entries.
}

-- Credits, one sub-table per entry.
CreditLines = {
	{}, -- MUST START WITH BLANK LINE. Thank you.
	{ str = "STAR WARS", font = "gamefont_large", ColorB = 0,},
	{ str = "BATTLEFRONT II", font = "gamefont_large", ColorB = 0,},
	{ str = "Developed by Pandemic Studios in association with LucasArts", font = "gamefont_large", ColorB = 0,},
	{}, -- blank line
	{}, -- blank line
	{}, -- blank line
	{}, -- blank line
	
	{ str = "PANDEMIC STUDIOS, LLC", font = "gamefont_medium", ColorB = 0,},
	{}, -- blank line
	{ str = "ifs.credits.director", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Eric 'Giz' Gewirtz", },
		{}, 
	{ str = "ifs.credits.production", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Jim Tso", },
		{}, 
	{ str = "ifs.credits.producer", font = "gamefont_medium", ColorB = 0,},
		{}, 	
		{ str = "Chris Williams", },
		{}, 
	{ str = "ifs.credits.leaddesigner", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Peter Dellekamp Siefert", },
		{},
	{ str = "ifs.credits.artdirector", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Matthew Howland Palmer", },
		{},
	{ str = "Lead Programmer", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "John Northan", },
		{},
	{ str = "Network Technical Director", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Brad Pickering", },		
		{},
	{ str = "ifs.credits.programmers", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Christopher B. Baker", },

		{ str = "Jake Cannell", },
		{ str = "Jocelyn Chew", },
		{ str = "Steven Duan", },
		{ str = "Chris Fandrich", },
		{ str = "David Givone", },
		{ str = "Julian Manolov", },
		{ str = "Nathan Mates", },
		{ str = "Stewart Miles", },
		{ str = "Ken Miller", },
		{ str = "Salah Nouri", },
		{ str = "Brad Roepstorff", },
		{ str = "Jason Scanlin", },
		{ str = "Greg Walker", },
		{ str = "Mike Zaimont", },
		{},
	{ str = "Additional Programming", font = "gamefont_medium", ColorB = 0,},
		{},
		{ str = "Adam Batters", },
		{ str = "Dan Andersson", },
		{},
	{ str = "Lead Level Designer", font = "gamefont_medium", ColorB = 0,},
		{},
		{ str = "Sean Soucy", }, 
		{},
	{ str = "ifs.credits.designers", font = "gamefont_medium", ColorB = 0,},
		{},
		{ str = "Paul Baker", }, 
		{ str = "Chris Fusco", },
		{ str = "Greg Johnson", },
		{ str = "Michael A. Marzola", },
		{ str = "Dan Nanni", },
		{ str = "Joe 'P.Dawber' Shackelford", },
		{ str = "Brian 'Platinum' Warrington", },
		{},
	{ str = "ifs.credits.additionaldes", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Wallace Huang", },
		{ str = "Jeffrey Vaughn", },
		{}, 
	{ str = "ifs.credits.sounddesign", font = "gamefont_medium", ColorB = 0,},
		{},
		{ str = "Andrew Cheney", },
		{},
	{ str = "ifs.credits.leadanimator", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Juan Sanchez", },
		{}, 
	{ str = "ifs.credits.animator", font = "gamefont_medium", ColorB = 0,},
		{},
		{ str = "Elaina Scott", },
		{},
	{ str = "Environment Artists", font = "gamefont_medium", ColorB = 0,},
		{},
		{ str = "Chris 'Miggles' Arden", },
		{ str = "Moon K. Bae", },
		{ str = "Rob Keenan", },
		{ str = "Walter Cosico", },
		{ str = "Chris McGee", },
		{}, 
	{ str = "ifs.credits.artists", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Mutsuko Kasai Bunnag", },
		{ str = "Amie H. Hong", },
		{ str = "Sungpil 'Allen' Im", },
	
		{ str = "Takashi Morishima", }, 
		{ str = "Bryan Norton", },
		{ str = "Risako Taneda", },
		{ str = "Graham Traynor", },
		{ str = "Widyanto Wei Wiharjo", },
		{},

	{ str = "ifs.credits.additionalart", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Steven Leff", },
		{ str = "Andrew Mournian", },
		{}, 
	{ str = "ifs.credits.associateproducer", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "David Baker", },
		{ str = "Phillip Hong", },
		{},  
	{ str = "ifs.credits.productcoord", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Phuc Van Dinh", },
	{},  
	{ str = "ifs.credits.ceo", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Andrew Goldman", },
	{}, 
	{ str = "President", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Josh Resnick", },
	{}, 
	{ str = "Director of Production", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Greg Borrud", },
	{}, 
	{ str = "ifs.credits.executiveartdir", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Carey Chico", },
	{}, 
	{ str = "ifs.credits.directorofhr", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Tina Cruz-Williams", },
	{}, 
	{ str = "ifs.credits.directorops", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Joseph Donaldson", },
	{}, 
	{ str = "ifs.credits.directorof$", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Carl Lei", },
	{}, 
	{ str = "ifs.credits.prodsupport", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Mario Cabrera", },
	{ str = "Tim Diamond", },
	{ str = "Sean Hendon", },
	{ str = "Steven Leff", },
	
	{ str = "Tim McMahon", },
	{ str = "Christine Mithiaru-Sowers", },
	{ str = "Kent Schuelke", },
	{}, 

	{ str = "ifs.credits.interns", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Eric 'Anop' Rodgers", },
	{ str = "Frederick Badlissi", },
	{ str = "Christopher Hong", },
	{ str = "Eddie Rojas", },
	{ str = "Sam Fried", },
		{ str = "John Fritts", },
	{}, 
	{ str = "ifs.credits.video", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Ryan James", },
	{}, 
	{ str = "ifs.credits.writer", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Mike Stemmle", },
	{}, 
	{ str = "Interface Design and Animation Supplied By:", font = "gamefont_medium", ColorB = 0,},
	{ str = "1K Studios", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Matt Kennedy", },
	{ str = "Ali Sarrafan", },
	{}, 
	{ str = "ifs.credits.specialthanks", font = "gamefont_medium", ColorB = 0,},
	{},
	{ str = "Amy and Jennifer Tso", },
		{ str = "Ingrid Gewirtz & Noah Gewirtz", },
		{ str = "Nicole and Dieago Palmer", },
		{ str = "Andrey Kazmin.", },
		{ str = "David Rovin", },
		{ str = "Elias Slater", },
		{ str = "God", },
		{ str = "Jane & David Jin", },
		{ str = "Jinwook Lee", },
		{ str = "Viraj Andrew Bunnag", },
		{ str = "the Taneda family", },
		{ str = "Sofya Darbinyan", },
		{ str = "Charisee Grooms", },
		{ str = "Club Venom Executives", },
		{ str = "Rose and Al Bolden", },
		{ str = "The Drennon Family", },
		{ str = "Sofia Shershunovich", },
		{ str = "Savina Rizova", },
		{ str = "Ivanka, Momchil & Lubomir Manolovi", },
		{ str = "Liliana Petkova", },
		{ str = "The Rizovi Family", },
		{ str = "Bulgaria", },
		{ str = "Vanessa Johnson", },
		{ str = "Jon Manahan", },
		{ str = "Sean O'Connor", },
		{ str = "James Miller", },
		{ str = "Mark Griffin", },
		{ str = "Cliff Garrett", },
		{ str = "Chris Adoneos", },
		{ str = "John Adoneos", },
		{ str = "Julian Lebeck", },
		{ str = "Katy 'BP' Ditmore", },
		{ str = "Rick Viscarello", },
		{ str = "Mary", },
		{ str = "Wesley and Sydney Pickering", },
		{ str = "Sky Schulz", },
		{ str = "Alexander Cheney", },
		{ str = "Hayley Cheney", },
		{ str = "Kayla Cheney", },
		{ str = "Jennifer Shackelford", },
		{ str = "Dana Coffey", }, 
		{ str = "Megan Evanich", },
		{ str = "Miggells' pancreas", },
		{ str = "Michelle Webb", },
		{ str = "Jean Roh & Skylar Minjin Hong", },
		{ str = "Lilan and Jiyen Northan", },
		{ str = "Diddy Riese", },
		{ str = "Molly and Richard Siefert", },
		{ str = "the Keenan Family and Stephanie Richards", },
		{ str = "Hisako Seignemartin", },
		{ str = "Michael Sexton - CH Products", },
		{ str = "Ritche Corpus - Logitech", },
		{ str = "Robert Krakoff - Razer USA Ltd", },
		{},
	{ str = "Luci Wolfe, will you marry me?", },
	{},
	{ str = "Thanks to all our family and friends for their support in the making of this game.", },
	{},
	{ str = "LUCASARTS & PANDEMIC", },
	{},
	{ str = "Special Thanks to the worldwide members of the 501st Legion", },
	{},
	{ str = "www.501st.com/default.html", },
	{},
	{ str = "ifs.credits.dedicated", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Katie Johnson", },
	{},
	{ str = "www.heartofanempire.com/Katie", font = "gamefont_tiny",},
	{},
	{ str = "LUCASARTS", font = "gamefont_medium", ColorB = 0,},
	--{ str = "A DIVISION OF LUCASFILM LTD.", font = "gamefont_medium", ColorB = 0,},
	{},  
	{ str = "ifs.credits.producers", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Shara Miller", },
	{ str = "Dan Pettit", },
	{}, 
	{ str = "ifs.credits.associateproducer", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Corrine Wong", },
	{}, 
	{ str = "Additional Production", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Matthew Fillbrandt", },
	{}, 
	{ str = "Production Assistant", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "James Morris", },
	{}, 
	{ str = "Localization Producer", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Marianne Monaghan", },
	{}, 
	{ str = "ifs.credits.techdirect", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Jonathan Williams", },
	{}, 
	{ str = "ifs.credits.leadtesters", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "K.C. Coleman", },
	{ str = "Toby Mast", },
	{}, 

	{ str = "ifs.credits.assistantleadtesters", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Jeffrey Gullett", },
		{ str = "Matt Rubenstein", },
		{ str = "Xavier Rodriguez", },
		{}, 
	{ str = "ifs.credits.leadsounddes", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "David W. Collins", },
		{},	
	{ str = "ifs.credits.sounddesign", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Jim Diaz", },
		{ str = "Nick Peck", },
		{ str = "Harrison Deutsch", },
		{}, 
	{ str = "ifs.credits.cutsceneaudio", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Ellen Meijers", },
		{},		
	{ str = "ifs.credits.origstarwarssfx", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Ben Burtt", },
		{}, 
	{ str = "Music Editing/Implementation", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Jesse Harlin", },
		{}, 
	{ str = "ifs.credits.origswmusic", font = "gamefont_small", ColorB = 0,},
		{}, 
	{ str = "ifs.credits.origswmusiclegal", font = "gamefont_small", ColorB = 0,},
		{},  
	{ str = "Voice Director", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "David W. Collins", },
		{ str = "Will Beckman", },
		{}, 
	{ str = "ifs.credits.assvoiceDirector", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Jennifer Sloan", },
		{}, 
	{ str = "ifs.credits.leadvoiceeditor", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Harrison Deutsch", },
		{}, 
	{ str = "ifs.credits.voiceeditor", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Cindy Wong", },
		{ str = "G.W. Childs", },
		{},
	{ str = "ifs.credits.buildengineer", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Charlie Smith", },
		{ str = "Colin Carley", },
		{}, 

	{ str = "ifs.credits.textcrawl", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Eric Antanavich", },
		{}, 
	
	{ str = "International Project Manager", font = "gamefont_medium", ColorB = 0,}, 
		{ str = "Darren Keenan", },
		{},  
		 
	{ str = "Lead International Production Assistant", font = "gamefont_medium", ColorB = 0,}, 
		{ str = "Gary Chew", },
		{},  
	{ str = "International Production Assistants", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Erik Hamilton O'Keady", },
		{ str = "Cameron Suey", },
		{ str = "Ken Balough", },
		{}, 
	
	{ str = "International Lead Testers", font = "gamefont_medium", ColorB = 0,}, 
		{ str = "Christine Baxter", },
		{ str = "Jo-Anne Ladouceur", },
		{}, 
		 
	{ str = "ifs.credits.qatesters", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Adam Goodwin", },
		{ str = "Ahmad Abbott", },
		{ str = "Alex Bermudez", },
		{ str = "Anthony Paollilo", },
		--{ str = "Brian Deksnys", },
		{ str = "Brianna Woodward", },
		{ str = "Cameron 'Zest' Christian", },
		{ str = "Canaan McKoy", },
			{ str = "Carlos Galdamez", },
		{ str = "Chris Powell 'Slim'", },
		{ str = "Clark Parkhurst", },
		{ str = "Clay Norman", },
		{ str = "David Fleming", },
		{ str = "Eliot Cirivello", } ,
		{ str = "Enrico Granados", } ,
		{ str = "Eric Heisserrer", } ,
		{ str = "Eric Stephens", } ,
		{ str = "Eric 'ETS' Trenchard-Smith", },
		{ str = "Gabriel Bootz", } ,
		{ str = "Gavin 'Zile' Decantillon", },
		{ str = "Grace Morales", },
		{ str = "Greg Foster", },
		{ str = "Gregory Quinones", },
		{ str = "Henry Hall", },
		--{ str = "Ian Parham", },
		{ str = "Keith Romes", },
		{ str = "Jeff Atherton", },
		{ str = "Jeff James", },
		{ str = "Jeff Sanders", },
		{ str = "Jimmy Kowalski", },
		{ str = "Joe Acedillo", },
		{ str = "Jonathan Kwong", },
		{ str = "Jonathan Lo", },
		{ str = "John Arellano", },
		{ str = "Jonny Rice", },
		{ str = "Josh 'Fatboy' Cole", },
		{ str = "Josh Rotunda", },
		{ str = "Julian James", },
		{ str = "Kelly Robertson", },
		{ str = "Kevin A. Clark", },
		{ str = "Kip Bunyea", },
		{ str = "Kenneth Hile", },
		{ str = "Laura 'kewliz' Cabrera", },
		{ str = "Maccabee Shelley", },
		{ str = "Luis 'Ace' Bermudez", },
		{ str = "Manny Diaz", },
		{ str = "Mark Bailey", },
		{ str = "Mark McQuillen", },
		{ str = "Matthew Judkins", },
		{ str = "Michael Ward", },
		{ str = "Miguel Concepcion", },
		{ str = "Miguel Gonzales", },
		{ str = "Orion Kellogg", },
		{ str = "Orion Tiller", },
		{ str = "Ryan Adza", },
		{ str = "Ryan Martin", },
		
		
		{ str = "Seth Benton", },
		{ str = "Shinichiro Ohyama", },
		{ str = "Skot Kuiper", },
		{ str = "Tim Smith", },
		{ str = "Tommy Harney", },
		{ str = "Travis Fugit", },
		{ str = "Troy Sims", },
		{ str = "Zak Huntwork", },
		{ str = "Kenneth Brown II", },
		{}, 
	
	{ str = "International QA Testers", font = "gamefont_medium", ColorB = 0,}, 
		{ str = "Eric Bissonnette", },
		{ str = "Luc Cruz", },
		{ str = "Félix Gauthier", },
		{ str = "Eric Grossinger", },
		{ str = "Steeve Lachance", },
		{ str = "Nathanaël Legris", },
		{ str = "Philippe Masse", },
		{ str = "Claude Richer", },
		{ str = "Simon Tanguay-Côté", },
		{}, 
	
	{ str = "Additional Test", font = "gamefont_medium", ColorB = 0,},
		{},
		{ str = "Brandon Hutt", },
		{ str = "Chris Gross", },
		{ str = "Chris Thomas", },
		{ str = "Eric Brummel", },
		{ str = "Jeff Diaz", },
		{ str = "Joseph Frank", },
		{ str = "Kenneth Barnes", },
		{ str = "Mark Montuya", },
		{ str = "Neilie Johnson", },
		{ str = "Nick Dengler", },
		{ str = "Nick Eberle", },
		{ str = "Serge Tcherniavskii", },							
		{},
		{ str = "ifs.credits.seniorcompliancelead", font = "gamefont_medium", ColorB = 0,},
		{},
		{ str = "David Chapman", },
		{},
		{ str = "ifs.credits.complianceass", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Sarah Cherlin", },
		{}, 
		{ str = "ifs.credits.compliance", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Chris Navarro", },
		{ str = "Jason Wick", },
		{ str = "Ian Riutta", },
		{ str = "Renee Ya", },
		{}, 
		{ str = "Compatibility Supervisor and Lead Technical Writer", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Lynn Taylor", },
		{}, 
		{ str = "ifs.credits.srleadtech", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Dan Martinez", },
		{},   

	{ str = "Lead Compatibility Technician & Multiplayer Lab Lead", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Kim Jardin", },
		{},  
	{ str = "ifs.credits.compatibilitytech", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Brian Deksnys", },
		{ str = "Lester Siat", },
		{ str = "John Shields", },
		{ str = "Isaiah Webb", },
		{},  
	{ str = "Additional Compatibility Testing", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Jason Smith", },
		{ str = "Scott Taylor", },
		
		{}, 	
	{ str = "Enzyme Lab Management", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Frederic Plante", },
		{ str = "Eric Charbonneau", },
		{ str = "Carolljo Maher", },
		{ str = "Mark Springer", },
		{ str = "Kayven Meagher", },
		{ str = "Peter Cooke", },
		{ str = "Pierre Langlois", },
		{ str = "Dominic Corbeil", },
		{}, 
	{ str = "Enzyme Lab Testers", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Aki Holopainen", },
		{ str = "Marc Kingsbury", },
		{ str = "Dominic Luong", },
		{ str = "Raphael Lesage", },
		{ str = "Nick Alary", },
		{ str = "Eric Appelbaum", },
		{ str = "Georges Arvanitis", },
		{ str = "Mathieu Belair", },
		{ str = "Frederic Blanchette", },
		{ str = "Ryan Davis", },
		{ str = "Philip Latour", },
		{ str = "Tammy Loftus", },
		{ str = "Yan Ouellet", },
		--{ str = "Sebastien SteCroix", },
		--{ str = "Stian Weideborg", },
		{ str = "Iain Williamson", },
		{}, 
		
	{ str = "Enzyme Lab International Testers", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Jean-Scédrick Beauregard", },
		{ str = "Jean-Sébastien Côté", },
		{ str = "Patrick Couture", },
		{ str = "Martin Dodier", },
		{ str = "Mickael Fleury", },
		{ str = "Marc Fortin", },
		{ str = "Gabriele Garulli", },
		{ str = "Doriann Grillo", },
		{ str = "Francis Labrecque", },
		{ str = "Joanne Ladouceur", },
		{ str = "Joey Lockie", },
		{ str = "Antonio Marganella", },
		{ str = "Philippe Masse", },
		{ str = "Maxime Plessis", },
		{ str = "Joe Reardon", },
		{ str = "Philippe St-Amant", },
		{}, 
		{ str = "Pre-Certification Manager", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Philippe Lepage", },
		{}, 
		{ str = "Pre-Certification Team", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Maxime Sabourin", },
		{ str = "Cybel Fournier", },
		{ str = "François Berthiaume", },
		{ str = "Martin Ferland", },
		{}, 
		{ str = "Senior Director of Production Services", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Atsuko Matsumoto", },
		{}, 
	{ str = "ifs.credits.qualityman", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Paul Purdy", },
		{}, 
	{ str = "ifs.credits.qasupervisor", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Chuck McFadden", },
		{}, 
	{ str = "Senior Lead Tester", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Chane Doc Hollander", },
		{}, 
	{ str = "ifs.credits.qualityservices", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "John Carsey", },
		{}, 
	{ str = "Quality Services Coordinator", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Kellie Walker", },
		{}, 
	{ str = "Playability/Usability Specialist", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Heather Desurvire, Behavioristics, Inc.", },
		{}, 
	{ str = "Audio and International Department Manager", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Darragh O'Farrell", },
		{},	
	{ str = "ifs.credits.cast", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "ifs.credits.bobbergen", },
		{ str = "ifs.credits.bobbergen1", },
		{}, 
		{ str = "ifs.credits.christinarumbley", },
		{ str = "ifs.credits.christinarumbley1", },
		{}, 
		{ str = "ifs.credits.coreyburton", },
		{ str = "Count Dooku, Imperial Officer 2, Ki-Adi-Mundi", },
		{}, 
		{ str = "ifs.credits.daveboat", },
		{ str = "ifs.credits.daveboat1", },
		{}, 
		{ str = "David W. Collins", },
		{ str = "ifs.credits.davidcollins1", },
		{}, 
		{ str = "ifs.credits.jamesarnoldtaylor", },
		{ str = "ifs.credits.jamesarnoldtaylor1", },
		{},
		{ str = "ifs.credits.jamieglover", },
		{ str = "ifs.credits.jamieglover1", },
		{},  
		{ str = "ifs.credits.jonathancook", },
		{ str = "ifs.credits.jonathancook1", },	
		{}, 
		{ str = "ifs.credits.joycekurtz", },	
		{ str = "ifs.credits.joycekurtz1", },	
		{}, 
		{ str = "ifs.credits.lexlang", },	
		{ str = "ifs.credits.lexlang1", },	
		{}, 
		{ str = "ifs.credits.matlucas", },	
		{ str = "ifs.credits.matlucas1", },	
		{}, 
		{ str = "Matt Wood", },
		{ str = "ifs.credits.mattwood1", },	
		{}, 
		{ str = "ifs.credits.nickjameson", },	
		{ str = "ifs.credits.nickjameson1", },	
		{}, 
		{ str = "ifs.credits.rachelreenstra", },	
		{ str = "ifs.credits.rachelreenstra1", },	
		{}, 
		{ str = "ifs.credits.scottlawrence", },	
		{ str = "ifs.credits.scottlawrence1", },	
		{}, 
		{ str = "ifs.credits.steveblum", },	
		{ str = "ifs.credits.steveblum1", },	
		{}, 
		{ str = "ifs.credits.stevestanton", },	
		{ str = "ifs.credits.stevestanton1", },
		{}, 
		{ str = "ifs.credits.tccarson", },	
		{ str = "ifs.credits.tccarson1", },	
		{}, 
		{ str = "ifs.credits.temueramorrison", },	
		{ str = "ifs.credits.temueramorrison1", },	
		{}, 
		{ str = "ifs.credits.timomundson", },	
		{ str = "ifs.credits.timomundson1", },	
		{}, 
		{ str = "ifs.credits.tbd", },
		{ str = "ifs.credits.tbd1", },	
		{}, 
		{ str = "President", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Jim Ward", },
		{},
	{ str = "Executive Producer / VP Production", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Peter Hirschmann", },
		{},
	{ str = "Vice President of Finance", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Kevin Weston", },
		{}, 
	{ str = "Vice President of Global Marketing and Sales", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "John Geoghegan", },
		{}, 
	{ str = "Director of Marketing", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Kevin Kurtz", },
		{}, 
	{ str = "Director of Global Sales", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Kevin Kebodeaux", },
		{}, 
		{ str = "Director of Studio Operations", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Matt White", },
		{}, 
	{ str = "Product Marketing Manager", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Sam Saliba", },
		{}, 
	{ str = "Assistant Brand Manager", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Matt Shell", },
		{}, 
	{ str = "ifs.credits.dpr", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Anne Marie Stein", },
		{}, 
	{ str = "ifs.credits.prm", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Jason Anderson", },
		{}, 
	{ str = "ifs.credits.studiopub", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Chris Baker", },
		{}, 
	{ str = "ifs.credits.mediapub", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Alexis Mervin", },
		{ str = "Hadley Fitzgerald", },
		{}, 

	{ str = "ifs.credits.saleschannelmarketing", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Greg Robles", },
		{ str = "Kristina Landies", },
		{ str = "Mike Maguire", },
		{ str = "Terri Dome", },
		{ str = "Tim Moore", },
		{}, 
	{ str = "Operations", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Evelyne Bolling", },
		{ str = "Scott Fry", },
		{}, 
	{ str = "Internet Manager", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Jim Passalacqua", },
		{}, 
	{ str = "Director of Consumer Insights", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Sean Denny", },
		{}, 
	{ str = "Consumer Insights Specialist", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Melissa Blegen", },
		{},
	{ str = "Lucas Licensing", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Chris Gollaher", },
		{ str = "Kristi Kaufman", },
		{ str = "Leland Chee", },		
		{ str = "Stacy Cheregotis", },
		{}, 
		 			
	{ str = "Studio Coordinator", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Peggy Ary", },
		{ str = "Mette Adams", },
		{}, 
	{ str = "IT Support", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Jim Carpenter", },
		{ str = "Daryll Jacobson", },
		{ str = "Dinesh Katariya", },
		{ str = "Joe Shum", },
		{ str = "Chad Katariya", },
		{ str = "John von Eichhorn", },
		{ str = "Greg millies", },
		{ str = "Victor Tancredi-Ballugera", },
		{ str = "John Doak", },
		{ str = "Mike Ethridge", },
		{ str = "Melanie Jacobson", },
		{}, 
	{ str = "Manual Writer", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Matthew Keast", },
		{}, 
	{ str = "Manual Editor", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Ken Balough", },
		{}, 
	{ str = "Creative Services Manager/Manual Designer", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Patty Hill", },
		{}, 
	{ str = "Mastering Lab Supervisor", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Jay Geraci", },
		{}, 
	{ str = "ifs.credits.masterlab", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Eric Rauch", },
		{ str = "Jay Tye", },
		{ str = "Scott Taylor", },
		{},
	{ str = "Business Affairs", font = "gamefont_medium", ColorB = 0,},
		{}, 
		{ str = "Seth Steinberg", },
		{ str = "Mark Barolak", },
		{ str = "Jannett Shirley-Paul", },
		{ str = "Anne Marie Hawkins", },
		{ str = "John Garrett", },
		{}, 
		
	{ str = "Lua programming language Copyright © 1994-2004 Tecgraf, PUC-Rio.", font = "gamefont_small"},
	--{ str = "ifs.credits.lua2", font = "gamefont_small"},
	{}, 
	{ str = "ifs.credits.gamespy", bNoXBox = 1, font = "gamefont_small", ColorB = 0,},
	{}, 
	{ str = "ifs.credits.bink", bNoXBox = 1, bNoPS2 = 1, font = "gamefont_small", ColorB = 0,},
	{}, 
	{ str = "ifs.credits.zlib", font = "gamefont_small", ColorB = 0,},
	{}, 
	{}, 
	{ str = "ifs.credits.libpng", bNoXBox = 1, bNoPS2 = 1, font = "gamefont_small", ColorB = 0,},
	{}, 
	{ str = "Special Thanks", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Abbott family, Kollar family, and all my friends", },
	{ str = "Aiden Johnas Deksnys", },
	{ str = "Al Goldsmith", },
	{ str = "Alex Sievers", },
	{ str = "Amanda Yaste", },
	{ str = "Bryan Siat", },
	{ str = "Carly Richardson", },
	{ str = "Carson Hildreth for loving a gamer", },
	{ str = "Catherine Durand", },
	{ str = "Charlie Murphy", },
	{ str = "Chris Adoneos ", },
	{ str = "Chris Hockabout", },
	{ str = "Christian, Meghan & Luke", },
	{ str = "Chuck & Val", },
	{ str = "Collins, Ayres, Donahoe, and Tekautz families", },
	{ str = "Currin Cyr", },
	{ str = "Cyn Martinez", },
	{ str = "Elvis & Gail", },
	{ str = "Eric Johnston", },
	{ str = "Erin Haver", },
	{ str = "Eva Klein", },
	{ str = "Ferdinand Porsche", },
	{ str = "GhostGirl", },
	{ str = "Jack and Gayvin O'Keady", },
	{ str = "Jack Hirschmann", },
	{ str = "James Miller", },
	{ str = "John Adoneos", },
	{ str = "Jonathan Manahan", },
	{ str = "Julian Lebeck", },
	{ str = "Justin Lambros", },
	{ str = "Katy Ditmore", },
	{ str = "Mackenzie Merrill-Wick", },
	{ str = "Mai K Tseng", },
	{ str = "Matthew Baume", },
	{ str = "Matthew Widener", },
	{ str = "Melissa Cordova, my LoVe", },
	{ str = "Mysty with the Goldie Lookin' Chain for all the Safety", },
	{ str = "Raleigh Mann", },
	{ str = "Robert Monaghan", },
	{ str = "Robin Pettit", },
	{ str = "Sara Harrison", },
	{ str = "Sean O'Connor", },
	{ str = "Stacey Schrieber", },
	{ str = "Stuart Allen", },
	{ str = "Tabitha Tosti", },
	{ str = "The Coleman Family and all my friends.", },
	{ str = "The GLC from Newport, Wales", },
	{ str = "The Millers and the Cavanaughs", },
	{ str = "The Montrose Meteors", },
	{ str = "The Rice Family", },
	{ str = "The Ward Family", },
	{ str = "Trish Visita", },
	{ str = "Trish, Liz, Vlad, and Sarah", },
	{ str = "Uni McFadden-Goodwin-Sims", },
	{ str = "Vanessa, Laura, Marc, Wendi, Kevin and the rest of the Jardin extended family", },
	{ str = "Vinea", },
	{ str = "Will Melick", },
	{ str = "Wong & Lau Family", },	
	

	{}, 
	{ str = "In Memory of", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "Aunt Deedee", },
	{ str = "Carol Shoup-Sanders, John R. Shoup", },
	{ str = "Charles & Audrey Benton", },
	{ str = "Deborah Pacheco", },
	{ str = "Florence Benjamin", },
	{ str = "Gerald Glenn Fenimore", },
	{ str = "Johnny Jardin", },
	{ str = "Kathryn Killenger", },
	{ str = "Lloyd and Margaret Suey", },
	{ str = "Nereida Quinones", },
	{ str = "Robert Pratt", },
	{ str = "Ruth Davenport", },
	{ str = "Sandi Schrieber", },
	{ str = "Tanya & Elmer Gullett", },

	{}, 
		{}, 
	{ str = "ifs.credits.veryspecialthanks", font = "gamefont_medium", ColorB = 0,},
	{}, 
	{ str = "George Lucas", },
	{}, 
}

-- Sets one line. iLineIdx is the internal line index onscreen (1=
-- topmost line), iCreditEntry is the entry on the credits list (1 =
-- first line).
function ifs_credits_fnSetLine(this,iLineIdx,iCreditEntry)
	local fLeft, fTop, fRight, fBot
	local MaxEntry = table.getn(CreditLines)
	if((iCreditEntry < 1) or (iCreditEntry > MaxEntry)) then
		iCreditEntry = 1 -- go to safe (blank) line
	end

	local Name = string.format("l%d",iLineIdx)
	IFText_fnSetFont(this.Lines[Name],CreditLines[iCreditEntry].font or CreditsDefaults.font)
	IFText_fnSetString(this.Lines[Name],CreditLines[iCreditEntry].str or CreditsDefaults.str)
	local ColorR = CreditLines[iCreditEntry].ColorR or CreditsDefaults.ColorR
	local ColorG = CreditLines[iCreditEntry].ColorG or CreditsDefaults.ColorG
	local ColorB = CreditLines[iCreditEntry].ColorB or CreditsDefaults.ColorB
	IFObj_fnSetColor(this.Lines[Name],ColorR,ColorG,ColorB)
	IFObj_fnSetPos(this.Lines[Name],this.fTextX,this.Lines[Name].y)

	-- Set y-position of next line (if it exists)
	if(iLineIdx < this.iMaxLines) then
		local NameNext = string.format("l%d",iLineIdx + 1)
		fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(this.Lines[Name]) -- get display height
		local DispHeight = math.max((fBot - fTop) , CreditsDefaults.MinHeight)

		this.Lines[NameNext].y = this.Lines[Name].y + DispHeight + 
			(CreditLines[iCreditEntry].ySpacing or CreditsDefaults.ySpacing)
	end
end

-- Reads this.iTopLine, sets all lines. Entries are spaced off the top
-- entry's y-position
function ifs_credits_fnSetAllLines(this)
	local i
	local iCreditEntry = this.iTopLine

	-- Precalculate some values
	local bIsPS2 = (gPlatformStr == "PS2")
	local bIsXBox = (gPlatformStr == "XBox")
	local bIsPC = (gPlatformStr == "PC")
	local MaxEntry = table.getn(CreditLines)

	for i=1,this.iMaxLines do
		-- Find next line that's not excluded from this platform (or the
		-- end of the list)
		local bGotLine = nil
		repeat
			iCreditEntry = iCreditEntry + 1
			if((iCreditEntry < 1) or (iCreditEntry > MaxEntry)) then
				bGotLine = 1
			elseif (bIsPS2 and (CreditLines[iCreditEntry].bNoPS2)) then
				bGotLine = nil	
			elseif (bIsXBox and (CreditLines[iCreditEntry].bNoXBox)) then
				bGotLine = nil
			elseif (bIsPC and (CreditLines[iCreditEntry].bNoPC)) then
				bGotLine = nil
			else
				bGotLine = 1
			end
		until bGotLine

		ifs_credits_fnSetLine(this,i,iCreditEntry)
	end
end

function ifs_credits_fnUpdate(this, fDt)
	local dy = fDt * CreditsDefaults.ySpeed

	-- Advance a line when the second entry is partly off the top of the
	-- screen (and therefore the first entry must be 100% off the
	-- screen)
	if(this.Lines.l2.y < 0) then
		this.Lines.l1.y = this.Lines.l2.y - dy
		this.iTopLine = this.iTopLine + 1
		ifs_credits_fnSetAllLines(this)

		if(this.iTopLine > table.getn(CreditLines)) then
			ScriptCB_PopScreen()
		end
	else
		-- Top line isn't 100% off. Just scroll all entries up
		local i
		for i=1,this.iMaxLines do
			local Name = string.format("l%d",i)
			this.Lines[Name].y = this.Lines[Name].y - dy
			
			IFObj_fnSetPos(this.Lines[Name],this.fTextX, this.Lines[Name].y)
		end
	end
end


ifs_credits = NewIFShellScreen {
	bNohelptext_accept = 1,
	bg_texture = "ifs_credits",

	Lines = NewIFContainer {
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		UseSafezone = 0,
		rotX = 40,
		zpos = 210, -- helptext is at 200, must be behind it
	},
    
	movieIntro      = nil,
	movieBackground = nil,

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		-- Start items so that the first entry is near the bottom of the screen
		local r,b,v
		r,b,v=ScriptCB_GetSafeScreenInfo()
		this.iTopLine = -math.floor(b / CreditsDefaults.MinHeight) + 2

		this.Lines.l1.y = 0 -- set first entry to top of screen
		ifs_credits_fnSetAllLines(this)
	end,
	

	Update = function(this, fDt)
		-- Call base class functionality
		gIFShellScreenTemplate_fnUpdate(this, fDt)
		ifs_credits_fnUpdate(this, fDt)
	end,

	-- Overrides for most input handlers, as we want to do nothing
	-- when this happens on this screen.
	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gPlatformStr == "PC") then
			ScriptCB_PopScreen()
		end
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end
	end,

	Input_Start = function(this)
		if(gPlatformStr == "PC") then
			ScriptCB_PopScreen()
		end
	end,

	Input_GeneralLeft = function(this)
		if(gPlatformStr == "PC") then
			this.CurButton = "_back"
			SetCurButton(this.tag)
		end
	end,
	Input_GeneralRight = function(this)
		if(gPlatformStr == "PC") then
			this.CurButton = "_back"
			SetCurButton(this.tag)
		end
	end,
	Input_GeneralUp = function(this)
		if(gPlatformStr == "PC") then
			this.CurButton = "_back"
			SetCurButton(this.tag)
		end
	end,
	Input_GeneralDown = function(this)
		if(gPlatformStr == "PC") then
			this.CurButton = "_back"
			SetCurButton(this.tag)
		end
	end,
}

function ifs_credits_fnBuildScreen(this)
	-- Ask game for screen size, fill in values
	local r,b,v,w=ScriptCB_GetScreenInfo()
	local sr,sb
	sr,sb=ScriptCB_GetSafeScreenInfo()
	sr = sr * 0.62 -- angle on text blows things out of safezone by a mile, must shrink it
	this.fScreenB = b
	this.iMaxLines = math.floor(b / CreditsDefaults.MinHeight) + 5
	this.fTextX = (r*w - sr) * 0.5 -- center text within safezone

	local i
	for i=1,this.iMaxLines do
		local Name = string.format("l%d",i)
		this.Lines[Name] = NewIFText { 
			halign = "hcenter",
			valign = "top",
			textw = sr, 
			texth = 2 * sb, -- Gamespy text is HUUUGE, so allow lots of space as a math.max
			nocreatebackground = 1,
			flashy = 0,
		}
	end

	-- Place helptext in front of text. Fixes BF2 TCR bug #201
	this.Helptext_Back.ZPos = 100
end

ifs_credits_fnBuildScreen(ifs_credits) -- programatic chunks
ifs_credits_fnBuildScreen = nil
AddIFScreen(ifs_credits,"ifs_credits")
