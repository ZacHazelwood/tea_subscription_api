class Api::V1::SubscriptionsController < ApplicationController

  def index
    customer = Customer.find(params[:customer_id])
    render json: SubscriptionSerializer.new(customer.subscriptions)
  end

  def create
    subscription = Subscription.new(subscription_params)
      if subscription.save
        render json: SubscriptionSerializer.new(subscription), status: 201
      else
        render json: { error: subscription.errors.full_messages.to_sentence }, status: 400
      end
  end

  private
    def subscription_params
      params.permit(:title, :price, :status, :frequency, :tea_id, :customer_id)
    end
end
