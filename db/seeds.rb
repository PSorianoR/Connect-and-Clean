# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "open-uri"
require "faker"

User.destroy_all
Property.destroy_all
Team.destroy_all
Job.destroy_all
JobApplication.destroy_all
Role.destroy_all
Review.destroy_all
Chatroom.destroy_all

array_of_users = []
emails = ["humberto@lewagon.com", "matt@lewagon.com", "ben@lewagon.com", "pedro@lewagon.com",
"alicja@lewagon.com" ]
first_names = ["Humberto", "Matt", "Ben", "Pedro", "Alicja"]
last_names = ["Pedra", "Mcgoovern", "Van Dam", "Soriano", "Surzyn"]
addresses = ["Rua Mariz e Barros, Tijuca, Rio De Janeiro, Brazil", "4523  Cedar Lane, Boston, Massachusetts, USA", "Carnotstraat 152, 2060 Antwerpen, Belgium", "1840  Eglinton Avenue, Toronto, Ontario, Canada",
"Jardines Del Country, Mascarones Street, Guadalajara, Mexico"]

user_photos = ["https://ca.slack-edge.com/T02NE0241-U05H2NBRFFY-2422604e0f19-512", "https://ca.slack-edge.com/T02NE0241-U05HJTYFZHP-e8affc977624-512","https://ca.slack-edge.com/T02NE0241-U05GUFPNAF9-29d236e53e03-512", "https://ca.slack-edge.com/T02NE0241-U05GAH9GN5D-d73433a0850a-512",
"https://ca.slack-edge.com/T02NE0241-U05FVLK1859-a09f85bddaf5-512"]


puts "Starting to seed..."

puts "Seeding users..."

emails.each_with_index do |email, index|


  puts "seeding user n. #{index + 1}"
  user = User.new(email: email, first_name: first_names[index],
    last_name: last_names[index], password: '123456',
    address: addresses[index])

    file = URI.open(user_photos[index])
    user.photo.attach(io: file, filename: "nes.png", content_type: "image/png")
    user.save!
  array_of_users << user
end

puts "Seeding roles..."

# Define roles as a hash with user emails as keys and role arrays as values
roles = {
  "humberto@lewagon.com": ["manager"],
  "matt@lewagon.com": ["cleaner", "manager"],
  "pedro@lewagon.com": ["cleaner", "manager"],
  "ben@lewagon.com": ["cleaner"],
  "alicja@lewagon.com": ["cleaner", "manager"]
}

# Iterate over the roles hash and create roles for users
roles.each do |email, role_names|
  user = User.find_by(email: email)

  if user
    role_names.each do |role_name|
      Role.create!(user: user, role: role_name)
    end
  else
    puts "User with email #{email} not found."
  end
end

puts "Seeding properties..."

Property.create!({ title: "Casa Serrana do Humberto", user: User.find_by(first_name: "Humberto"),
  address: "Alameda Arnaldo Guinle, 10, Teresopolis, Brazil", default_job_price: 25, default_cleaning_from: "11:00", default_cleaning_until: "14:00"})

Property.create!({ title: "Alicja's Crib on Rio", user: User.find_by(first_name: "Alicja"),
address: "Voluntarios da Patria 90, Botafogo, Rio de Janeiro, Brazil", default_job_price: 50, default_cleaning_from: "09:00", default_cleaning_until: "18:00"})

Property.create!({ title: "Casa Praiana do Humberto", user: User.find_by(first_name: "Humberto"),
  address: "Rua das Pedras 10, Buzios, Rio de Janeiro, Brazil", default_job_price: 35, default_cleaning_from: "10:00", default_cleaning_until: "12:00"}
  )



  puts "Seeding teams..."

  # Creating managers for a property

    #First property only has the owner as manager (created by default when someone creates a property)
    Team.create!({ user: User.find_by(first_name: "Humberto"), property: Property.first, profession: "manager"})


    Team.create!({ user: User.find_by(first_name: "Alicja"), property: Property.find_by(title: "Alicja's Crib on Rio"), profession: "manager"})

    # Second property has three managers:
  Team.create!({ user: User.find_by(first_name: "Humberto"), property: Property.last, profession: "manager"})
  Team.create!({ user: User.find_by(first_name: "Matt"), property: Property.last, profession: "manager"})
  Team.create!({ user: User.find_by(first_name: "Pedro"), property: Property.last, profession: "manager" } )




  # Creating cleaners for a property

  # first property has two cleaners:
  Team.create!({ user: User.find_by(first_name: "Ben"), property: Property.first, profession: "cleaner" })
  Team.create!({ user: User.find_by(first_name: "Pedro"), property: Property.first, profession: "cleaner" })

  # Second property has one cleaner
  Team.create!({ user: User.find_by(first_name: "Matt"), property: Property.last, profession: "cleaner" })
  Team.create!({ user: User.find_by(first_name: "Pedro"), property: Property.last, profession: "cleaner" })

  puts "Seeding jobs..."
  # The user of a job is the person who created the job.
  # The cleaner of the job is the person who has status accepted or completed for that job in the
  # job_applications table Cleaner is therefore not a column in jobs table.

  # first property has 4 jobs: 1 Open, 1 applied, 1 accepted, 1 completed
  Job.create!({ property: Property.first, price: 25, status: "open", user: User.find_by(first_name: "Humberto"), description: "Please clean my Casa Serrana!", date_of_job: Date.new(2023,9,1) })
  Job.create!({ property: Property.first, price: 25, status: "applied", user: User.find_by(first_name: "Humberto"), description: "Please clean my Casa Serrana! again.", post_all: true, date_of_job: Date.new(2023,9,2) })
  Job.create!({ property: Property.first, price: 25, status: "accepted", user: User.find_by(first_name: "Humberto"), description: "Please clean my Casa Serrana for the third time", date_of_job: Date.new(2023,9,3) })
  Job.create!({ property: Property.first, price: 25, status: "completed", user: User.find_by(first_name: "Humberto"), description: "Please clean my Casa Serrana for the forth time", date_of_job: Date.new(2023,9,4) })
  Job.create!({ property: Property.first, price: 100, status: "completed", user: User.find_by(first_name: "Humberto"), description: "job5property1", date_of_job: Date.new(2023,9,5) })

  # second property has 2 jobs: 1 applied, 1 completed
  Job.create!({ property: Property.last, price: 35, status: "applied", user: User.find_by(first_name: "Matt"), description: "Please clean my Casa de Praia in Buzios!", date_of_job: Date.new(2023,9,6) })
  Job.create!({ property: Property.last, price: 35, status: "completed", user: User.find_by(first_name: "Humberto"), description: "Please clean my Casa de Praia in Buzios again!", date_of_job: Date.new(2023,9,7) })

  puts "Seeding jobs applications"

  # There is a relationship between the job applications and the status of the jobs:
  # If a job has no applications, it will have the status open. As soon as one cleaner applies for a job
  # it will have the status applied. Many cleaners can apply for a job. As soon as a cleaner is accepted,
  # An accepted job can then be completed in the job_applications table by the cleaner who accepted the job.
  # A cleaner can reject an open job or a job he applied for, it will then no longer be visible in his overview.

  first_job_id = Job.first.id

# job1property1 has no applications and therefore has status open.

# job2property1 has 1 applications by Matt and has status applied. Matt needs to apply because he is not in the cleaning team.
  JobApplication.create!({ user: User.find_by(first_name: "Matt"), job: Job.find_by(description: "Please clean my Casa Serrana! again." ), status: "applied" })

# job3property1 was accepted by Pedro, Ben had applied but is now rejected from the job.
  JobApplication.create!({ user: User.find_by(first_name: "Pedro"), job: Job.find_by(description: "Please clean my Casa Serrana for the third time" ), status: "accepted" })
  JobApplication.create!({ user: User.find_by(first_name: "Ben"), job: Job.find_by(description: "Please clean my Casa Serrana for the third time" ), status: "rejected" })

  # job4property1 was completed by Ben
  JobApplication.create!({ user: User.find_by(first_name: "Ben"), job: Job.find_by(description: "Please clean my Casa Serrana for the forth time" ), status: "completed" })
  JobApplication.create!({ user: User.find_by(first_name: "Ben"), job: Job.find_by(description: "job5property1" ), status: "completed" })
  # job1property2 has two application by Pedro and Ben. They need to apply because they are not in the cleaning team.
  # The job was rejected by Matt
  JobApplication.create!({ user: User.find_by(first_name: "Pedro"), job: Job.find_by(description: "Please clean my Casa de Praia in Buzios!" ), status: "applied" })
  JobApplication.create!({ user: User.find_by(first_name: "Ben"), job: Job.find_by(description: "Please clean my Casa de Praia in Buzios!" ), status: "applied" })
  JobApplication.create!({ user: User.find_by(first_name: "Matt"), job: Job.find_by(description: "Please clean my Casa de Praia in Buzios!" ), status: "rejected" })

  #job2property2 was completed by Pedro, and rejected by Ben.
  JobApplication.create!({ user: User.find_by(first_name: "Pedro"), job: Job.find_by(description: "Please clean my Casa de Praia in Buzios again!" ), status: "completed" })
  JobApplication.create!({ user: User.find_by(first_name: "Ben"), job: Job.find_by(description: "Please clean my Casa de Praia in Buzios again!" ), status: "rejected" })

  puts "Seeding reviews"
  # The user_id in the reviews table is the id of user that wrote the id

  # job4property1 has a review by the manager about the cleaner
  # The cleaner is Ben in this case, can be linked through job_applications table: person with status completed for the job
  # Review.create!( {job: Job.find_by(description: "job4property1" ), user: User.find_by(first_name: "Humberto"), rating: 4, description: "Ben did a great job" })
  # job4property1 has a review by the cleaner about the property
  # Review.create!( {job: Job.find_by(description: "job4property1" ), user: User.find_by(first_name: "Ben"), rating: 3, description: "The property was very dirty" })

  # job2property2 has a review by the manager about the cleaner.
  # The cleaner is Pedro in this case, can be linked through job_applications table: person with status completed for the job

  # Review.create!( {job: Job.find_by(description: "job2property1" ), user: User.find_by(first_name: "Humberto"), rating: 2, description: "Pedro did a awful job" })

  puts "Completed seeds"
