class Note < ActiveRecord::Base
  belongs_to :user
  validates :title, presence: true, length: { maximum: 200 }
end
