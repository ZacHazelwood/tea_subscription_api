class Api::V1::SubscriptionsController < ApplicationController

  def index
    begin
      customer = Customer.find(params[:customer_id])
      if customer.nil? == false && customer.subscriptions.empty? == false
        render json: SubscriptionSerializer.new(customer.subscriptions), status: 200
      elsif customer.nil? == false && customer.subscriptions.empty? == true
        render json: { message: "Customer has no subscriptions."}, status: 200
      end
    rescue ActiveRecord::RecordNotFound
        render json: { error: "Customer ID does not exist." }, status: 400
    end
  end

  def create
    subscription = Subscription.new(subscription_params)
      if subscription.save
        render json: SubscriptionSerializer.new(subscription), status: 201
      else
        render json: { error: subscription.errors.full_messages.to_sentence }, status: 400
      end
  end

  def update
    subscription = Subscription.find(params[:subscription_id])
    subscription.update(subscription_params)
    render json: SubscriptionSerializer.new(subscription), status: 200
  end

  private
    def subscription_params
      params.permit(:title, :price, :status, :frequency, :tea_id, :customer_id)
    end
end
