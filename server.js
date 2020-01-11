const express = require('express')
const app = express()
const port = 3000
const {
  Client,
  Pool
} = require('pg')


const client = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'facebook',
  password: 'root',
  port: 5432,
})
client.connect()

app.use('/', express.static('public'));

app.get('/posts', async (req, res) => {
  await client.query('SELECT * FROM posts', (err, response) => {
    res.json(response.rows)
  })
})

app.get('/user', async (req, res) => {
  await client.query("SELECT concat(first_name, ' ', last_name) as name, email, user_id, first_logged  FROM users where users.user_id=2", (err, response) => {
    res.json(response.rows)
  })
})

app.get('/posts-with-nbr-comments-and-reactions', async (req, res) => {
  var _query = `  
  select first_name, last_name, content, nbr_reactions, posts_with_reactions.post_id, count(comments.message) as nbr_comments from comments
  full join (
    select users.first_name, users.last_name , posts.user_id, posts.post_id, posts.content, count(reactions.type_reaction) as nbr_reactions from posts
    inner join users on posts.user_id = users.user_id
    full join reactions on reactions.post_id = posts.post_id
    group by posts.post_id, users.first_name,  users.last_name
  ) as posts_with_reactions
  on comments.post_id = posts_with_reactions.post_id
  group by posts_with_reactions.first_name, posts_with_reactions.last_name, posts_with_reactions.content, posts_with_reactions.nbr_reactions, posts_with_reactions.post_id`;
  await client.query(_query, (err, response) => {
    res.json(response.rows)
  })
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}!`)
})