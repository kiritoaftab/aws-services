require 'aws-sdk-s3'
require 'pry'
require 'securerandom'

bucket_name = ENV['BUCKET']
region = 'ap-south-1'

client = Aws::S3::Client.new(region: region)
resp = client.create_bucket({
  bucket: bucket_name, 
  create_bucket_configuration: {
    location_constraint: region, 
  } 
})
#binding.pry

no_of_files = 1 + rand(6)
puts "Number of files : #{no_of_files}"

no_of_files.times.each do |i|
    puts "i: #{i}"
    filename = "file_#{i}.txt"
    output_path = "/tmp/#{filename}"

    File.open(output_path,'w') do |f|
        f.write(SecureRandom.hex(10))
    end

    client.put_object({
        bucket: bucket_name,
        key: filename,
        body: File.open(output_path, 'rb')
    })
end
