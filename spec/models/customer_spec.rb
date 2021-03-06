require 'rails_helper'

RSpec.describe Customer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "Relationships" do
    it {should have_many :invoices}
  end

  describe "Validations" do
    it {should validate_presence_of :first_name}
    it {should validate_presence_of :last_name}
  end
end
