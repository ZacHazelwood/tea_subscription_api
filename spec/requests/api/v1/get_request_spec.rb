require 'rails_helper'

RSpec.describe "Subscription GET Request, Index" do
  describe "happy path" do
    it "sends a response containing all of a customer's subscriptions" do
      Customer.destroy_all
      Tea.destroy_all
      Subscription.destroy_all
      customer = Customer.create!(first_name: "Zac", last_name: "Hazelwood", email: "email@gmail.com", address: "123 Real St")
      tea_1 = Tea.create!(title: "Earl Grey", description: "A fine tea.", temperature: 120, brew_time: 2)
      tea_2 = Tea.create!(title: "Citrus", description: "Probably not a tea.", temperature: 110, brew_time: 3)
      subscription_1 = customer.subscriptions.create!(title: "Earl Grey Weekly", price: 19.99, tea_id: tea_1.id, frequency: 0)
      subscription_2 = customer.subscriptions.create!(title: "Citrus Monthly", price: 39.99, tea_id: tea_2.id, status: 1, frequency: 1)

      get "/api/v1/customers/#{customer.id}/subscriptions"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      subscriptions = JSON.parse(response.body, symbolize_names: true)

      expect(subscriptions).to have_key :data
      expect(subscriptions[:data]).to be_a Array
      expect(subscriptions[:data].length).to eq(2)
      expect(subscriptions[:data][0].keys).to eq([:id, :type, :attributes])

      sub_1 = subscriptions[:data][0][:attributes]
      sub_2 = subscriptions[:data][1][:attributes]

      expect(sub_1.keys).to eq([:title, :price, :status, :frequency, :customer_id, :tea_id])
      expect(sub_2.keys).to eq([:title, :price, :status, :frequency, :customer_id, :tea_id])

      expect(sub_1[:status]).to eq("active")
      expect(sub_1[:frequency]).to eq("weekly")
      expect(sub_2[:status]).to eq("cancelled")
      expect(sub_2[:frequency]).to eq("monthly")
    end
  end

  describe "sad paths" do
    it "sends a successful response if no subscriptions are present" do
      Customer.destroy_all
      Tea.destroy_all
      Subscription.destroy_all
      customer = Customer.create!(first_name: "Zac", last_name: "Hazelwood", email: "email@gmail.com", address: "123 Real St")
      tea_1 = Tea.create!(title: "Earl Grey", description: "A fine tea.", temperature: 120, brew_time: 2)
      tea_2 = Tea.create!(title: "Citrus", description: "Probably not a tea.", temperature: 110, brew_time: 3)

      get "/api/v1/customers/#{customer.id}/subscriptions"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      subscriptions = JSON.parse(response.body, symbolize_names: true)

      expect(subscriptions).to have_key :message
      expect(subscriptions[:message]) .to eq("Customer has no subscriptions.")
    end

    it "sends an invalid response if customer does not exist" do
      Customer.destroy_all
      Tea.destroy_all
      Subscription.destroy_all
      customer = Customer.create!(id: 1, first_name: "Zac", last_name: "Hazelwood", email: "email@gmail.com", address: "123 Real St")
      tea_1 = Tea.create!(title: "Earl Grey", description: "A fine tea.", temperature: 120, brew_time: 2)
      tea_2 = Tea.create!(title: "Citrus", description: "Probably not a tea.", temperature: 110, brew_time: 3)

      get "/api/v1/customers/2/subscriptions"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      subscriptions = JSON.parse(response.body, symbolize_names: true)

      expect(subscriptions).to have_key :error
      expect(subscriptions[:error]).to eq("Customer ID does not exist.")
    end
  end
end
