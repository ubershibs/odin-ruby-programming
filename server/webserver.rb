require 'socket'
require 'json'

def is_http?(request)
  request_parts = request.split(" ")
  if request_parts[2] =~ /HTTP\/(1.0|1.1)/
    return true
  else
    return false
  end
end

def process_request(request)
  request_parts = request.split(" ")
  response = case request_parts[0].upcase
    when "GET" then serve_file(request_parts[1], request_parts[2])
    when "POST" then process_post(request)
    else
    "invalid request"
  end
  return response 
end

def serve_file(path, type)
  path = path[1..-1]
  puts "GET request for #{path}"
  if File.exist?(path)
    content = File.read(path)
    status_line = type + " 200 OK"
    date = "Date: " + Time.now.to_s
    content_type = "Content-Type: text/html"
    content_length = "Content-Length: " + content.length.to_s
  else
    status_line = type + " 404 Not Found"
    puts "path does not exist"
  end
  response = status_line + "\r\n" + date + "\r\n" + content_type + "\r\n" + content_length + "\r\n\r\n" + content
  return response
end

def process_post(request)
  request_parts = request.split("\r\n\r\n")
  params = {}
  params = JSON.parse(request_parts[1])

  header = request_parts[0].split(" ")
  path = header[1]

  type = header[2]

  if File.exist?(path[1..-1])
    status_line = type + " 200 OK"
    date = "Date: " + Time.now.to_s
    content_type = "Content-Type: text/html"
    response_body = process_script(path, params)
    content_length = "Content-Length: " + response_body.length.to_s
    newline = "\r\n"
    response = status_line + newline + date + newline + content_type + newline + content_length + newline + newline + response_body 
  else
    response = type + " 404 Not Found"  
  end
  puts response
  return response

end

def process_script(path, params)
  path = path[1..-1]
  user = params["viking"]
  puts user
  contents = File.read(path)
  new_content = "<li>Name: #{user["name"]}</li>\r\n<li>Email: #{user["email"]}</li>"
  response = contents.gsub("<%= yield %>", new_content)
  return response
end

server = TCPServer.open(2000)
loop {
  Thread.start(server.accept) do |client|
    request = client.recv(1000)
    if is_http?(request)
      response = process_request(request)
    else
      response = "Not a valid HTTP request."
    end
    client.puts response
    client.close
  end
}