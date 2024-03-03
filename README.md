# Ruby: event-manager

## 1. Description
This program finds government local government representatives using google civic information web service API by looking at the registration list and their information. Using the data collected it manupliates the data to extracts requried information.

## 2. Usage
- Download sample data from Github `event_attendees.csv`.
    - [Small sample](https://raw.githubusercontent.com/TheOdinProject/curriculum/main/ruby/files_and_serialization/event_attendees.csv)
    - [Large sample](https://raw.githubusercontent.com/TheOdinProject/curriculum/main/ruby/files_and_serialization/event_attendees_full.csv)

- Install google api client, on your terminal type in following script `gem install google-api-client`.

- Run the command `ruby lib/event_manager.rb`

## 3. Functionality
Program utlizes different libraries like `csv`, `erb` and `google/apis/civicinfo_v2` to complete task given on the project.  

- `csv`, to read into the sample data `event_attendees.csv`.
- `google/apis/civicinfo_v2`, to access civic information for any U.S address which is in `JSON`. 
- `erb`, to create a HTML template for sending out letters. 

1. Program first attempts to clean up the zipcode in `event_attendees.csv` in order to make data consistent. 
2. Based on the attendees zipcode it will fetch representatives names for each level of government. 
3. Create templates to send out letters to each attendees of the conference with corresponding names of local representatives. This is done using `erb` and each letter will be saved to `output/`.
4. Cleans up phone number data in `event_attendees.csv` to make it consistent.
5. Using `Time` class prints out hours where most registration took place 
6. Using `Time`class prints out day of week where most registration took place.

## 4. Thoughts on the project
Erb completely new concept I learned through this project. I am still unsure how `binding` passes in the variables to erb.

