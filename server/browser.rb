require 'socket'
require 'json'

def post_request
  response = Hash.new
  viking = Hash.new
  puts "Name: "
  viking[:name] = gets.chomp
  puts "Email: "
  viking[:email] = gets.chomp
  response[:viking] = viking
  request_body = response.to_json
  newline = "\r\n"
  request = "POST /thanks.html HTTP/1.0" + newline + "From: " + viking[:email] + newline + "Content-Length: " + request_body.length.to_s + newline + newline + request_body

  return request
end

def get_request
  path = "/index.htm"

  request = "GET #{path} HTTP/1.0\r\n\r\n"
  return request
end

print "Do you want to post or get? p/g: "
input = gets.chomp.chr

request = case input
  when "p" then post_request
  when "g" then get_request
end

host = 'localhost'
port = 2000

puts request 

socket = TCPSocket.open(host,port)
socket.print(request)
response = socket.read

headers,body = response.split("\r\n\r\n", 2)
header_parts = headers.split(" ")
if header_parts[1] == "404"
  print "File not found"
elsif header_parts[1] == "200"
  print body
else
  print response
end