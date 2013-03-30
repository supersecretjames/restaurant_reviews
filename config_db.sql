CREATE TABLE chefs (
	id INTEGER PRIMARY KEY,
	fname VARCHAR(255) NOT NULL,
	lname VARCHAR(255) NOT NULL,
	mentor INTEGER
);

INSERT INTO chefs ('id', 'fname', 'lname', 'mentor')
VALUES (1, 'Michael', 'Mina', NULL),
			 (2, 'Harrison', 'Ford', 1),
			 (3, 'Han', 'Solo', 1),
			 (4, 'Richard', 'Kimble', 1),
			 (5, 'Henry', 'James', 2);


CREATE TABLE restaurants (
	id INTEGER PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	neighborhood VARCHAR(255) NOT NULL,
	cuisine VARCHAR(255) NOT NULL 
);

INSERT INTO restaurants ('id', 'name', 'neighborhood', 'cuisine')
VALUES (1, 'Super Duper', 'SOMA', 'burgers'), 
			 (2, 'Mefhil Indian Cuisine', 'South Beach', 'Indian'),
	     (3, 'Papalote', 'Mission', 'Mexican'), 
	     (4, 'Beretta', 'Mission', 'Italian'),
	     (5, 'La Traviata', 'Mission', 'Italian');

CREATE TABLE chef_tenures (
	id INTEGER PRIMARY KEY,
	chef_id INTEGER NOT NULL,
	restaurant_id INTEGER NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE,
	head_chef INTEGER NOT NULL,

	FOREIGN KEY (chef_id) REFERENCES chefs(id),
	FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

INSERT INTO chef_tenures ('id', 'chef_id', 'restaurant_id', 'start_date', 
		'end_date', 'head_chef')
VALUES (1, 1, 1, '1980-03-23', '2005-06-06', 1), 
			 (2, 2, 1, '1984-01-29', '1985-03-17', 0),
			 (3, 3, 1, '1985-02-14', '1990-01-22', 0), 
			 (4, 4, 1, '1985-04-26', '2013-03-27', 0),
			 (5, 2, 2, '1986-03-18', '2010-01-01', 1), 
			 (6, 2, 3, '1990-01-29', '2008-05-20', 1),
			 (7, 5, 4, '2009-08-22', '2012-12-31', 1);

CREATE TABLE critics (
	id INTEGER PRIMARY KEY,
	screen_name VARCHAR(255) NOT NULL
);

INSERT INTO critics ('id', 'screen_name')
VALUES (1, 'happyclam'), (2, 'i_hate_beets'), (3, 'pizza_fan');

CREATE TABLE restaurant_reviews (
	id INTEGER PRIMARY KEY,
	reviewer_id INTEGER NOT NULL,
	restaurant_id INTEGER NOT NULL,
	text_review TEXT NOT NULL,
	score INTEGER NOT NULL,
	review_date DATE,

	FOREIGN KEY (reviewer_id) REFERENCES critics(id),
	FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

INSERT INTO restaurant_reviews (
	'id', 'reviewer_id', 'restaurant_id', 'text_review', 'score', 'review_date'
	)
VALUES (1, 1, 1, "This place is the best!", 20, '2000-10-10'),
			 (2, 2, 1, "This place sucks. Too many beets.", 5, '2001-01-01'),
			 (3, 3, 1, "Not enough pizza.", 7, '2007-12-23'), 
			 (4, 1, 2, "Best chicken tikka masala!", 18, '2005-05-21'),
			 (5, 3, 3, "Not enough pizza.", 7, '2007-12-23'), 
			 (6, 3, 4, "Not enough pizza.", 5, '2007-12-23'), 
			 (7, 3, 5, "Not enough pizza.", 1, '2007-12-23');
