class Post < ActiveRecord::Base

	validate :title, presence: true, length: {minimum: 5}
	validate :body, presence: true
	
end
