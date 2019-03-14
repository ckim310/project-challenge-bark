# == Schema Information
#
# Table name: dogs
#
#  id            :integer          not null, primary key
#  name          :string
#  birthday      :datetime
#  adoption_date :datetime
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_id      :integer
#

class Dog < ApplicationRecord
  has_many_attached :images

  belongs_to :owner,
    foreign_key: :owner_id,
    class_name: :User,
    optional: true

  has_many :likes

  # gem 'order_as_specified' for active record to specify order
  extend OrderAsSpecified
end
