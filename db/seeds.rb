# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do |i|
  User.create(username: "dog#{i + 1}")
  Poll.create(title: 'favorite_dog', author_id: i + 1)
end


Question.create(poll_id: 1, text: "What is your favorite dog?")
Question.create(poll_id: 2, text: "What is your favorite cat?")





10.times do |i|
  a = User.find(i + 1)
  AnswerChoice.create(question_id: 1, text: a.username)
  Response.create(user_id: i + 1, answer_choice_id: i + 1)
end

AnswerChoice.create(question_id: 3, text: "cat2")
Response.create(user_id: 3, answer_choice_id: )
