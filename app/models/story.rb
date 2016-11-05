class Story < ActiveRecord::Base
  
  validates_presence_of :title,
                        :substitle,
                        :image_url,
                        :url

  scope :today,       -> { where(published_date: Date.today) }
  scope :of_category, -> (category) { where(category: category) }
  scope :popular,     -> { today.order(:popularity).top(5) }
  scope :search,      -> (query) { today.where("title LIKE '%#{query}%' OR subtitle LIKE '%#{query}%'")  }
end