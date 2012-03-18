# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
#  puts page.body
#  puts page.has_content?(e1)
#  save_and_open_page
  if page.has_content?(e1) && page.has_content?(e2)
    assert page.body.index(e1) < page.body.index(e2)
  else
    assert false, "Content missing: #{e1}, #{e2}"
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  end
end

When /^(?:|I )check the "([^"]*)" rating$/ do |field|
  check('ratings_' + field)
end

When /^(?:|I )uncheck the "([^"]*)" rating$/ do |field|
  uncheck('ratings_' + field)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, ratings|
  ratings.split(',').each do |rating|
    if uncheck
      When  %Q{I uncheck the "#{rating.strip}" rating}
    else
      When  %Q{I check the "#{rating.strip}" rating}
    end
  end
end

Then /I should see all of the movies/ do 
  #puts page.body
  #save_and_open_page
  rows = page.all(:xpath, "//table[@id='movies']/tbody/tr").size
  assert_equal Movie.count, rows
end

Then /I should see none of the movies/ do 
  rows = page.all(:xpath, "//table[@id='movies']/tbody/tr").size
  assert_equal 0, rows
end
