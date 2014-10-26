class Detail < ActiveRecord::Base
  validates_presence_of :site, :data
  belongs_to :user
end