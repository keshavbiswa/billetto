require 'rails_helper'

RSpec.describe "Votes", type: :request do
  let(:event_store) { Rails.application.config.event_store }
  let(:command_bus) { Rails.application.config.command_bus }
  let(:user_id) { "123" }
  let(:event) { Event.create!(title: "Test Event", billetto_id: 123, start_date: Time.current) }
  let(:valid_attributes) { { event_id: event.id, direction: 1 } }
  let(:invalid_attributes) { { hello: false } }


  describe 'POST /create' do
    context 'when user is not authenticated' do
      it 'does not create a vote' do
        expect do
          post event_votes_path(event), params: valid_attributes
        end.not_to change(Vote, :count)
      end

      it 'redirects to the root path' do
        post event_votes_path(event), params: valid_attributes
        expect(response).to redirect_to("/")
      end
    end
    context "when user is authenticated" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return({ "id" => user_id })
      end
      context 'with valid parameters' do
        it 'creates a new vote' do
          expect do
            post event_votes_path(event), params: valid_attributes
          end.to change(Vote, :count).by(1)
        end

        it 'publishes an EventUpvoted event' do
          expect do
            post event_votes_path(event), params: valid_attributes
          end.to publish(an_event(Voting::EventUpvoted)).in(event_store)
        end

        it 'redirects to the events list' do
          post event_votes_path(event), params: valid_attributes
          expect(response).to redirect_to(events_path)
        end

        it 'sets a success flash message' do
          post event_votes_path(event), params: valid_attributes
          expect(flash[:notice]).to eq('Vote recorded!')
        end
      end

      context 'when the user has already voted' do
        before do
          Vote.create(user_id: user_id, event_id: event.id, vote_flag: false)
        end

        it 'does not create a new vote' do
          expect do
            post event_votes_path(event, direction: 1), params: valid_attributes
          end.not_to change(Vote, :count)
        end

        it 'redirects to the events list' do
          post event_votes_path(event), params: valid_attributes
          expect(response).to redirect_to(events_path)
        end

        it 'sets an error flash message' do
          post event_votes_path(event), params: valid_attributes
          expect(flash[:alert]).to eq('You have already voted on this event.')
        end
      end
    end
  end
end
