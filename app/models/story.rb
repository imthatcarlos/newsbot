class Story < ApplicationRecord::Base
  
  validates_presence_of :title,
                        :substitle,
                        :image_url,
                        :url
                        :published_date,
                        :category

  scope :today,       -> { where(published_date: Date.today) }
  scope :of_category, -> (category) { where(category: category) }
  scope :top_today,   -> { today.order(:popularity).top(3) }
  scope :search,      -> (query) { today.where("title LIKE '%#{query}%' OR subtitle LIKE '%#{query}%'")  }
end