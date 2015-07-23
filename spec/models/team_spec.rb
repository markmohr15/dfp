# == Schema Information
#
# Table name: teams
#
#  id                 :integer          not null, primary key
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  fd_park_factor     :float
#  park_factor        :float
#  base_runs_per_nine :float
#  runs_per_nine      :float
#  games              :integer
#  alias              :string
#  dk_park_factor     :float
#

require 'rails_helper'

RSpec.describe Team, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
