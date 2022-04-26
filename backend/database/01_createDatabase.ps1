Get-Content config.txt | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1]
}

$dburl="postgresql://$($User):$($Password)@$($Server):$($Port)/$($Database)"

# SCHEMA

psql -f schema.sql $dburl

# SEED

psql -c "INSERT INTO Users (username, password) VALUES ('example', 'password');" $dburl

$data = "SELECT userID FROM Users WHERE username = 'example'" | psql --csv $dburl | ConvertFrom-Csv
$userID = $data.userID

psql -c "INSERT INTO About (name, title, about, userID) VALUES ('John Doe', 'Job Title', NULL, '$($userID)');" $dburl

psql -c "INSERT INTO Projects (title, type, description, userID) VALUES ('Project Example', 'Example', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam egestas nunc ligula, a rutrum orci vulputate pharetra. Donec sit amet convallis eros. Cras consectetur et tortor eu ullamcorper. Praesent a dapibus odio. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec quis nisl ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut vestibulum orci ut leo finibus placerat.
Maecenas vitae est eu est fermentum malesuada id vitae magna. Quisque pellentesque ullamcorper feugiat. Nullam in ultricies risus. Integer venenatis ante non condimentum hendrerit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Morbi id dui ac magna feugiat vulputate a sed justo. Vestibulum posuere velit est, at volutpat orci cursus ut.
Vivamus fringilla nibh et sagittis sagittis. Duis eget mauris at nibh rutrum fringilla feugiat vel augue. Pellentesque finibus, diam et pulvinar tempus, lorem ipsum sodales sapien, eget dictum neque leo eu enim. Sed luctus dui massa, at tempus dolor mollis et. Etiam non euismod mi, non venenatis urna. Aliquam erat volutpat. Fusce faucibus lacus a eros ornare aliquet. Duis in elit vitae dui viverra consectetur. Cras vel tortor a lectus sollicitudin tempor vel vel nisi. Ut ipsum ex, iaculis sed.', '$($userID)');" $dburl

$data = "SELECT projectID FROM Projects" | psql --csv $dburl | ConvertFrom-Csv
$projectID = $data.projectID

psql -c "INSERT INTO ProjectLinks (text, link, projectID) VALUES ('Link', 'https://www.lipsum.com/', '$($projectID)');
    INSERT INTO Education (diploma, school, startDate, endDate, userID) VALUES ('High School Degree', 'High School X', '2016-08-01', '2021-05-31', '$($userID)');
    INSERT INTO Awards (name, date, description, userID) VALUES ('Award Name', '2018-06-16', 'Award for the best grades.', '$($userID)');" $dburl

$data = "SELECT awardID FROM Awards" | psql --csv $dburl | ConvertFrom-Csv
$awardID = $data.awardID

psql -c "INSERT INTO AwardLinks (text, link, awardID) VALUES ('Link', 'https://www.google.com/', '$($awardID)');
    INSERT INTO SkillSections (name, userID) VALUES ('Other', '$($userID)');" $dburl

$data = "SELECT skillSectionID FROM SkillSections" | psql --csv $dburl | ConvertFrom-Csv
$skillSectionID = $data.skillSectionID

psql -c "INSERT INTO Skills (name, level, skillSectionID, userID) VALUES ('Skill 1', 'Beginner', '$($skillSectionID)', '$($userID)');
    INSERT INTO Skills (name, level, skillSectionID, userID) VALUES ('Skill 2', 'Skilled', NULL, '$($userID)');
    INSERT INTO Experience (organization, jobTitle, startDate, endDate, description, userID) VALUES ('Organization Name', 'Job Title', '2022-02-15', NULL, '- Task X \n - Task Y', '$($userID)');
    INSERT INTO Media (mediaType, text, link, userID) VALUES ('LinkedIn', 'LinkedIn', 'https://ca.linkedin.com/', '$($userID)');" $dburl
