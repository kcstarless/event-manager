require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
# Cleans up the zipcode.
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end
# Fetchs legislators by zipcode.
def legislators_by_zipcode(zipcode)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end
# Saves file for each attendees.
def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')
  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end
# Cleans up the phone number.
def clean_phone_number(phone)
  phone.gsub!(/[^0-9]/, '')
  if phone.size == 10
    phone
  else
    phone.size == 11 && phone[0] == '1' ? phone = phone[1..11] : phone = 'xxxxxxxxxx'
  end
  phone.insert(3, '-').insert(-5, '-')
end

def peak_reg_hours(reg_hour_count)
  peak_hour = reg_hour_count.select {|index, value| value == reg_hour_count.values.max}.keys
  return "Peak registeration hours: #{peak_hour.join(', ')} hours"
end

def peak_reg_days(reg_day_count)
  peak_day = reg_day_count.select {|index, value| value == reg_day_count.values.max}.keys.join('')
  return "Peak registeration day of week: #{Date::DAYNAMES[peak_day.to_i]}"
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)
# Loads template and creates instance of erb.
erb_template = ERB.new File.read('form_letter.erb')
# Hash for count of hours and days.
reg_hour_count = Hash.new(0)
reg_day_count = Hash.new(0)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phone = clean_phone_number(row[:homephone])
  legislators = legislators_by_zipcode(zipcode)
  # Binds variables known to template???
  form_letter = erb_template.result(binding)
  save_thank_you_letter(id, form_letter)
  # Reformats day & time and increase counter on each occurence
  reg_date_time = Time.strptime(row[:regdate], '%m/%d/%y %H:%M')
  reg_hour_count[reg_date_time.hour] += 1
  reg_day_count[reg_date_time.wday] += 1
end
puts "Attendees letters has been created."
puts peak_reg_hours(reg_hour_count)
puts peak_reg_days(reg_day_count)

### "event_manager finish!!!"
