class User < ActiveRecord::Base
  validates_presence_of :login, :challenge, :response
  has_many :details, dependent: :destroy
end