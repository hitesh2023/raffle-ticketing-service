# README

# Used postgresql as a database
# Steps to run locally
 * git clone https://github.com/hitesh2023/raffle-ticketing-service.git
 * cd raffle-ticketing-service
 * bundle install 
 * rake db:create ( creates a database with name mentioned in database.yml )
 * rake db:migrate ( migrates all the tables & columns from db/migrate folder )
 * rails server -p 3000 ( start the server at port 3000 )
