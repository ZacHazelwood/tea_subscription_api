class Subscription < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :price
  validates_presence_of :status
  validates_presence_of :frequency

  enum status: { active: 0, cancelled: 1}
  enum frequency: { weekly: 0, monthly: 1, quarterly: 2}

  belongs_to :tea
  belongs_to :customer
end
