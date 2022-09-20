require 'rails_helper'

RSpec.describe "Subscription POST Request" do
  describe "happy path" do
    it 'creates a customer subscription' do
      customer = Customer.create!(first_name: "Zac", last_name: "Hazelwood", email: "email@gmail.com", address: "123 Real St")
      tea = Tea.create!(title: "Earl Grey", description: "A fine tea.", temperature: 120, brew_time: 2)
      subscription_params =
        {
          title: "Earl Grey Weekly",
          price: 19.99,
          tea_id: tea.id,
          frequency: 0
        }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/customers/#{customer.id}/subscriptions", headers: headers, params: JSON.generate(subscription_params)

      subscription = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response).to have_http_status(201)

      expect(subscription).to have_key(:data)
      expect(subscription[:data].keys).to eq([:id, :type, :attributes])
      expect(subscription[:data][:type]).to eq("subscription")
      expect(subscription[:data][:attributes].keys).to eq([:title, :price, :status, :frequency, :customer_id, :tea_id])
      expect(subscription[:data][:attributes][:title]).to be_a String
      expect(subscription[:data][:attributes][:price]).to be_a Numeric
      expect(subscription[:data][:attributes][:status]).to be_a String
      expect(subscription[:data][:attributes][:frequency]).to be_a String

      expect(subscription[:data][:attributes]).to_not have_key(:brew_time)
    end
  end
end
