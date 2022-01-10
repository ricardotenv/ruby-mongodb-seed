require 'optparse'
require 'dotenv'
require 'faker'
require 'json'

Dotenv.load('.env')

def seed(count)
    payload = []
    (1..count).each do
        payload.append({:name => Faker::Name.name, :email => Faker::Internet.email})
    end

    payload

end

options = {}

option_parser = OptionParser.new do |opts|
    opts.on '-c', '--count=COUNT', Integer, 'Set the quantity of documents'
end

option_parser.parse!(into: options)

count = options[:count]

documents = seed(count)
File.write("documents.json", documents.to_json, mode: "w")

`mongoimport --uri #{ENV['MONGO_URI']} --collection #{ENV['MONGO_COLLECTION']} --jsonArray documents.json`