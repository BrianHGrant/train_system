require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')
require('./lib/train')
require('./lib/city')
require('./lib/stop')
require('pg')

DB = PG.connect({:dbname => 'train_system_test'})

get('/') do
  erb(:index)
end

get('/admin') do
  @cities = City.all()
  @trains = Train.all()
  erb(:admin)
end

get('/trains/new') do
  erb(:train_form)
end

get('/cities/new') do
  erb(:city_form)
end

post('/add_train') do
  name = params.fetch("name")
  new_train = Train.new(:name => name, :id => nil)
  new_train.save()
  @trains = Train.all()
  @cities = City.all()
  erb(:admin)
end

post('/add_city') do
  name = params.fetch('name')
  new_city = City.new(:name => name, :id => nil)
  new_city.save()
  @cities = City.all()
  @trains = Train.all()
  erb(:admin)
end

get('/trains/:id/edit') do
  @train = Train.find(params.fetch('id').to_i())
  erb(:train_edit)
end

get('/cities/:id/edit') do
  @city = City.find(params.fetch('id').to_i())
  erb(:city_edit)
end

patch('/trains/:id') do
  name = params.fetch('name')
  @train = Train.find(params.fetch("id").to_i())
  @train.update({:name => name})
  @trains = Train.all()
  @cities = City.all()
  erb(:admin)
end

patch('/cities/:id') do
  name = params.fetch('name')
  @city = City.find(params.fetch("id").to_i())
  @city.update({:name => name})
  @trains = Train.all()
  @cities = City.all()
  erb(:admin)
end

delete('/trains/:id') do
  @train = Train.find(params.fetch("id").to_i())
  @train.remove()
  @trains = Train.all()
  @cities = City.all()
  erb(:admin)
end

delete('/cities/:id') do
  @city = City.find(params.fetch("id").to_i())
  @city.remove()
  @trains = Train.all()
  @cities = City.all()
  erb(:admin)
end
