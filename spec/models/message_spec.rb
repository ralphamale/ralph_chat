require 'rails_helper'

RSpec.describe Message, type: :model do
	it { should validate_presence_of :content }
	it { should validate_presence_of(:conversation).with_message('Must exist') }
	it { should validate_presence_of(:author).with_message('Must exist') }
	
	it { should belong_to :conversation }
	it { should belong_to :author }
end
