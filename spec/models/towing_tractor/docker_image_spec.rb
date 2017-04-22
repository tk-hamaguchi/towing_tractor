require 'rails_helper'

module TowingTractor
  RSpec.describe DockerImage, type: :model do
    subject { FactoryGirl.build(:docker_image) }
    context '#to_json' do
      subject { super().to_json }

      it 'should eq valid JSON format' do
        expect{JSON.parse(subject)}.to_not raise_error
      end
      context 'parsed' do
        subject { JSON.parse(super()) }
        it { is_expected.to have_key('id') }
        it { is_expected.to have_key('name') }
        it { is_expected.to have_key('image') }
        it { is_expected.to have_key('created_at') }
        it { is_expected.to have_key('updated_at') }
      end
    end

    context ':name' do
      it { is_expected.to validate_presence_of(:name) }
    end

    context ':image' do
      it { is_expected.to validate_presence_of(:image) }
      it { is_expected.to validate_uniqueness_of(:image) }
    end
  end
end
