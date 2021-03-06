# Jonathan Lo
# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  body          :string(255)
#  creation_time :datetime
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#  channel_id    :integer
#

class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel
  belongs_to :topic
  validates :user_id, presence: true
  validates :body, presence: true
  validates :channel_id, presence: true

end
