require 'rails_helper'

RSpec.describe BillettoAPI do
  let(:api_key) { 'test_api_key' }
  let(:api_secret) { 'test_api_secret' }
  let(:base_uri) {  'https://billetto.dk/api/v3' }
  let(:api_keypair) { "#{api_key}:#{api_secret}" }
  let(:sample_response) { { data: [ { id: '1', title: 'Event 1' } ] } }
  let(:sample_error_response) { { "error": { "message": "Invalid credentials", "type": "authentication_error" } } }

  subject { described_class.new(api_secret, api_key) }

  describe "#get_public_events" do
    subject { described_class.new(api_key, api_secret).get_public_events }

    context "when request is successful" do
      before do
        stub_request(:get, "#{base_uri}/public/events")
          .with(query: { page: '1', limit: '20' }, headers: { 'Accept' => 'application/json', 'Api-Keypair' => api_keypair })
          .to_return(status: 200, body: sample_response.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it { is_expected.to eq(JSON.parse(sample_response.to_json)) }
    end

    context "when request is not successful" do
      before do
        stub_request(:get, "#{base_uri}/public/events")
          .with(query: { page: '1', limit: '20' }, headers: { 'Accept' => 'application/json', 'Api-Keypair' => api_keypair })
          .to_return(status: 401, body: sample_error_response.to_json, headers: { 'Content-Type' => 'application/json' })
      end
      subject { described_class.new(api_key, api_secret) }

      it { expect { subject.get_public_events }.to raise_error(StandardError, "Billetto API Error: Invalid credentials") }
    end
  end
end
