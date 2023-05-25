 require 'rails_helper'

describe User do
  subject { described_class.new(name: "John Doe", cpf: "12355678900") }

    context "validations" do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:cpf) }
      it { should validate_uniqueness_of(:cpf).case_insensitive }
    end
 end

