# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  dog_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :dog
end
