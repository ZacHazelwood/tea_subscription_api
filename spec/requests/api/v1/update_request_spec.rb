require 'rails_helper'

RSpec.describe 'Subscription PATCH Request' do
  describe 'happy path' do
    it "updates a subscription's status to 'cancelled'"do
      Customer.destroy_all
      Tea.destroy_all
      Subscription.destroy_all
      customer = Customer.create!(first_name: "Zac", last_name: "Hazelwood", email: "email@gmail.com", address: "123 Real St")
      tea = Tea.create!(title: "Earl Grey", description: "A fine tea.", temperature: 120, brew_time: 2)
      subscription = customer.subscriptions.create!(title: "Earl Grey Weekly", price: 19.99, tea_id: tea.id)

      expect(subscription.status).to eq("active")
      expect(subscription.frequency).to eq("weekly")

      update_params =
        {
          subscription_id: subscription.id,
          status: "cancelled"
        }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/customers/#{customer.id}/subscriptions/#{subscription.id}", headers: headers, params: JSON.generate(update_params)

      updated = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response).to have_http_status(200)

      expect(updated[:data][:attributes][:status]).to eq("cancelled")
      expect(updated[:data][:attributes][:status]).to_not eq("active")
    end

    it "updates a subscription's status to 'active'"do
      Customer.destroy_all
      Tea.destroy_all
      Subscription.destroy_all
      customer = Customer.create!(first_name: "Zac", last_name: "Hazelwood", email: "email@gmail.com", address: "123 Real St")
      tea = Tea.create!(title: "Earl Grey", description: "A fine tea.", temperature: 120, brew_time: 2)
      subscription = customer.subscriptions.create!(title: "Earl Grey Monthly", price: 39.99, tea_id: tea.id, status: 1, frequency: 1)

      expect(subscription.status).to eq("cancelled")
      expect(subscription.frequency).to eq("monthly")

      update_params =
        {
          subscription_id: subscription.id,
          status: "active"
        }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/customers/#{customer.id}/subscriptions/#{subscription.id}", headers: headers, params: JSON.generate(update_params)

      updated = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response).to have_http_status(200)

      expect(updated[:data][:attributes][:status]).to eq("active")
      expect(updated[:data][:attributes][:status]).to_not eq("cancelled")
    end

    it "updates other subscription parameters"do
      Customer.destroy_all
      Tea.destroy_all
      Subscription.destroy_all
      customer = Customer.create!(first_name: "Zac", last_name: "Hazelwood", email: "email@gmail.com", address: "123 Real St")
      tea = Tea.create!(title: "Earl Grey", description: "A fine tea.", temperature: 120, brew_time: 2)
      subscription = customer.subscriptions.create!(title: "Earl Grey Weekly", price: 19.99, tea_id: tea.id)

      expect(subscription.title).to eq("Earl Grey Weekly")
      expect(subscription.price).to eq(19.99)
      expect(subscription.status).to eq("active")
      expect(subscription.frequency).to eq("weekly")

      update_params =
        {
          subscription_id: subscription.id,
          title: "Earl Grey Monthly",
          price: 39.99,
          frequency: "monthly"
        }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/customers/#{customer.id}/subscriptions/#{subscription.id}", headers: headers, params: JSON.generate(update_params)

      updated = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response).to have_http_status(200)

      expect(updated[:data][:attributes][:status]).to eq("active")
      expect(updated[:data][:attributes][:status]).to_not eq("cancelled")
      expect(updated[:data][:attributes][:title]).to eq("Earl Grey Monthly")
      expect(updated[:data][:attributes][:price]).to eq(39.99)
      expect(updated[:data][:attributes][:frequency]).to eq("monthly")
    end
  end
end
