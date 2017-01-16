# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

comedians = [
  { name: 'Jimmy Carr' },
  { name: 'Ed Byrne' },
  { name: "Dara O'Briain" },
  { name: 'Micky Flanagan' },
  { name: 'Eddie Izzard' },
  { name: 'Bill Burr' }
]

comedians.each do |comedian|
  Comedian.where(name: comedian[:name]).first_or_create
end