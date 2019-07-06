# Reward System Coding Challenge

After reading the problem, the data structure which was apparent was **Tree** as the system resembled like a pyramid scheme and customer recommended by other is his/her can be taken as child node.

So, I first created tree structure using tree and node models. Also, I created a system node to attach all those customers who are initial ones and not recommended by anyone.

After testing with dummy data in the form which tree will accept, I created a controller to accept file as a webservice and process to form the data which can be passed to the tree.

Then I added validations for the file data and fixed some issues.

Following are the instruction was installation and testing.

### Install:
 - `git clone https://github.com/nikhilgoyal22/RewardSystem.git`
 - `cd RewardSystem/`
 - `bundle install`

### Run:
 - `rails s`
 - `curl -X POST localhost:3000/rewards -F "file=@test_file.txt" -H "Content-Type: multipart/form-data"`
 - Or you can use Postman
