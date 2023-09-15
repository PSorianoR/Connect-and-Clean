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
"alicja@lewagon.com", "walid@lewagon.com", "caio@lewagon.com", "chloe@lewagon.com"]
first_names = ["Humberto", "Matt", "Ben", "Pedro", "Alicja", "Walid", "Caio", "Chloe"]
last_names = ["Pedra", "McGovern", "Van Dam", "Soriano", "Surzyn", "Daddy", "Pereira", "Bouillot"]
addresses = ["Rua Marize Barros, Tijuca, Rio De Janeiro, Brazil", "4523  Cedar Lane, Boston, Massachusetts, USA", "Carnotstraat 152, 2060 Antwerpen, Belgium", "1840  Eglinton Avenue, Toronto, Ontario, Canada",
"Jardines Del Country, Mascarones Street, Guadalajara, Mexico", "Haddock Lobo, Tijuca, Rio De Janeiro, Brazil", "Rua timoteo da costa, Leblon, Rio De Janeiro, Brazil", "conde de baependi 13, Laranjeiras, Rio De Janeiro, Brazil"]

user_photos = ["https://ca.slack-edge.com/T02NE0241-U05H2NBRFFY-2422604e0f19-512", "https://ca.slack-edge.com/T02NE0241-U05HJTYFZHP-e8affc977624-512","https://ca.slack-edge.com/T02NE0241-U05GUFPNAF9-29d236e53e03-512", "https://ca.slack-edge.com/T02NE0241-U05GAH9GN5D-d73433a0850a-512",
"https://ca.slack-edge.com/T02NE0241-U05FVLK1859-a09f85bddaf5-512","https://ca.slack-edge.com/T02NE0241-U05GFH6FBQ9-e055e36487f4-512", "https://ca.slack-edge.com/T02NE0241-U05H16LF2MU-89f529554cfd-512", "https://ca.slack-edge.com/T02NE0241-U03PWB0D79B-6937e37d4aeb-512" ]


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
  "alicja@lewagon.com": ["cleaner", "manager"],
  "walid@lewagon.com": ["cleaner"]
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

Property.create!({ title: "Casa Teresopolis", user: User.find_by(first_name: "Humberto"),
  address: "Alameda Arnaldo Guinle, 10, Teresopolis, Brazil", default_job_price: 75, default_cleaning_from: "11:00 AM", default_cleaning_until: "02:00 PM"})

Property.create!({ title: "Alicja's Crib on Rio", user: User.find_by(first_name: "Alicja"),
address: "Voluntarios da Patria 90, Botafogo, Rio de Janeiro, Brazil", default_job_price: 50, default_cleaning_from: "10:00 AM", default_cleaning_until: "12:00 PM"})

Property.create!({ title: "Casa Buzios", user: User.find_by(first_name: "Humberto"),
  address: "Rua das Pedras 10, Buzios, Rio de Janeiro, Brazil", default_job_price: 100, default_cleaning_from: "10:00 AM", default_cleaning_until: "12:00 PM"}
  )



  puts "Seeding teams..."

  # Creating managers for a property

    #First property only has the owner as manager (created by default when someone creates a property)
    Team.create!({ user: User.find_by(first_name: "Humberto"), property: Property.first, profession: "manager"})



    Team.create!({ user: User.find_by(first_name: "Alicja"), property: Property.find_by(title: "Alicja's Crib on Rio"), profession: "manager"})

    # Second property has three managers:
  Team.create!({ user: User.find_by(first_name: "Humberto"), property: Property.last, profession: "manager"})
  Team.create!({ user: User.find_by(first_name: "Matt"), property: Property.last, profession: "manager"})
  # Team.create!({ user: User.find_by(first_name: "Pedro"), property: Property.last, profession: "manager" } )




  # Creating cleaners for a property

  # first property has two cleaners:
  Team.create!({ user: User.find_by(first_name: "Alicja"), property: Property.first, profession: "cleaner" })
  Team.create!({ user: User.find_by(first_name: "Caio"), property: Property.first, profession: "cleaner" })

  # Second property has one cleaner
  Team.create!({ user: User.find_by(first_name: "Walid"), property: Property.last, profession: "cleaner" })
  Team.create!({ user: User.find_by(first_name: "Ben"), property: Property.last, profession: "cleaner" })

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
  # puts "Creating Last seedings"


  cleaning_jobs_description = [
    "Thoroughly clean and sanitize a small apartment, including kitchen and bathroom.",
    "Deep clean a large house with multiple rooms, focusing on dusting and vacuuming.",
    "Weekly maintenance cleaning for an office space, ensuring a tidy work environment.",
    "Spring cleaning for a suburban home, including window washing and carpet cleaning.",
    "Clean and organize a cluttered garage, removing dust, and organizing tools.",
    "Post-construction cleanup for a newly renovated office building.",
    "Move-in cleaning for a family relocating to a new home, preparing it for occupancy.",
    "Clean and disinfect a daycare facility to ensure a safe environment for children.",
    "Special event cleanup for a wedding venue, restoring it to its pristine state.",
    "Apartment turnover cleaning between tenants, including appliance cleaning.",
    "Janitorial services for a commercial building, maintaining cleanliness and hygiene.",
    "Window cleaning for a high-rise condominium, both interior and exterior surfaces.",
    "Carpet and upholstery cleaning for a restaurant, removing stains and odors.",
    "Gutter cleaning for a residential property, preventing water damage.",
    "Emergency cleanup after a water leak, including drying and dehumidifying.",
    "Industrial facility cleaning, maintaining a safe and sanitary workspace.",
    "Clean and polish hardwood floors in a historic home, restoring their luster.",
    "Estate cleaning for a property preparing for sale, enhancing curb appeal.",
    "Vacation rental turnover cleaning, ensuring a welcoming experience for guests.",
    "Biohazard cleanup, safely disposing of hazardous materials and sanitizing.",
    "RV interior cleaning for a road trip, making it comfortable for travel.",
    "Mold remediation and removal in a basement, ensuring a healthy environment.",
    "Post-event cleanup for a large outdoor festival, removing trash and debris.",
    "Exterior power washing for a commercial building, rejuvenating its appearance.",
    "Restaurant kitchen cleaning, maintaining hygiene and food safety standards.",
    "Clean and organize a storage unit, optimizing space and accessibility.",
    "Aircraft interior cleaning, ensuring a pristine environment for passengers.",
    "Pressure washing a driveway and walkway, removing dirt and stains.",
    "Hotel room turnover cleaning, providing a clean and comfortable stay for guests.",
  ]

  house_cleaning_job_descriptions_2 = [
    "Deep clean a cozy cottage with antique furnishings.",
    "Weekly maintenance cleaning for a family home with kids.",
    "Thorough spring cleaning for a suburban house with a garden.",
    "Post-party cleanup, restoring order to a lively home.",
    "Clean and sanitize a pet-friendly house, removing fur and odors.",
    "Apartment turnover cleaning, preparing it for new tenants.",
    "Declutter and organize a cluttered home office space.",
    "Window washing for a two-story house, inside and out.",
    "Green cleaning for an eco-conscious household, using eco-friendly products.",
    "Detailed kitchen and bathroom cleaning, focusing on high traffic areas.",
    "Emergency water damage cleanup, restoring a waterlogged basement.",
    "Garage cleaning and organization, optimizing storage space.",
    "Mold removal and prevention in a damp basement.",
    "Pre-holiday home cleaning, ready for festive gatherings.",
    "Pantry and fridge cleaning, ensuring a well-organized kitchen.",
    "Post-renovation house cleaning, eliminating construction dust.",
    "Home gym sanitization, promoting a healthy workout environment.",
    "Deep carpet cleaning for a living room, removing stains and allergens.",
    "Thorough bedroom cleaning, including dusting and vacuuming.",
    "Backyard patio power washing, refreshing outdoor living spaces.",
    "Children's playroom cleaning, making it safe and tidy.",
    "Post-move-in house cleaning, creating a fresh start for homeowners.",
    "Declutter and organize a walk-in closet, maximizing storage.",
    "Exterior house pressure washing, revitalizing curb appeal.",
    "Pet hair removal from furniture and upholstery.",
    "Clean and disinfect a bathroom, ensuring hygiene.",
    "Laundry room organization and cleaning, improving functionality.",
    "Post-summer vacation home cleanup, restoring order.",
    "Home library dusting and bookshelf organization.",
    "Thorough dining room cleaning, ready for family dinners.",
    "Deep cleaning of a spacious open-concept living area."
  ]

  house_cleaning_job_descriptions_3 = [
    "Monthly home cleaning service, maintaining a tidy environment.",
    "Post-holiday cleanup, packing away decorations and cleaning.",
    "Interior window cleaning for a sunlit living room.",
    "Thorough attic organization and cleaning, reclaiming storage space.",
    "Clean and sanitize a bathroom, including tile and grout.",
    "Declutter and organize a home office, boosting productivity.",
    "Pantry restocking and cleaning, ensuring a well-stocked kitchen.",
    "Deep cleaning for a home with allergies, targeting dust and allergens.",
    "Post-construction house cleanup, removing debris and dust.",
    "Exterior patio furniture cleaning, ready for outdoor gatherings.",
    "Basement flood cleanup and restoration, salvaging valuables.",
    "Bi-weekly house cleaning, maintaining a fresh and inviting home.",
    "Home theater cleaning, ensuring a pristine viewing experience.",
    "Post-spring cleaning organization, decluttering and tidying.",
    "Window washing for a historic home with ornate windows.",
    "Clean and sanitize a nursery, creating a safe space for a baby.",
    "Deep kitchen appliance cleaning, including oven and refrigerator.",
    "Thorough garage floor scrubbing and oil stain removal.",
    "Post-summer vacation home organization, packing away beach gear.",
    "Bathroom cabinet and vanity cleaning, tidying personal care items.",
    "Living room upholstery cleaning for a family-friendly home.",
    "Bi-monthly bedroom cleaning, ensuring a restful sleep environment.",
    "Post-muddy paws cleanup, restoring a clean entryway.",
    "Home gym equipment sanitization, promoting health and wellness.",
    "Children's bedroom organization and toy cleanup.",
    "Deep cleaning of a home gym, disinfecting exercise equipment.",
    "Thorough hallway and corridor cleaning, including baseboards.",
    "Post-winter home organization, storing winter gear and clothing.",
    "Dining room table and chair cleaning, ready for family meals.",
    "Clean and disinfect a laundry room, improving functionality.",
    "Front porch and entryway power washing, enhancing curb appeal."
  ]

  cleaning_job_reviews = [
    "Excellent service, spotless home!",
    "Thorough and efficient cleaning, highly recommend.",
    "The cleaner did a fantastic job, very satisfied.",
    "Impressive attention to detail, our place looks great.",
    "Dependable cleaner, always leaves our home sparkling.",
    "Outstanding cleaning service, exceeded expectations.",
    "Fast and thorough, our house is clean and fresh.",
    "Reliable and meticulous cleaner, very impressed.",
    "Top-notch service, our home has never looked better.",
    "Great job, our place is pristine. Thank you!",
    "Cleaning genius! Our home is immaculate.",
    "Effortless scheduling, superb results every time.",
    "Exceptional cleaner, transformed chaos into order.",
    "Pristine and efficient, our space feels brand new.",
    "Professional and reliable cleaner, highly recommended.",
    "Impressed with the cleaner's attention to detail.",
    "Cleaning magician! Our home is a delight.",
    "Dependable service, always trustworthy and thorough.",
    "Excellent cleaning, our home gleams with freshness.",
    "Cleans with precision, our house is spotless.",
    "Outstanding job! Our place looks amazing!",
    "Efficient and friendly cleaner, consistently top-notch results.",
    "Fast and thorough cleaning, exceeded our expectations.",
    "Reliable and efficient, our home is clean and inviting.",
    "Exceptional service, transformed our space into a sanctuary.",
    "Great work! Our home has never been cleaner.",
    "Professional cleaner, our house is now spotless.",
    "Dependable and efficient, highly recommend this cleaner.",
    "Cleaning magician! Our place has never looked better.",
    "Fast, reliable, and thorough. We're delighted with the results."
  ]

  cleaning_job_reviews_3_out_of_5 = [
    "Decent service, but some areas were missed during cleaning.",
    "Average job, improvements needed in attention to detail.",
    "Satisfactory cleaning, met basic expectations.",
    "Fair effort, but could have been more thorough.",
    "Adequate cleaning, minor issues overlooked.",
    "Middling performance, improvements required for next time.",
    "So-so job, a few spots were left untouched.",
    "Acceptable service, but room for improvement in cleanliness.",
    "Average cleaning, not outstanding but not terrible either.",
    "Mediocre job, expected a bit more for the price.",
    "Basic cleaning, some areas still needed attention afterward.",
    "Not exceptional, but got the job done to a certain extent.",
    "Just okay, might consider alternatives next time.",
    "A bit underwhelming, missed a few key areas.",
    "Room for improvement, service was just average.",
    "It was okay, but not quite up to par with previous experiences.",
    "Sufficient job, but nothing to write home about.",
    "Decent cleaning, but didn't meet all expectations.",
    "A passable job, though not without some minor issues.",
    "Adequate service, but lacked the wow factor.",
    "Fair cleaning, improvements needed for next time.",
    "Met the bare minimum, but not much more.",
    "Mediocre service, could have been more thorough.",
    "Just average, nothing particularly impressive.",
    "Satisfactory cleaning, but nothing to rave about.",
    "An okay job, but didn't exceed expectations.",
    "Average service, felt it could have been better.",
    "Decent effort, but room for improvement in attention to detail.",
    "Middle of the road, neither great nor terrible.",
    "Acceptable cleaning, met basic standards."
  ]

  cleaning_job_reviews_1_and_2_out_of_5 = [
    "Terrible service, left a mess behind. Avoid this cleaner.",
    "Awful job, didn't clean properly. Highly disappointed.",
    "Worst cleaning ever, nothing was done right. Total waste.",
    "Dreadful experience, don't hire them. Very unsatisfied.",
    "Unprofessional and sloppy work, regretting this choice.",
    "Disastrous cleaning, didn't meet basic standards. A disaster.",
    "Incompetent cleaner, made everything worse. Do not recommend.",
    "Horrible job, didn't follow instructions. Huge disappointment.",
    "Regret hiring them, left things dirty. Terrible experience.",
    "Miserable cleaning, wouldn't hire again. Very dissatisfied.",
    "Disgusting results, a complete letdown. Avoid this service.",
    "Displeased with the outcome, wasted time and money.",
    "Extremely disappointing, a waste of resources. Unacceptable work.",
    "Appalling service, no attention to detail. Never again.",
    "Failed to clean properly, very dissatisfied with their work.",
    "Absolutely awful, ruined the cleanliness. Total disaster.",
    "Pathetic cleaning, failed to deliver. A total letdown.",
    "Frustrating experience, wouldn't recommend to anyone.",
    "Shoddy work, didn't meet expectations. Very unsatisfied.",
    "Sloppy cleaning, didn't complete the job. A big disappointment.",
    "Unsatisfactory service, left things dirty. Disappointed and frustrated.",
    "Abysmal job, left us with more work. Avoid at all costs.",
    "Unimpressed with their cleaning, won't hire again.",
    "Miserable experience, cleaning was subpar. Not worth it.",
    "Horrific cleaning, didn't even try. Avoid this cleaner.",
    "Very disappointing, cleanliness was far from satisfactory.",
    "Shameful results, didn't meet basic standards. Unreliable service.",
    "Inept cleaner, ruined our day. Never hiring again.",
    "Absolutely regretful choice, left our space dirty. Total failure.",
    "Failed to clean properly, unacceptable service. Avoid this company."
  ]

rating_array = [4,5]
rating_avarage_array = [2,3,4]
rating_poor_array = [1,2]

count = 0
# walid seeding
  30.times do
    Job.create!({ property: Property.first, price: 75, status: "completed", user: User.find_by(first_name: "Humberto"), description: cleaning_jobs_description[count], date_of_job: Date.new(2023,9,1) })
    JobApplication.create!({ user: User.find_by(first_name: "Walid"), job: Job.find_by(description: cleaning_jobs_description[count] ), status: "completed" })
    Review.create!( { job: Job.find_by(description: cleaning_jobs_description[count] ), user: User.find_by(first_name: "Humberto"), rating: rating_array.sample, description: cleaning_job_reviews[count] })
    count += 1
  end

  30.times do
    Job.create!({ property: Property.first, price: 75, status: "completed", user: User.find_by(first_name: "Humberto"), description: house_cleaning_job_descriptions_3[count], date_of_job: Date.new(2023,9,2) })
    JobApplication.create!({ user: User.find_by(first_name: "Matt"), job: Job.find_by(description: house_cleaning_job_descriptions_3[count] ), status: "completed" })
    Review.create!( { job: Job.find_by(description: house_cleaning_job_descriptions_3[count] ), user: User.find_by(first_name: "Humberto"), rating: rating_avarage_array.sample, description: cleaning_job_reviews_3_out_of_5[count] })
    count += 1
  end

  30.times do
    Job.create!({ property: Property.first, price: 75, status: "completed", user: User.find_by(first_name: "Humberto"), description: house_cleaning_job_descriptions_2[count], date_of_job: Date.new(2023,9,3) })
    JobApplication.create!({ user: User.find_by(first_name: "Alicja"), job: Job.find_by(description: house_cleaning_job_descriptions_2[count] ), status: "completed" })
    Review.create!( { job: Job.find_by(description: house_cleaning_job_descriptions_2[count] ), user: User.find_by(first_name: "Humberto"), rating: rating_poor_array.sample, description: cleaning_job_reviews_1_and_2_out_of_5[count] })
    count += 1
  end


  #

  puts "Humberto seeds"

  # Job.create!({ property: Property.first, price: 75, status: "completed", user: User.find_by(first_name: "Humberto"), description: "Please clean my kitchen and my liveroom!", date_of_job: Date.new(2023,9,1) })
  # JobApplication.create!({ user: User.find_by(first_name: "Alicja"), job: Job.find_by(description: "Please clean my kitchen and my liveroom!" ), status: "completed" })
  # Job.create!({ property: Property.first, price: 75, status: "completed", user: User.find_by(first_name: "Humberto"), description: "Just clean my livingroom and bedroom", date_of_job: Date.new(2023,9,3) })
  # JobApplication.create!({ user: User.find_by(first_name: "Caio"), job: Job.find_by(description: "Just clean my livingroom and bedroom" ), status: "completed" })
  # Job.create!({ property: Property.last, price: 100, status: "completed", user: User.find_by(first_name: "Humberto"), description: "Please my balcony needs a sweeping and my pool needs to be ready too", date_of_job: Date.new(2023,9,5) })
  # JobApplication.create!({ user: User.find_by(first_name: "Walid"), job: Job.find_by(description: "Please my balcony needs a sweeping and my pool needs to be ready too" ), status: "completed" })
  # Job.create!({ property: Property.last, price: 100, status: "completed", user: User.find_by(first_name: "Humberto"), description: "Someone blew up my toilet. Need some help ASAP", date_of_job: Date.new(2023,9,7) })
  # JobApplication.create!({ user: User.find_by(first_name: "Ben"), job: Job.find_by(description: "Someone blew up my toilet. Need some help ASAP" ), status: "completed" })
  # Job.create!({ property: Property.first, price: 75, status: "accepted", user: User.find_by(first_name: "Humberto"), description: "Help me cleaning up my mess from my party this weekend", date_of_job: Date.new(2023,9,18) })
  # JobApplication.create!({ user: User.find_by(first_name: "Caio"), job: Job.find_by(description: "Help me cleaning up my mess from my party this weekend" ), status: "accepted" })
  # Job.create!({ property: Property.last, price: 100, status: "accepted", user: User.find_by(first_name: "Humberto"), description: "Don't need a cleaning just company, I feel so alone :/", date_of_job: Date.new(2023,9,19) })
  # JobApplication.create!({ user: User.find_by(first_name: "Walid"), job: Job.find_by(description: "Don't need a cleaning just company, I feel so alone :/" ), status: "accepted" })
  # # 15 reviews of walid with 4.0 rating

  # # Job
  # Job.create!({ property: Property.first, price: 75, status: "completed", user: User.find_by(first_name: "Humberto"), description: "Clean the living room, washrooms and kitchen. water the plants.ONE", date_of_job: Date.new(2023,9,1) })
  # JobApplication.create!({ user: User.find_by(first_name: "Walid"), job: Job.find_by(description: "Clean the living room, washrooms and kitchen. water the plants.ONE" ), status: "completed" })


  puts "Completed seeds"
