CREATE SCHEMA IF NOT EXISTS pcdb DEFAULT CHARACTER SET utf8;

USE pcdb;


/*
======
Create Tables
======
*/


CREATE TABLE IF NOT EXISTS cond (
  condID INT NOT NULL AUTO_INCREMENT,
  condName CHAR(20) NULL,
  PRIMARY KEY (condID)
);

CREATE TABLE IF NOT EXISTS era (
  eraID INT NOT NULL AUTO_INCREMENT,
  eraName CHAR(20) NULL,
  PRIMARY KEY (eraID)
);

CREATE TABLE IF NOT EXISTS postcard ( 
  pcID INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(45) NOT NULL,
  description VARCHAR(200) NULL,
  isColor TINYINT NOT NULL,
  condID INT NOT NULL,
  eraID INT NOT NULL,
  PRIMARY KEY (pcID),
  CONSTRAINT fkPostcardCond
    FOREIGN KEY (condID)
    REFERENCES cond (condID),
  CONSTRAINT fkPostcardEra
    FOREIGN KEY (eraID)
    REFERENCES era (eraID)
);

CREATE TABLE IF NOT EXISTS purchase (
  pcID INT NOT NULL,
  purcPrice FLOAT(10,2) NULL,
  purcDate DATE NULL,
  PRIMARY KEY (pcID),
  CONSTRAINT fkPurchasePostcard
    FOREIGN KEY (pcID)
    REFERENCES postcard (pcID)
);

CREATE TABLE IF NOT EXISTS theme (
  themeID INT NOT NULL AUTO_INCREMENT,
  themeName CHAR(15) NULL,
  PRIMARY KEY (themeID)
);

CREATE TABLE IF NOT EXISTS pcthemes (
  pcthemeID INT NOT NULL AUTO_INCREMENT,
  pcID INT NOT NULL,
  themeID INT NOT NULL,
  PRIMARY KEY (pcthemeID),
  CONSTRAINT fkPcthemesPostcard
    FOREIGN KEY (pcID)
    REFERENCES postcard (pcID),
  CONSTRAINT fkPcthemesTheme
    FOREIGN KEY (themeID)
    REFERENCES theme (themeID)
);
      
/*
=====
Insert Data
=====
*/

INSERT INTO cond (condID, condName)
VALUES (null, 'Poor'), (null, 'Acceptable'), (null, 'Good'), (null, 'Very Good'), (null, 'Mint');

INSERT INTO era (eraID, eraName)
VALUES (null, 'Golden'), 
	   (null, 'Silver'), 
	   (null, 'Modern');

INSERT INTO postcard (pcID, title, description, isColor, condID, eraID)
VALUES (null, 'New York-1929', 'Depicts the Statue of Liberty', 0, 2, 1),
	   (null, 'New York-1929', 'Depicts the Statue of Liberty', 0, 5, 1)
	   (null, 'Flowers in Spring-1978', 'Depicts a woman running through a field of flowers', 1, 4, 3),
	   (null, 'Elvis Is Back-1960', 'Depicts Elvis Presley portrait from the album of the same name', 1, 5, 2),
	   (null, 'Elvis Is Back-1960', 'Depicts Elvis Presley portrait from the album of the same name', 1, 3, 2),
	   (null, 'Obama Hope-2009', 'Depicts Barrack Obama Hope poster by Shepard Fairey', 1, 4, 3),
	   (null, 'White City Chicago-1886', 'Depicts White City in Chicago', 1, 1, 1),
	   (null, 'Obama Hope-2009', 'Depicts Barrack Obama Hope poster by Shepard Fairey', 1, 2, 3),
	   (null, 'White City Chicago-1886', 'Depicts White City in Chicago', 1, 4, 1),
	   (null, 'Cats Trimming Hedges-1998', 'Depicts cats cutting a hedge in the shape of a Sphynx', 0, 5, 3);
	   
INSERT INTO purchase (pcID, purcPrice, purcDate)
VALUES (1, 20.25, '1998-10-01'),
	   (2, 125.00, '1999-01-12'),
	   (3, 58.00, '1999-01-12'),
	   (4, 39.48, '1999-01-12'),
	   (5, 2.45, '1999-03-15'), 
	   (6, 1.50, '2009-06-12'),
	   (7, 150.90, '2009-12-25'),
	   (8, 1.00, '2010-01-01'),
	   (9, 1250.75, '2010-01-01'),
	   (10, 1337.69, '2011-10-20');
	   
INSERT INTO theme (themeID, themeName)
VALUES (null, 'nature'),
	   (null, 'buildings'),
	   (null, 'people');
	   
INSERT INTO pcthemes (pcthemeID, pcID, themeID)
VALUES (null, 1, 2),
	   (null, 2, 2),
	   (null, 3, 1),
	   (null, 3, 3),
	   (null, 4, 3),
	   (null, 5, 3),
	   (null, 6, 3),
	   (null, 7, 2),
	   (null, 8, 3),
	   (null, 9, 2),
	   (null, 10, 1),
	   (null, 10, 2),
	   (null, 10, 3);

/*
=====
Queries
=====
*/

-- a > All the Postcards in the Collection

SELECT pcID, title 
	FROM postcard;

-- b > Number of Postcards in the Collection

SELECT COUNT(pcID) 
	FROM postcard;

-- c > Unique Postcards in the Collection

SELECT DISTINCT(title) 
	FROM postcard;

-- d > Duplicate Postcards in the Collection

SELECT title
	FROM postcard
	GROUP BY title
	HAVING count(title) > 1;
	
-- e > Postcards Purchased after 2000 with Theme of People

SELECT postcard.pcID, postcard.title, purchase.purcDate
	FROM postcard
	INNER JOIN purchase
	ON postcard.pcID = purchase.pcID
	INNER JOIN pcthemes
	ON postcard.pcID = pcthemes.pcID
	WHERE themeID = '3'
	AND purcDate > '1999-12-31';

-- f > Postcards from the Golden Era with Theme of People or Buildings

SELECT postcard.pcID, postcard.title
	FROM postcard
	INNER JOIN era
	ON postcard.eraID = era.eraID
	INNER JOIN pcthemes
	ON postcard.pcID = pcthemes.pcID
	WHERE themeID = '2'
	OR themeID = '3'
	AND eraName = 'golden';
	
-- g > Postcards with More than One Theme

SELECT postcard.pcID, postcard.title
	FROM postcard
	INNER JOIN pcthemes
	ON postcard.pcID = pcthemes.pcID
	GROUP BY pcID
	HAVING count(themeID) > 1;

-- h > Total Cost of Silver Era Postcards

SELECT SUM(purchase.purcPrice), era.eraName
	FROM postcard
	INNER JOIN purchase
	ON postcard.pcID = purchase.pcID
	INNER JOIN era
	ON postcard.eraID = era.eraID
	WHERE eraName = 'silver';
	
-- i > Average Price from Each Era

SELECT AVG(purchase.purcPrice), cond.condName
	FROM postcard
	INNER JOIN purchase
	ON postcard.pcID = purchase.pcID
	INNER JOIN cond
	ON postcard.condID = cond.condID
	GROUP BY condName;
	
-- j > Largest Amount of Money for a Card Not in Poor Condition

SELECT MAX(purchase.purcPrice), cond.condName
	FROM postcard
	INNER JOIN purchase
	ON postcard.pcID = purchase.pcID
	INNER JOIN cond
	ON postcard.condID = cond.condID
	GROUP BY condName
	HAVING condName != 'Poor'
	LIMIT 1;

/*
=====
Views
=====
*/

-- a > Postcard Title / Purchase Price / Condition

CREATE VIEW PriceVsCondition AS
	SELECT postcard.title, purchase.purcPrice, cond.condName
		FROM postcard
		INNER JOIN purchase
		ON postcard.pcID = purchase.pcID
		INNER JOIN cond
		ON postcard.condID = cond.condID;
		
-- b > Postcard Title / Theme / Era

CREATE VIEW ThemeVsEra AS
	SELECT postcard.title, theme.themeName, era.eraName
		FROM postcard
		INNER JOIN pcthemes
		ON postcard.pcID = pcthemes.pcID
		INNER JOIN theme
		ON pcthemes.themeID = theme.themeID
		INNER JOIN era
		ON postcard.eraID = era.eraID;
		
-- c > Average Cost per Unique Card / Theme

CREATE VIEW AverageCostVsTheme
	SELECT DISTINCT(postcard.title), AVG(purchase.purcPrice), theme.themeName
		FROM postcard
		INNER JOIN purchase
		ON postcard.pcID = purchase.pcID
		INNER JOIN pcthemes
		ON postcard.pcID = pcthemes.pcID
		INNER JOIN theme
		ON pcthemes.themeID = theme.themeID
		GROUP BY postcard.title, theme.themeName;