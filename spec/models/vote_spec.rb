require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:event) { Event.create(title: "Event 1", start_date: Time.now, billetto_id: "123") }

  describe "Validations" do
    context "when user_id is not present" do
      subject { described_class.new(vote_flag: true, event_id: event.id) }

      it { is_expected.not_to be_valid }
    end
    context "when user_id is present" do
      subject { described_class.new(vote_flag: true, user_id: "123", event_id: event.id) }

      it { is_expected.to be_valid }
    end

    context "when vote_flag is not present" do
      subject { described_class.new(user_id: "123", event_id: event.id) }

      it { is_expected.not_to be_valid }
    end

    context "when vote_flag is present" do
      subject { described_class.new(vote_flag: true, user_id: "123", event_id: event.id) }

      it { is_expected.to be_valid }
    end


    context "user_id exists" do
      before { Vote.create(event_id: event.id, vote_flag: true, user_id: "123") }
      subject { described_class.new(event_id: event.id, vote_flag: true, user_id: "123") }

      it "raises uniqueness validation errors" do
        is_expected.not_to be_valid
        expect(subject.errors[:user_id]).to eq [ 'has already voted on this event' ]
      end
    end
  end


  describe "Counter Caches" do
    context "when upvoted" do
      it "increases upvotes count by one" do
        expect { Vote.create(event_id: event.id, vote_flag: true, user_id: "123"); event.reload }.to change { event.upvotes_count }.by(1)
      end
    end
    context "when downvoted" do
      it "increases downvotes count by one" do
        expect { Vote.create(event_id: event.id, vote_flag: false, user_id: "123"); event.reload }.to change { event.downvotes_count }.by(1)
      end
    end
  end
end
