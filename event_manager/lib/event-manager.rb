require 'csv'
require 'sunlight/congress'
require 'erb'
require 'date'

Sunlight::Congress.api_key = "a2da26bf7bbe4b6fb2aba897ae5bca56"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def clean_phone(phone_number)
  phone = phone_number.scan(/\d/).join
  if phone.length != 10
    if phone.length == 11 && phone[0] == "1"
      phone[0] = ''
    else
      phone = ''
    end
  end
  phone
end

def registration_hour(regdate)
  date = DateTime.parse(regdate)
  date.hour
end

def save_mobile_signups(phone_nums)
  filename = "mobile_signups.txt"

  File.open(filename, 'w') do |file|
    phone_nums.each {|num| file.puts num}
  end
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id, form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end


puts "EventManager Initialized"

contents = CSV.open "full_event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

phone_nums = []
hours = Hash.new(0)
days = Hash.new(0)

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letters(id, form_letter)

# Sanitize phone number & write to the alert signup file if valid
  phone = clean_phone(row[:homephone])
  phone_nums << phone unless phone.empty?

# Hour and day of registration
  regtime = DateTime.strptime(row[:regdate], '%m/%d/%y %H:%M')
  hours[regtime.strftime('%l %p')] += 1 
  days[regtime.strftime('%A')] += 1
end

save_mobile_signups(phone_nums)

peak_hour = hours.max_by{|hour, n| n }[0]
peak_day = days.max_by{|day, n| n}[0]

puts "Peak hour: #{peak_hour}"
puts "Peak day: #{peak_day}"