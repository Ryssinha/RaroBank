 require 'rails_helper'

describe Classroom do
  subject { create(:classroom) }

    context "validations" do
      it { should validate_presence_of(:name) }
    end
 end
