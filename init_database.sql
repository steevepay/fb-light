CREATE DATABASE facebook;

-- CREATIONS DES TABLES

CREATE TABLE users (
  user_id serial PRIMARY KEY,
  first_name varchar(30) NOT NULL,
  last_name varchar(30) NOT NULL,
  email varchar(50) UNIQUE NOT NULL,
  last_logged timestamp,
  first_logged timestamp
)

CREATE TABLE passwords (
  pwd_id serial PRIMARY KEY,
  user_id integer REFERENCES users(user_id),
  salt varchar(20) NOT NULL,
  pwd varchar NOT NULL
)

CREATE TABLE friends (
  friend_id serial PRIMARY KEY,
  user_one_id integer REFERENCES users(user_id),
  user_two_id integer REFERENCES users(user_id),
  is_friend Boolean DEFAULT False,
  relation integer
)

CREATE TABLE posts (
  post_id serial PRIMARY KEY,
  user_id integer REFERENCES users(user_id),
  text varchar(200)
)

CREATE TABLE images (
  img_id serial PRIMARY KEY,
  user_id integer REFERENCES users(user_id),
  post_id integer REFERENCES posts(post_id),
  name varchar(255),
  url varchar(1000) NOT NULL,
  type integer
)

CREATE TABLE comments (
  comment_id serial PRIMARY KEY,
  user_id integer REFERENCES users(user_id),
  post_id integer REFERENCES posts(post_id),
  message varchar(1000) NOT NULL
)

CREATE TABLE reactions (
  reaction_id serial PRIMARY KEY,
  user_id integer REFERENCES users(user_id),
  post_id integer REFERENCES posts(post_id),
  comment_id integer REFERENCES comments(comment_id),
  type_reaction integer
)

-- Création des données

INSERT INTO users (
  first_name,
  last_name,
  email,
  last_logged,
  first_logged
)
VALUES (
  'Eric',
  'JohnSon',
  'eric@gmail.com',
  '2017-01-19',
  '2017-01-19'
),
(
  'John',
  'Wick',
  'John@wick.com',
  '2015-01-19',
  '2015-01-19'
),
(
  'Leyla',
  'Lo',
  'Leyla@feiuwhfweiu.com',
  '2012-01-19',
  '2012-01-19'
);

INSERT INTO passwords 
(user_id, salt, pwd)
VALUES 
( 1, '2yB7ujCBF9w', 'adBVShMzdutd6RkXzGn8Zje'),
( 2, 'WdB8UX3Zkyp6', 'KRzF2wFJwKJdEDMBX8SesWU'),
( 3, 'dGFDNh8vaBwP', '6Tafi4rUKwaUftPJqpZnDcYj')

INSERT INTO posts
(user_id, text)
VALUES 
( 2, "J'ai bien mangé à la cantine ce midi.");

INSERT INTO posts 
(user_id, content)
VALUES 
( 2, 'Miam miam')
returning *;

INSERT INTO posts 
(user_id, content)
VALUES 
( 3, 'Ceci est mon premier post facebook. Je vous souhaite une bonne journée !')
returning *;

INSERT INTO comments (
  user_id,
  post_id,
  message
)
VALUES (
  1, 
  2,
  'Mhhhhhhh 👌'
)


-- AVOIR les commentaires et les nom des utilisateurs:
select * from posts
join comments on posts.post_id = comments.post_id
join users on users.user_id = comments.user_id

-- AJOUTER DES REACTIONS:
INSERT INTO reactions 
(
  user_id,
  post_id,
  type_reaction
) 
VALUES (
  1,
  2,
  0
)
returning *;

INSERT INTO reactions 
(
  user_id,
  post_id,
  type_reaction
) 
VALUES (
  3,
  2,
  0
)
returning *;

